<#
.SYNOPSIS
    Generate JSON v2 general and domain-model outputs from mxcli.

.DESCRIPTION
    This library builds the Prompt 03 run-folder subset:

    - manifest.json
    - general/app-info.json
    - general/user-roles.json
    - general/all-modules.json
    - general/marketplace-modules.json
    - modules/<Module>/domain-model.json

    It reuses the shared mxcli foundation and keeps the legacy dump/parser
    route untouched.
#>

. (Join-Path $PSScriptRoot "mxcli-foundation.ps1")
. (Join-Path $PSScriptRoot "app-overview-resolver.ps1")

function Get-MxCliJsonRowValue {
    param(
        [object]$Row,
        [string]$ColumnName
    )

    if ($null -eq $Row -or [string]::IsNullOrWhiteSpace($ColumnName)) {
        return ""
    }

    $property = $Row.PSObject.Properties[$ColumnName]
    if ($null -eq $property) {
        return ""
    }

    return [string]$property.Value
}

function ConvertTo-MxCliNullableInt {
    param([object]$Value)

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    $trimmed = $text.Trim()
    if ($trimmed -match '^-+$') {
        return $null
    }

    $parsed = 0
    if ([int]::TryParse($trimmed, [ref]$parsed)) {
        return $parsed
    }

    return $null
}

function ConvertTo-MxCliBoolean {
    param(
        [object]$Value,
        [bool]$Default = $false
    )

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $Default
    }

    switch ($text.Trim().ToLowerInvariant()) {
        "true" { return $true }
        "false" { return $false }
        "yes" { return $true }
        "no" { return $false }
        "enabled" { return $true }
        "disabled" { return $false }
        "1" { return $true }
        "0" { return $false }
        default { return $Default }
    }
}

function ConvertTo-MxCliNullIfBlank {
    param([object]$Value)

    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    return $text.Trim()
}

function ConvertFrom-MxCliSecurityLevelDisplay {
    param([string]$DisplayValue)

    $value = if ($null -eq $DisplayValue) { "" } else { $DisplayValue.Trim() }
    switch ($value) {
        "Off" { return "CheckNothing" }
        "Prototype / demo" { return "CheckFormsAndMicroflows" }
        "Production" { return "CheckEverything" }
        default { return (ConvertTo-MxCliNullIfBlank -Value $DisplayValue) }
    }
}

function Split-MxCliCommaSeparatedList {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return @()
    }

    return @(
        $Text.Split(",") |
        ForEach-Object { $_.Trim() } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )
}

function Get-MxCliProjectSecurityObject {
    param([string]$ProjectPath)

    $result = Invoke-MxCliCommand -Arguments @("-p", $ProjectPath, "-c", "SHOW PROJECT SECURITY") -ThrowOnError
    $text = Get-MxCliTextOutput -Result $result
    $pairs = @{}

    foreach ($line in @(Split-MxCliLines -Text $text)) {
        if ($line -match '^\s*(?<key>[^:]+):\s*(?<value>.*)$') {
            $pairs[$matches.key.Trim()] = $matches.value.Trim()
        }
    }

    return [ordered]@{
        securityLevel = ConvertFrom-MxCliSecurityLevelDisplay -DisplayValue $pairs["Security Level"]
        adminUserName = ConvertTo-MxCliNullIfBlank -Value $pairs["Admin User"]
        enableGuestAccess = ConvertTo-MxCliBoolean -Value $pairs["Guest Access"]
        guestUserRoleName = ConvertTo-MxCliNullIfBlank -Value $pairs["Guest User Role"]
    }
}

function Get-MxCliUserRoleRows {
    param([string]$ProjectPath)

    $result = Invoke-MxCliCommand -Arguments @("-p", $ProjectPath, "-c", "SHOW USER ROLES") -ThrowOnError
    $table = ConvertFrom-MxCliMarkdownTableOutput -Result $result
    return @($table.Rows)
}

function Get-MxCliUserRoleDefinition {
    param(
        [string]$ProjectPath,
        [string]$UserRoleName
    )

    $result = Invoke-MxCliCommand -Arguments @("describe", "userrole", $UserRoleName, "-p", $ProjectPath) -ThrowOnError
    $mdl = ConvertFrom-MxCliMdlOutput -Result $result
    $createLine = @($mdl.Lines | Where-Object { $_ -match '^\s*CREATE USER ROLE ' } | Select-Object -First 1)[0]
    if ([string]::IsNullOrWhiteSpace($createLine)) {
        throw "Could not parse user role definition for $UserRoleName"
    }

    if ($createLine -notmatch '^CREATE USER ROLE (?<name>.+?) \((?<roles>.*)\)(?<suffix>.*);$') {
        throw "Unexpected user role format for ${UserRoleName}: $createLine"
    }
    $roleName = $matches.name.Trim()
    $roleMappings = @(Split-MxCliCommaSeparatedList -Text $matches.roles)
    $manageAllRoles = ($matches.suffix -match 'MANAGE ALL ROLES')

    $checkLine = @($mdl.Lines | Where-Object { $_ -match '^\s*-- Check security:\s*' } | Select-Object -First 1)[0]
    $checkSecurity = $false
    if (-not [string]::IsNullOrWhiteSpace($checkLine) -and $checkLine -match '^\s*-- Check security:\s*(?<value>.+)$') {
        $checkSecurity = ConvertTo-MxCliBoolean -Value $matches.value
    }

    return [ordered]@{
        name = $roleName
        moduleRoles = $roleMappings
        manageAllRoles = $manageAllRoles
        checkSecurity = $checkSecurity
    }
}

function Get-MxCliModuleRoleSummaries {
    param(
        [string]$ProjectPath,
        [string]$ModuleName
    )

    $statement = "SHOW MODULE ROLES IN $ModuleName"
    $result = Invoke-MxCliCommand -Arguments @("-p", $ProjectPath, "-c", $statement) -ThrowOnError
    $table = ConvertFrom-MxCliMarkdownTableOutput -Result $result

    return @(
        $table.Rows |
        Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "Role" } |
        ForEach-Object {
            [ordered]@{
                name = Get-MxCliJsonRowValue -Row $_ -ColumnName "Role"
                description = [string](Get-MxCliJsonRowValue -Row $_ -ColumnName "Description")
            }
        }
    )
}

function Get-MxCliShowModulesInventory {
    param([string]$ProjectPath)

    $showResult = Invoke-MxCliCommand -Arguments @("show", "modules", "-p", $ProjectPath) -ThrowOnError
    $showTable = ConvertFrom-MxCliMarkdownTableOutput -Result $showResult

    $catalogResult = Invoke-MxCliCatalogQuery -ProjectPath $ProjectPath -Query "SELECT * FROM CATALOG.modules" -ThrowOnError
    $catalogTable = ConvertFrom-MxCliMarkdownTableOutput -Result $catalogResult
    $catalogByName = @{}
    foreach ($row in @($catalogTable.Rows)) {
        $catalogByName[(Get-MxCliJsonRowValue -Row $row -ColumnName "Name")] = $row
    }

    $records = New-Object 'System.Collections.Generic.List[object]'
    foreach ($row in @($showTable.Rows)) {
        $moduleName = Get-MxCliJsonRowValue -Row $row -ColumnName "Module"
        if ([string]::IsNullOrWhiteSpace($moduleName)) {
            continue
        }

        $catalogRow = if ($catalogByName.ContainsKey($moduleName)) { $catalogByName[$moduleName] } else { $null }
        $sourceText = Get-MxCliJsonRowValue -Row $row -ColumnName "Source"
        $appStoreGuid = Get-MxCliJsonRowValue -Row $catalogRow -ColumnName "AppStoreGuid"
        $isSystemModule = Get-MxCliJsonRowValue -Row $catalogRow -ColumnName "IsSystemModule"

        $category = "Custom"
        if (-not [string]::IsNullOrWhiteSpace($appStoreGuid) -or $sourceText -like "Marketplace*") {
            $category = "Marketplace"
        } elseif ((ConvertTo-MxCliBoolean -Value $isSystemModule) -and [string]::IsNullOrWhiteSpace($appStoreGuid)) {
            $category = "System"
        }

        $records.Add([pscustomobject]@{
            Name = $moduleName
            Category = $category
            FromAppStore = ($category -eq "Marketplace")
            SourceText = $sourceText
            EntityCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Entities"))
            EnumerationCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Enums"))
            PageCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Pages"))
            SnippetCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Snippets"))
            MicroflowCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Microflows"))
            NanoflowCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Nanoflows"))
            WorkflowCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Workflows"))
            ConstantCount = [int](ConvertTo-MxCliNullableInt -Value (Get-MxCliJsonRowValue -Row $row -ColumnName "Constants"))
        }) | Out-Null
    }

    return @($records.ToArray() | Sort-Object Name)
}

function Resolve-MxCliSelectedModules {
    param(
        [object[]]$AvailableModules,
        [string[]]$SelectedModules
    )

    $availableByLowerName = @{}
    foreach ($module in @($AvailableModules)) {
        $availableByLowerName[$module.Name.ToLowerInvariant()] = $module
    }

    if ($null -eq $SelectedModules -or @($SelectedModules).Count -eq 0) {
        return @($AvailableModules | Sort-Object Name)
    }

    $resolved = New-Object 'System.Collections.Generic.List[object]'
    foreach ($selectedModule in @($SelectedModules)) {
        $key = ([string]$selectedModule).Trim().ToLowerInvariant()
        if ([string]::IsNullOrWhiteSpace($key)) {
            continue
        }

        if (-not $availableByLowerName.ContainsKey($key)) {
            throw "Selected module is not available from the installed mxcli module inventory: $selectedModule"
        }

        $resolved.Add($availableByLowerName[$key]) | Out-Null
    }

    return @($resolved.ToArray() | Sort-Object Name -Unique)
}

function Get-MxCliCatalogRows {
    param(
        [string]$ProjectPath,
        [string]$Query,
        [ValidateSet("Fast", "Full", "Source")]
        [string]$CatalogStage = "Fast"
    )

    $result = Invoke-MxCliCatalogQuery -ProjectPath $ProjectPath -Query $Query -CatalogStage $CatalogStage -ThrowOnError
    $table = ConvertFrom-MxCliMarkdownTableOutput -Result $result
    return @(
        $table.Rows |
        Where-Object {
            $rowValues = @($_.PSObject.Properties | ForEach-Object { [string]$_.Value })
            -not (@($rowValues | Where-Object { $_ -match '^-+$' }).Count -eq $rowValues.Count)
        }
    )
}

function Get-MxCliAssociationRowsForModule {
    param(
        [string]$ProjectPath,
        [string]$ModuleName
    )

    $result = Invoke-MxCliCommand -Arguments @("show", "associations", $ModuleName, "-p", $ProjectPath) -ThrowOnError
    $table = ConvertFrom-MxCliMarkdownTableOutput -Result $result
    return @($table.Rows)
}

function ConvertTo-MxCliAssociationCardinality {
    param(
        [string]$AssociationType,
        [string]$Owner
    )

    switch ($AssociationType) {
        "ReferenceSet" { return "*-*" }
        "Reference" {
            switch ($Owner) {
                "Both" { return "1-1" }
                "Default" { return "*-1" }
                default { return $null }
            }
        }
        default { return $null }
    }
}

function ConvertTo-MxCliAttributeTypeName {
    param([string]$BaseType)

    switch ($BaseType) {
        "String" { return "StringAttributeType" }
        "Integer" { return "IntegerAttributeType" }
        "Long" { return "LongAttributeType" }
        "Decimal" { return "DecimalAttributeType" }
        "DateTime" { return "DateTimeAttributeType" }
        "Boolean" { return "BooleanAttributeType" }
        "Enumeration" { return "EnumerationAttributeType" }
        "AutoNumber" { return "AutoNumberAttributeType" }
        "Binary" { return "BinaryAttributeType" }
        "HashString" { return "HashStringAttributeType" }
        default { return "${BaseType}AttributeType" }
    }
}

function New-MxCliParsedAttributeDefinition {
    param(
        [string]$EntityQualifiedName,
        [string]$Line
    )

    $trimmed = if ($null -eq $Line) { "" } else { $Line.Trim().TrimEnd(",") }
    if ([string]::IsNullOrWhiteSpace($trimmed)) {
        return $null
    }

    $separatorIndex = $trimmed.IndexOf(":")
    if ($separatorIndex -lt 1) {
        return $null
    }

    $name = $trimmed.Substring(0, $separatorIndex).Trim()
    $definition = $trimmed.Substring($separatorIndex + 1).Trim()

    $defaultValue = $null
    $defaultMarkerIndex = $definition.IndexOf(" DEFAULT ", [System.StringComparison]::OrdinalIgnoreCase)
    if ($defaultMarkerIndex -ge 0) {
        $defaultValue = $definition.Substring($defaultMarkerIndex + 9).Trim()
        $definition = $definition.Substring(0, $defaultMarkerIndex).Trim()
    }

    $baseType = $definition
    $typeArgument = $null
    if ($definition -match '^(?<base>[A-Za-z]+)\((?<argument>.+)\)$') {
        $baseType = $matches.base
        $typeArgument = $matches.argument
    }

    $enumerationName = $null
    $length = $null
    if ($baseType -eq "Enumeration") {
        $enumerationName = $typeArgument
    } elseif ($baseType -eq "String" -and -not [string]::IsNullOrWhiteSpace($typeArgument)) {
        $length = ConvertTo-MxCliNullableInt -Value $typeArgument
    }

    if (-not [string]::IsNullOrWhiteSpace($defaultValue) -and $baseType -eq "Enumeration" -and $defaultValue.Contains(".")) {
        $defaultValue = $defaultValue.Substring($defaultValue.LastIndexOf(".") + 1)
    }

    return [pscustomobject]@{
        LocalName = $name
        QualifiedName = "$EntityQualifiedName.$name"
        Output = [ordered]@{
            name = $name
            type = ConvertTo-MxCliAttributeTypeName -BaseType $baseType
            enumerationName = $(if ($baseType -eq "Enumeration") { $enumerationName } else { $null })
            length = $length
            defaultValue = ConvertTo-MxCliNullIfBlank -Value $defaultValue
            validationSummary = $null
        }
    }
}

function Get-MxCliGrantMembers {
    param(
        [string]$PermissionText,
        [string]$Keyword
    )

    $pattern = "$Keyword\s*\((?<members>[^)]*)\)"
    if ($PermissionText -notmatch $pattern) {
        return @()
    }

    return @(Split-MxCliCommaSeparatedList -Text $matches.members)
}

function Get-MxCliPermissionStatement {
    param([string]$GrantLine)

    if ($GrantLine -notmatch "^GRANT\s+(?<roles>.+?)\s+ON\s+(?<entity>\S+)\s+\((?<permissions>.+)\)\s*(?:WHERE\s+'(?<xpath>.+)')?;\s*$") {
        throw "Unexpected GRANT statement format: $GrantLine"
    }

    $permissionText = $matches.permissions
    return [pscustomobject]@{
        ModuleRoles = @(Split-MxCliCommaSeparatedList -Text $matches.roles)
        EntityName = $matches.entity
        PermissionText = $permissionText
        AllowCreate = ($permissionText -match '(^|,\s*)CREATE(,|$)')
        AllowDelete = ($permissionText -match '(^|,\s*)DELETE(,|$)')
        ReadMembers = @(Get-MxCliGrantMembers -PermissionText $permissionText -Keyword "READ")
        WriteMembers = @(Get-MxCliGrantMembers -PermissionText $permissionText -Keyword "WRITE")
        XPathConstraint = ConvertTo-MxCliNullIfBlank -Value $matches.xpath
    }
}

function Get-MxCliOrderedMemberNames {
    param(
        [string[]]$LocalAttributeQualifiedNames,
        [string[]]$AttachedAssociationQualifiedNames,
        [string[]]$ReadMembers,
        [string[]]$WriteMembers,
        [hashtable]$AssociationNameSet
    )

    $ordered = New-Object 'System.Collections.Generic.List[string]'
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $extraAttributes = New-Object 'System.Collections.Generic.List[string]'
    $extraAssociations = New-Object 'System.Collections.Generic.List[string]'

    foreach ($memberName in @($ReadMembers + $WriteMembers)) {
        if ([string]::IsNullOrWhiteSpace($memberName)) {
            continue
        }

        if ($seen.Contains($memberName)) {
            continue
        }

        $isAssociation = $AssociationNameSet.ContainsKey($memberName.ToLowerInvariant())
        if ($isAssociation) {
            $extraAssociations.Add($memberName) | Out-Null
        } else {
            $extraAttributes.Add($memberName) | Out-Null
        }
        [void]$seen.Add($memberName)
    }

    foreach ($memberName in @($LocalAttributeQualifiedNames + $extraAttributes + $AttachedAssociationQualifiedNames + $extraAssociations)) {
        if ([string]::IsNullOrWhiteSpace($memberName)) {
            continue
        }

        if ($seen.Contains($memberName)) {
            $seen.Remove($memberName) | Out-Null
            $ordered.Add($memberName) | Out-Null
            continue
        }

        if (@($ordered | Where-Object { $_ -eq $memberName }).Count -eq 0) {
            $ordered.Add($memberName) | Out-Null
        }
    }

    return @($ordered.ToArray())
}

function Get-MxCliMemberAccessRights {
    param(
        [string]$MemberName,
        [string[]]$ReadMembers,
        [string[]]$WriteMembers
    )

    $hasRead = @($ReadMembers | Where-Object { $_ -eq $MemberName }).Count -gt 0
    $hasWrite = @($WriteMembers | Where-Object { $_ -eq $MemberName }).Count -gt 0

    if ($hasRead -and $hasWrite) {
        return "ReadWrite"
    }
    if ($hasRead) {
        return "ReadOnly"
    }
    if ($hasWrite) {
        return "ReadWrite"
    }
    return "None"
}

function Get-MxCliMemberKind {
    param(
        [string]$MemberName,
        [hashtable]$AssociationNameSet
    )

    $normalizedMemberName = if ($null -eq $MemberName) { "" } else { $MemberName.ToLowerInvariant() }
    if ($AssociationNameSet.ContainsKey($normalizedMemberName)) {
        return "Association"
    }

    return "Attribute"
}

function Get-MxCliEntityDefinition {
    param(
        [string]$ProjectPath,
        [object]$EntityRow,
        [object[]]$ModuleAssociationRows,
        [hashtable]$AssociationNameSet
    )

    $entityQualifiedName = Get-MxCliJsonRowValue -Row $EntityRow -ColumnName "QualifiedName"
    $result = Invoke-MxCliCommand -Arguments @("describe", "entity", $entityQualifiedName, "-p", $ProjectPath) -ThrowOnError
    $mdl = ConvertFrom-MxCliMdlOutput -Result $result
    $lines = @($mdl.Lines)

    $createLineIndex = -1
    $closingLineIndex = -1
    for ($index = 0; $index -lt $lines.Count; $index += 1) {
        if ($createLineIndex -lt 0 -and $lines[$index] -match '^\s*CREATE ') {
            $createLineIndex = $index
        }
        if ($createLineIndex -ge 0 -and $lines[$index] -match '^\s*\)\s*;?\s*$') {
            $closingLineIndex = $index
            break
        }
    }

    if ($createLineIndex -lt 0 -or $closingLineIndex -le $createLineIndex) {
        throw "Could not parse attribute block for entity $entityQualifiedName"
    }

    $attributeDefinitions = New-Object 'System.Collections.Generic.List[object]'
    for ($index = $createLineIndex + 1; $index -lt $closingLineIndex; $index += 1) {
        $attribute = New-MxCliParsedAttributeDefinition -EntityQualifiedName $entityQualifiedName -Line $lines[$index]
        if ($null -ne $attribute) {
            $attributeDefinitions.Add($attribute) | Out-Null
        }
    }

    $attachedAssociationQualifiedNames = New-Object 'System.Collections.Generic.List[string]'
    foreach ($associationRow in @($ModuleAssociationRows)) {
        $parentEntity = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Parent"
        $childEntity = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Child"
        if ($parentEntity -ne $entityQualifiedName -and $childEntity -ne $entityQualifiedName) {
            continue
        }

        $qualifiedAssociationName = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Qualified Name"
        if (-not [string]::IsNullOrWhiteSpace($qualifiedAssociationName)) {
            $attachedAssociationQualifiedNames.Add($qualifiedAssociationName) | Out-Null
        }
    }

    $localAttributeQualifiedNames = @($attributeDefinitions | ForEach-Object { [string]$_.QualifiedName })
    $grantLines = @($lines | Where-Object { $_ -match '^\s*GRANT ' })
    $accessRules = New-Object 'System.Collections.Generic.List[object]'
    $ruleIndex = 1

    foreach ($grantLine in @($grantLines)) {
        $statement = Get-MxCliPermissionStatement -GrantLine $grantLine.Trim()
        $orderedMemberNames = Get-MxCliOrderedMemberNames `
            -LocalAttributeQualifiedNames $localAttributeQualifiedNames `
            -AttachedAssociationQualifiedNames @($attachedAssociationQualifiedNames.ToArray()) `
            -ReadMembers $statement.ReadMembers `
            -WriteMembers $statement.WriteMembers `
            -AssociationNameSet $AssociationNameSet

        $memberAccesses = New-Object 'System.Collections.Generic.List[object]'
        foreach ($memberName in @($orderedMemberNames)) {
            $memberAccesses.Add([ordered]@{
                memberName = $memberName
                memberKind = Get-MxCliMemberKind -MemberName $memberName -AssociationNameSet $AssociationNameSet
                accessRights = Get-MxCliMemberAccessRights -MemberName $memberName -ReadMembers $statement.ReadMembers -WriteMembers $statement.WriteMembers
            }) | Out-Null
        }

        $accessRules.Add([ordered]@{
            ruleKey = "rule-$ruleIndex"
            moduleRoles = @($statement.ModuleRoles)
            allowCreate = $statement.AllowCreate
            allowDelete = $statement.AllowDelete
            defaultMemberAccessRights = $null
            xPathConstraint = $statement.XPathConstraint
            xPathEvidence = $(if ($null -ne $statement.XPathConstraint) {
                [ordered]@{
                    constraint = $statement.XPathConstraint
                    summary = $statement.XPathConstraint
                }
            } else {
                $null
            })
            memberAccesses = @($memberAccesses.ToArray())
        }) | Out-Null

        $ruleIndex += 1
    }

    return [ordered]@{
        name = $entityQualifiedName
        isPersistable = ((Get-MxCliJsonRowValue -Row $EntityRow -ColumnName "EntityType") -eq "PERSISTENT")
        generalization = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $EntityRow -ColumnName "Generalization")
        attributes = @($attributeDefinitions | ForEach-Object { $_.Output })
        accessRules = @($accessRules.ToArray())
    }
}

function Get-MxCliEnumerationDefinition {
    param(
        [string]$ProjectPath,
        [object]$EnumerationRow
    )

    $qualifiedName = Get-MxCliJsonRowValue -Row $EnumerationRow -ColumnName "QualifiedName"
    $result = Invoke-MxCliCommand -Arguments @("describe", "enumeration", $qualifiedName, "-p", $ProjectPath) -ThrowOnError
    $mdl = ConvertFrom-MxCliMdlOutput -Result $result

    $values = New-Object 'System.Collections.Generic.List[string]'
    foreach ($line in @($mdl.Lines)) {
        if ($line -match '^\s*(?<name>[^''\s,]+)(?:\s+''[^'']*'')?,?\s*$') {
            $candidate = $matches.name.Trim()
            if ($candidate -notin @("CREATE", "/", ");")) {
                $values.Add($candidate) | Out-Null
            }
        }
    }

    return [ordered]@{
        name = $qualifiedName
        values = @($values.ToArray() | Sort-Object -Unique)
    }
}

function Get-MxCliModuleDomainModelObject {
    param(
        [string]$ProjectPath,
        [object]$ModuleRecord,
        [object[]]$EntityRows,
        [object[]]$EnumerationRows,
        [object[]]$AssociationRows,
        [hashtable]$AssociationNameSet
    )

    $moduleName = $ModuleRecord.Name
    $moduleEntities = @($EntityRows | Where-Object { (Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName") -eq $moduleName } | Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "QualifiedName" })
    $moduleEnumerations = @($EnumerationRows | Where-Object { (Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName") -eq $moduleName } | Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "QualifiedName" })
    $sortedAssociations = @($AssociationRows | Sort-Object { Get-MxCliJsonRowValue -Row $_ -ColumnName "Qualified Name" })

    $entities = New-Object 'System.Collections.Generic.List[object]'
    foreach ($entityRow in @($moduleEntities)) {
        $entities.Add((Get-MxCliEntityDefinition -ProjectPath $ProjectPath -EntityRow $entityRow -ModuleAssociationRows $sortedAssociations -AssociationNameSet $AssociationNameSet)) | Out-Null
    }

    $enumerations = New-Object 'System.Collections.Generic.List[object]'
    foreach ($enumerationRow in @($moduleEnumerations)) {
        $enumerations.Add((Get-MxCliEnumerationDefinition -ProjectPath $ProjectPath -EnumerationRow $enumerationRow)) | Out-Null
    }

    $associations = New-Object 'System.Collections.Generic.List[object]'
    foreach ($associationRow in @($sortedAssociations)) {
        $associations.Add([ordered]@{
            name = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Qualified Name"
            parentEntity = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Parent"
            childEntity = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Child"
            cardinality = ConvertTo-MxCliAssociationCardinality `
                -AssociationType (Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Type") `
                -Owner (Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Owner")
            type = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Type")
            owner = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Owner")
            storageFormat = ConvertTo-MxCliNullIfBlank -Value (Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Storage")
        }) | Out-Null
    }

    return [ordered]@{
        module = $moduleName
        domainModel = [ordered]@{
            entities = @($entities.ToArray())
            associations = @($associations.ToArray())
            enumerations = @($enumerations.ToArray())
        }
    }
}

function Get-MxCliRunFolderName {
    return "mxcli_{0}" -f (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH-mm-ss.fffZ")
}

function Get-MxCliModuleExportRelativeDir {
    param([object]$ModuleRecord)

    if ($ModuleRecord.Category -eq "Marketplace") {
        return "modules/marketplace/$($ModuleRecord.Name)"
    }

    return "modules/$($ModuleRecord.Name)"
}

function New-MxCliJsonV2GeneralDomainRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ProjectPath,
        [Parameter(Mandatory)]
        [string]$AppOverviewRoot,
        [string]$RunId,
        [string[]]$SelectedModules,
        [switch]$SyncCurrent,
        [string]$CurrentAliasPath
    )

    if (-not (Test-Path $ProjectPath -PathType Leaf)) {
        throw "ProjectPath does not exist: $ProjectPath"
    }

    $resolvedProjectPath = (Resolve-Path $ProjectPath).Path
    $resolvedAppOverviewRoot = [System.IO.Path]::GetFullPath($AppOverviewRoot)
    if (-not (Test-Path $resolvedAppOverviewRoot -PathType Container)) {
        New-Item -Path $resolvedAppOverviewRoot -ItemType Directory -Force | Out-Null
    }

    if ([string]::IsNullOrWhiteSpace($RunId)) {
        $RunId = Get-MxCliRunFolderName
    }

    $runFolder = Join-Path $resolvedAppOverviewRoot $RunId
    if (Test-Path $runFolder) {
        Remove-Item -Path $runFolder -Recurse -Force
    }
    New-Item -Path $runFolder -ItemType Directory -Force | Out-Null

    $generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    $moduleInventoryBase = @(Get-MxCliShowModulesInventory -ProjectPath $resolvedProjectPath)
    $selectedModuleRecords = @(Resolve-MxCliSelectedModules -AvailableModules $moduleInventoryBase -SelectedModules $SelectedModules)
    $selectedModuleNames = @($selectedModuleRecords | ForEach-Object { [string]$_.Name })
    $selectedModuleNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($moduleName in @($selectedModuleNames)) {
        [void]$selectedModuleNameSet.Add($moduleName)
    }

    $entityRows = @(Get-MxCliCatalogRows -ProjectPath $resolvedProjectPath -Query "SELECT * FROM CATALOG.entities")
    $enumerationRows = @(Get-MxCliCatalogRows -ProjectPath $resolvedProjectPath -Query "SELECT * FROM CATALOG.enumerations")
    $activityRows = @(Get-MxCliCatalogRows -ProjectPath $resolvedProjectPath -Query "SELECT * FROM CATALOG.activities" -CatalogStage Full)
    $callRefRows = @(Get-MxCliCatalogRows -ProjectPath $resolvedProjectPath -Query "SELECT * FROM CATALOG.refs WHERE RefKind = 'call'" -CatalogStage Full)

    $projectSecurityObject = Get-MxCliProjectSecurityObject -ProjectPath $resolvedProjectPath
    $userRoleRows = @(Get-MxCliUserRoleRows -ProjectPath $resolvedProjectPath)

    $artifacts = New-Object 'System.Collections.Generic.List[object]'
    $seenArtifactKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $generalDir = Join-Path $runFolder "general"
    New-Item -Path $generalDir -ItemType Directory -Force | Out-Null

    $allModuleSummaries = New-Object 'System.Collections.Generic.List[object]'
    $marketplaceModuleSummaries = New-Object 'System.Collections.Generic.List[object]'
    $domainModelByModule = @{}
    $associationNameSet = @{}

    $associationRowsByModule = @{}
    foreach ($moduleRecord in @($selectedModuleRecords)) {
        $moduleAssociations = @(Get-MxCliAssociationRowsForModule -ProjectPath $resolvedProjectPath -ModuleName $moduleRecord.Name)
        $associationRowsByModule[$moduleRecord.Name] = $moduleAssociations
        foreach ($associationRow in @($moduleAssociations)) {
            $associationName = Get-MxCliJsonRowValue -Row $associationRow -ColumnName "Qualified Name"
            if (-not [string]::IsNullOrWhiteSpace($associationName)) {
                $associationNameSet[$associationName.ToLowerInvariant()] = $true
            }
        }
    }

    foreach ($moduleRecord in @($selectedModuleRecords | Sort-Object Name)) {
        $moduleRoles = @(Get-MxCliModuleRoleSummaries -ProjectPath $resolvedProjectPath -ModuleName $moduleRecord.Name)
        $flowCount = $moduleRecord.MicroflowCount + $moduleRecord.NanoflowCount + $moduleRecord.WorkflowCount
        $moduleSummary = [ordered]@{
            module = $moduleRecord.Name
            category = $moduleRecord.Category
            fromAppStore = [bool]$moduleRecord.FromAppStore
            moduleRoles = @($moduleRoles)
            entityCount = [int]$moduleRecord.EntityCount
            flowCount = [int]$flowCount
            pageCount = [int]$moduleRecord.PageCount
            constantCount = [int]$moduleRecord.ConstantCount
        }
        $allModuleSummaries.Add($moduleSummary) | Out-Null

        if ($moduleRecord.Category -eq "Marketplace") {
            $marketplaceModuleSummaries.Add([ordered]@{
                module = $moduleRecord.Name
                moduleRoles = @($moduleRoles)
                entityCount = [int]$moduleRecord.EntityCount
                flowCount = [int]$flowCount
                pageCount = [int]$moduleRecord.PageCount
            }) | Out-Null
        }

        $domainModelObject = Get-MxCliModuleDomainModelObject `
            -ProjectPath $resolvedProjectPath `
            -ModuleRecord $moduleRecord `
            -EntityRows $entityRows `
            -EnumerationRows $enumerationRows `
            -AssociationRows @($associationRowsByModule[$moduleRecord.Name]) `
            -AssociationNameSet $associationNameSet
        $domainModelByModule[$moduleRecord.Name] = $domainModelObject

        $moduleDir = Join-Path $runFolder ((Get-MxCliModuleExportRelativeDir -ModuleRecord $moduleRecord) -replace "/", "\")
        New-Item -Path $moduleDir -ItemType Directory -Force | Out-Null
        $domainModelPath = Join-Path $moduleDir "domain-model.json"
        Write-JsonUtf8NoBom -Path $domainModelPath -Value $domainModelObject
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "module-domain-model-json" -Path $domainModelPath
    }

    $userRoles = New-Object 'System.Collections.Generic.List[object]'
    foreach ($roleRow in @($userRoleRows)) {
        $roleName = Get-MxCliJsonRowValue -Row $roleRow -ColumnName "Name"
        if ([string]::IsNullOrWhiteSpace($roleName)) {
            continue
        }

        $definition = Get-MxCliUserRoleDefinition -ProjectPath $resolvedProjectPath -UserRoleName $roleName
        $userRoles.Add([ordered]@{
            name = $definition.name
            moduleRoles = @($definition.moduleRoles)
            manageAllRoles = [bool]$definition.manageAllRoles
            checkSecurity = [bool]$definition.checkSecurity
        }) | Out-Null
    }

    $generatedAssociationCount = @(
        $domainModelByModule.Values |
        ForEach-Object { @($_.domainModel.associations).Count } |
        Measure-Object -Sum
    ).Sum
    $generatedEnumerationCount = @(
        $domainModelByModule.Values |
        ForEach-Object { @($_.domainModel.enumerations).Count } |
        Measure-Object -Sum
    ).Sum

    $microflowCount = @($selectedModuleRecords | Measure-Object -Property MicroflowCount -Sum).Sum
    $nanoflowCount = @($selectedModuleRecords | Measure-Object -Property NanoflowCount -Sum).Sum
    $workflowCount = @($selectedModuleRecords | Measure-Object -Property WorkflowCount -Sum).Sum
    $flowNodeCount = @($activityRows | Where-Object { $selectedModuleNameSet.Contains((Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName")) }).Count
    $flowCallEdgeCount = @($callRefRows | Where-Object { $selectedModuleNameSet.Contains((Get-MxCliJsonRowValue -Row $_ -ColumnName "ModuleName")) }).Count

    $appInfoObject = [ordered]@{
        schemaVersion = "2.0"
        generatedAtUtc = $generatedAtUtc
        sourceMprPath = $resolvedProjectPath
        sourceDumpPath = $null
        summary = [ordered]@{
            moduleCount = @($selectedModuleRecords).Count
            entityCount = @($selectedModuleRecords | Measure-Object -Property EntityCount -Sum).Sum
            associationCount = [int]$generatedAssociationCount
            enumerationCount = [int]$generatedEnumerationCount
            flowCount = [int]($microflowCount + $nanoflowCount + $workflowCount)
            microflowCount = [int]$microflowCount
            nanoflowCount = [int]$nanoflowCount
            ruleCount = $null
            workflowCount = [int]$workflowCount
            flowNodeCount = [int]$flowNodeCount
            flowEdgeCount = $null
            flowCallEdgeCount = [int]$flowCallEdgeCount
        }
    }

    $userRolesObject = [ordered]@{
        projectSecurity = [ordered]@{
            securityLevel = $projectSecurityObject.securityLevel
            adminUserName = $projectSecurityObject.adminUserName
            enableGuestAccess = [bool]$projectSecurityObject.enableGuestAccess
            guestUserRoleName = $projectSecurityObject.guestUserRoleName
            userRoles = @($userRoles.ToArray())
        }
    }

    $allModulesObject = [ordered]@{
        modules = @($allModuleSummaries.ToArray())
    }

    $marketplaceModulesObject = [ordered]@{
        modules = @($marketplaceModuleSummaries.ToArray())
    }

    $appInfoPath = Join-Path $generalDir "app-info.json"
    $userRolesPath = Join-Path $generalDir "user-roles.json"
    $allModulesPath = Join-Path $generalDir "all-modules.json"
    $marketplaceModulesPath = Join-Path $generalDir "marketplace-modules.json"

    Write-JsonUtf8NoBom -Path $appInfoPath -Value $appInfoObject
    Write-JsonUtf8NoBom -Path $userRolesPath -Value $userRolesObject
    Write-JsonUtf8NoBom -Path $allModulesPath -Value $allModulesObject
    Write-JsonUtf8NoBom -Path $marketplaceModulesPath -Value $marketplaceModulesObject

    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-app-info-json" -Path $appInfoPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-user-roles-json" -Path $userRolesPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-all-modules-json" -Path $allModulesPath
    Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type "general-marketplace-modules-json" -Path $marketplaceModulesPath

    $resolvedSelectedModules = @()
    if ($null -ne $SelectedModules -and @($SelectedModules).Count -gt 0) {
        $resolvedSelectedModules = @($selectedModuleRecords | ForEach-Object { [string]$_.Name })
    }
    $resolvedSelectedModuleArray = @($resolvedSelectedModules)
    $artifactArray = @($artifacts.ToArray())

    $manifestObject = [ordered]@{
        schemaVersion = "2.0"
        generatedAtUtc = $generatedAtUtc
        selectedModules = $resolvedSelectedModuleArray
        generator = "mxcli"
        artifactCount = $artifactArray.Count
        artifacts = $artifactArray
    }

    $manifestPath = Join-Path $runFolder "manifest.json"
    Write-JsonUtf8NoBom -Path $manifestPath -Value $manifestObject

    if ($SyncCurrent) {
        Sync-AppOverviewCurrentAlias -RunFolder $runFolder -CurrentAliasPath $CurrentAliasPath | Out-Null
    }

    return [pscustomobject]@{
        RunFolder = $runFolder
        ManifestPath = $manifestPath
        GeneratedAtUtc = $generatedAtUtc
        Modules = @($selectedModuleRecords)
    }
}
