function Write-JsonUtf8NoBom {
    param(
        [string]$Path,
        [object]$Value
    )

    $directory = Split-Path -Parent $Path
    if (-not [string]::IsNullOrWhiteSpace($directory) -and -not (Test-Path $directory -PathType Container)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    $json = $Value | ConvertTo-Json -Depth 20
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json + "`n", $utf8NoBom)
}

function Get-OverviewLogicalPath {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) { return "" }
    return ($Path -replace "\\", "/")
}

function Build-OverviewObjectSlug {
    param(
        [string]$QualifiedName,
        [string]$StableId,
        [hashtable]$UsedSlugs
    )

    $baseSlug = ([string]$QualifiedName).ToLowerInvariant() -replace "[^a-z0-9]+", "-"
    $baseSlug = ($baseSlug -replace "-+", "-").Trim("-")
    if ([string]::IsNullOrWhiteSpace($baseSlug)) {
        $baseSlug = "object"
    }

    if (-not $UsedSlugs.ContainsKey($baseSlug)) {
        $UsedSlugs[$baseSlug] = $true
        return $baseSlug
    }

    $stableSuffix = (([string]$StableId).ToLowerInvariant() -replace "[^a-z0-9]+", "")
    if ($stableSuffix.Length -lt 8) {
        $stableSuffix = $stableSuffix.PadRight(8, "0")
    }

    $candidate = "$baseSlug-$($stableSuffix.Substring(0, 8))"
    $counter = 2
    while ($UsedSlugs.ContainsKey($candidate)) {
        $candidate = "$baseSlug-$($stableSuffix.Substring(0, 8))-$counter"
        $counter++
    }

    $UsedSlugs[$candidate] = $true
    return $candidate
}

function Load-OverviewManifest {
    param(
        [Alias("RunFolderPath")]
        [string]$RunFolder
    )

    if ([string]::IsNullOrWhiteSpace($RunFolder)) {
        throw "Load-OverviewManifest requires a run folder path."
    }

    $manifestPath = Join-Path $RunFolder "manifest.json"
    if (-not (Test-Path $manifestPath -PathType Leaf)) {
        throw "RunFolder manifest.json missing: $manifestPath"
    }

    return (Get-Content -Raw $manifestPath | ConvertFrom-Json)
}

function Get-OverviewModuleInfoFromArtifactPath {
    param([string]$ArtifactPath)

    if ([string]::IsNullOrWhiteSpace($ArtifactPath)) { return $null }
    $logicalPath = Get-OverviewLogicalPath -Path $ArtifactPath

    if ($logicalPath -match "(?:^|/)modules/(marketplace/)?([^/]+)/") {
        $moduleName = $matches[2]
        $isMarketplace = -not [string]::IsNullOrWhiteSpace($matches[1])
        return [pscustomobject]@{
            ModuleName = $moduleName
            ExportRelativeDir = if ($isMarketplace) { "modules/marketplace/$moduleName" } else { "modules/$moduleName" }
            PathCategory = if ($isMarketplace) { "Marketplace" } else { "Unknown" }
        }
    }

    return $null
}

function Get-OverviewModuleCatalog {
    param(
        [Alias("RunFolderPath")]
        [string]$RunFolder,
        [Alias("ManifestObject")]
        [object]$Manifest
    )

    if ([string]::IsNullOrWhiteSpace($RunFolder)) {
        throw "Get-OverviewModuleCatalog requires a run folder path."
    }

    if ($null -eq $Manifest) {
        $Manifest = Load-OverviewManifest -RunFolder $RunFolder
    }

    $categoryByName = @{}
    $allModulesPath = Join-Path $RunFolder "general/all-modules.json"
    if (Test-Path $allModulesPath -PathType Leaf) {
        $allModules = Get-Content -Raw $allModulesPath | ConvertFrom-Json
        foreach ($moduleInfo in @($allModules.modules)) {
            $categoryByName[[string]$moduleInfo.module] = [string]$moduleInfo.category
        }
    }

    $exportRelativeDirByName = @{}
    foreach ($artifact in @($Manifest.artifacts)) {
        $info = Get-OverviewModuleInfoFromArtifactPath -ArtifactPath ([string]$artifact.path)
        if ($null -eq $info) { continue }
        if (-not $exportRelativeDirByName.ContainsKey($info.ModuleName)) {
            $exportRelativeDirByName[$info.ModuleName] = $info
        }
    }

    $moduleNames = New-Object System.Collections.Generic.List[string]
    foreach ($name in @($categoryByName.Keys + $exportRelativeDirByName.Keys | Sort-Object -Unique)) {
        if (-not [string]::IsNullOrWhiteSpace([string]$name)) {
            $moduleNames.Add([string]$name) | Out-Null
        }
    }

    $catalog = New-Object System.Collections.Generic.List[object]
    foreach ($moduleName in @($moduleNames | Sort-Object)) {
        $pathInfo = $null
        if ($exportRelativeDirByName.ContainsKey($moduleName)) {
            $pathInfo = $exportRelativeDirByName[$moduleName]
        }

        $category = if ($categoryByName.ContainsKey($moduleName)) {
            [string]$categoryByName[$moduleName]
        } elseif ($null -ne $pathInfo) {
            [string]$pathInfo.PathCategory
        } else {
            "Unknown"
        }

        $exportRelativeDir = if ($null -ne $pathInfo) {
            [string]$pathInfo.ExportRelativeDir
        } elseif ($category -eq "Marketplace") {
            "modules/marketplace/$moduleName"
        } else {
            "modules/$moduleName"
        }

        $kbRelativeDir = if ($category -eq "Marketplace") {
            "modules/_marktplace/$moduleName"
        } else {
            "modules/$moduleName"
        }

        $catalog.Add([pscustomobject]@{
            Name = $moduleName
            Category = $category
            ExportRelativeDir = $exportRelativeDir
            KbRelativeDir = $kbRelativeDir
            KbLogicalRelativeDir = "knowledge-base/$kbRelativeDir"
        }) | Out-Null
    }

    return $catalog.ToArray()
}

function Get-OverviewModuleCatalogMap {
    param(
        [Alias("Catalog")]
        [object[]]$ModuleCatalog
    )

    $map = @{}
    foreach ($entry in @($ModuleCatalog)) {
        $map[[string]$entry.Name] = $entry
    }
    return $map
}

function Get-OverviewKbModuleRelativeDir {
    param(
        [string]$ModuleName,
        [hashtable]$ModuleCatalogByName
    )

    if ($ModuleCatalogByName.ContainsKey($ModuleName)) {
        return [string]$ModuleCatalogByName[$ModuleName].KbRelativeDir
    }

    return "modules/$ModuleName"
}

function Get-OverviewModuleExportRelativeDir {
    param(
        [string]$ModuleName,
        [hashtable]$ModuleCatalogByName
    )

    if ($ModuleCatalogByName.ContainsKey($ModuleName)) {
        return [string]$ModuleCatalogByName[$ModuleName].ExportRelativeDir
    }

    return "modules/$ModuleName"
}

function Get-OverviewModuleFilePath {
    param(
        [string]$RootPath,
        [string]$ModuleName,
        [string]$FileName,
        [hashtable]$ModuleCatalogByName
    )

    $relativeDir = Get-OverviewModuleExportRelativeDir -ModuleName $ModuleName -ModuleCatalogByName $ModuleCatalogByName
    $moduleRoot = Join-Path $RootPath ($relativeDir -replace "/", "\")
    if ([string]::IsNullOrWhiteSpace($FileName)) {
        return $moduleRoot
    }
    return Join-Path $moduleRoot $FileName
}

function Add-OverviewManifestArtifact {
    param(
        [System.Collections.Generic.List[object]]$Artifacts,
        [System.Collections.Generic.HashSet[string]]$SeenKeys,
        [string]$Type,
        [string]$Path
    )

    $logicalPath = [System.IO.Path]::GetFullPath($Path)
    $key = "$Type|$logicalPath".ToLowerInvariant()
    if ($SeenKeys.Contains($key)) { return }

    [void]$SeenKeys.Add($key)
    $Artifacts.Add([pscustomobject]@{
        type = $Type
        path = $logicalPath
    }) | Out-Null
}

function New-OverviewFlowDetailObject {
    param(
        [object]$Flow,
        [object[]]$ModuleCallEdges,
        [object]$ModuleEntry,
        [string]$RunFolderName,
        [string]$Slug
    )

    $flowCallEdges = @($ModuleCallEdges | Where-Object {
        [string]$_.callerFlow -eq [string]$Flow.qualifiedName -or
        [string]$_.targetFlow -eq [string]$Flow.qualifiedName
    })

    $stableId = if ($Flow.PSObject.Properties.Name -contains "flowId" -and -not [string]::IsNullOrWhiteSpace([string]$Flow.flowId)) {
        [string]$Flow.flowId
    } else {
        [string]$Flow.qualifiedName
    }

    return [ordered]@{
        _meta = [ordered]@{
            objectType = "flow"
            module = [string]$ModuleEntry.Name
            qualifiedName = [string]$Flow.qualifiedName
            stableId = $stableId
            slug = $Slug
            l0Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "flows/$Slug.abstract.md")
            l1Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "flows/$Slug.overview.md")
            l2Path = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/flows/$Slug.json"
            l2Logical = "flow:$([string]$Flow.qualifiedName)"
            sourceRun = $RunFolderName
            aggregateJson = Get-OverviewLogicalPath -Path "app-overview/$RunFolderName/$($ModuleEntry.ExportRelativeDir)/flows.json"
            aggregatePseudo = Get-OverviewLogicalPath -Path "app-overview/$RunFolderName/$($ModuleEntry.ExportRelativeDir)/flows.pseudo.txt"
            collectionIndex = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/flows/INDEX.json"
        }
        flowId = $Flow.flowId
        kind = $Flow.kind
        qualifiedName = $Flow.qualifiedName
        module = $Flow.module
        nodes = @($Flow.nodes)
        edges = @($Flow.edges)
        calls = @($Flow.calls)
        startNodeIds = @($Flow.startNodeIds)
        primaryExecutionOrderNodeIds = @($Flow.primaryExecutionOrderNodeIds)
        pseudocode = $Flow.pseudocode
        retrieveActions = @($Flow.retrieveActions)
        decisionActions = @($Flow.decisionActions)
        showPageActions = @($Flow.showPageActions)
        mutationActions = @($Flow.mutationActions)
        callEdges = $flowCallEdges
    }
}

function New-OverviewPageDetailObject {
    param(
        [object]$Page,
        [object]$ModuleEntry,
        [string]$RunFolderName,
        [string]$Slug
    )

    $stableId = [string]$Page.qualifiedName

    return [ordered]@{
        _meta = [ordered]@{
            objectType = "page"
            module = [string]$ModuleEntry.Name
            qualifiedName = [string]$Page.qualifiedName
            stableId = $stableId
            slug = $Slug
            l0Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "pages/$Slug.abstract.md")
            l1Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "pages/$Slug.overview.md")
            l2Path = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/pages/$Slug.json"
            l2Logical = "page:$([string]$Page.qualifiedName)"
            sourceRun = $RunFolderName
            aggregateJson = Get-OverviewLogicalPath -Path "app-overview/$RunFolderName/$($ModuleEntry.ExportRelativeDir)/pages.json"
            aggregatePseudo = Get-OverviewLogicalPath -Path "app-overview/$RunFolderName/$($ModuleEntry.ExportRelativeDir)/pages.pseudo.txt"
            collectionIndex = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/pages/INDEX.json"
        }
        qualifiedName = $Page.qualifiedName
        name = $Page.name
        title = $Page.title
        layout = $Page.layout
        allowedRoles = @($Page.allowedRoles)
        parameters = @($Page.parameters)
        isPopup = $Page.isPopup
        popupWidth = $Page.popupWidth
        popupHeight = $Page.popupHeight
        popupResizable = $Page.popupResizable
        url = $Page.url
        excluded = $Page.excluded
        dataSources = @($Page.dataSources)
        clientActions = @($Page.clientActions)
        navigationProvenance = @($Page.navigationProvenance)
    }
}

function Ensure-OverviewModuleSplitArtifacts {
    param(
        [string]$TargetRunFolder,
        [object]$ModuleEntry,
        [System.Collections.Generic.List[object]]$DebtRecords,
        [System.Collections.Generic.List[object]]$Artifacts,
        [System.Collections.Generic.HashSet[string]]$SeenArtifactKeys,
        [string]$RunFolderName
    )

    $moduleRoot = Join-Path $TargetRunFolder ($ModuleEntry.ExportRelativeDir -replace "/", "\")
    if (-not (Test-Path $moduleRoot -PathType Container)) { return }

    $flowsAggregatePath = Join-Path $moduleRoot "flows.json"
    $pagesAggregatePath = Join-Path $moduleRoot "pages.json"

    $moduleCallEdges = @()
    if (Test-Path $flowsAggregatePath -PathType Leaf) {
        $flowsAggregate = Get-Content -Raw $flowsAggregatePath | ConvertFrom-Json
        $moduleCallEdges = @($flowsAggregate.callEdges)
    } else {
        $flowsAggregate = $null
    }

    if (Test-Path $pagesAggregatePath -PathType Leaf) {
        $pagesAggregate = Get-Content -Raw $pagesAggregatePath | ConvertFrom-Json
    } else {
        $pagesAggregate = $null
    }

    foreach ($kind in @("flows", "pages")) {
        $aggregate = if ($kind -eq "flows") { $flowsAggregate } else { $pagesAggregate }
        $itemsProperty = if ($kind -eq "flows") { "flows" } else { "pages" }
        $stableIdProperty = if ($kind -eq "flows") { "flowId" } else { "qualifiedName" }
        $detailType = if ($kind -eq "flows") { "module-flow-object-json" } else { "module-page-object-json" }
        $legacyDetailType = if ($kind -eq "flows") { "module-flow-detail-json" } else { "module-page-detail-json" }
        $indexType = if ($kind -eq "flows") { "module-flow-index-json" } else { "module-page-index-json" }
        $collectionObjectType = if ($kind -eq "flows") { "flow-collection" } else { "page-collection" }
        $collectionL0 = if ($kind -eq "flows") { "flows/INDEX.abstract.md" } else { "pages/INDEX.abstract.md" }
        $collectionL1 = if ($kind -eq "flows") { "FLOWS.md" } else { "PAGES.md" }
        $collectionDir = Join-Path $moduleRoot $kind
        $indexPath = Join-Path $collectionDir "INDEX.json"

        if (-not (Test-Path $collectionDir -PathType Container)) {
            New-Item -Path $collectionDir -ItemType Directory -Force | Out-Null
        }

        if (Test-Path $indexPath -PathType Leaf) {
            Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $indexType -Path $indexPath
            foreach ($existingObject in @(Get-ChildItem -Path $collectionDir -Filter *.json -File | Where-Object { $_.Name -ne "INDEX.json" })) {
                Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $detailType -Path $existingObject.FullName
                Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $legacyDetailType -Path $existingObject.FullName
            }
            continue
        }

        if ($null -eq $aggregate) {
            $DebtRecords.Add([pscustomobject]@{
                mode = "missing-aggregate"
                objectType = $kind
                module = [string]$ModuleEntry.Name
                qualifiedName = ""
                slug = ""
                note = "Aggregate $kind export is missing; split artefacts could not be materialised."
            }) | Out-Null
            continue
        }

        $items = New-Object System.Collections.Generic.List[object]
        $usedSlugs = @{}
        foreach ($item in @($aggregate.$itemsProperty)) {
            $qualifiedName = [string]$item.qualifiedName
            if ([string]::IsNullOrWhiteSpace($qualifiedName)) {
                $DebtRecords.Add([pscustomobject]@{
                    mode = "unmappable-aggregate-item"
                    objectType = $kind.Substring(0, $kind.Length - 1)
                    module = [string]$ModuleEntry.Name
                    qualifiedName = ""
                    slug = ""
                    note = "Aggregate item is missing qualifiedName; object-level L2 artefact was skipped."
                }) | Out-Null
                continue
            }

            $stableId = if ($item.PSObject.Properties.Name -contains $stableIdProperty -and -not [string]::IsNullOrWhiteSpace([string]$item.$stableIdProperty)) {
                [string]$item.$stableIdProperty
            } else {
                $qualifiedName
            }

            $slug = Build-OverviewObjectSlug -QualifiedName $qualifiedName -StableId $stableId -UsedSlugs $usedSlugs
            $detailPath = Join-Path $collectionDir "$slug.json"
            $detailObject = if ($kind -eq "flows") {
                New-OverviewFlowDetailObject -Flow $item -ModuleCallEdges $moduleCallEdges -ModuleEntry $ModuleEntry -RunFolderName $RunFolderName -Slug $slug
            } else {
                New-OverviewPageDetailObject -Page $item -ModuleEntry $ModuleEntry -RunFolderName $RunFolderName -Slug $slug
            }

            Write-JsonUtf8NoBom -Path $detailPath -Value $detailObject
            Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $detailType -Path $detailPath
            Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $legacyDetailType -Path $detailPath

            $items.Add([pscustomobject]@{
                objectType = if ($kind -eq "flows") { "flow" } else { "page" }
                qualifiedName = $qualifiedName
                stableId = $stableId
                slug = $slug
                kind = if ($kind -eq "flows") { [string]$item.kind } else { $null }
                nodeCount = if ($kind -eq "flows") { @($item.nodes).Count } else { $null }
                title = if ($kind -eq "pages") { [string]$item.title } else { $null }
                roleCount = if ($kind -eq "pages") { @($item.allowedRoles).Count } else { $null }
                l0Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "$kind/$slug.abstract.md")
                l1Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir "$kind/$slug.overview.md")
                l2Path = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/$kind/$slug.json"
                l2Logical = if ($kind -eq "flows") { "flow:$qualifiedName" } else { "page:$qualifiedName" }
                sourceRun = $RunFolderName
            }) | Out-Null

            $DebtRecords.Add([pscustomobject]@{
                mode = "materialised-from-aggregate"
                objectType = $kind.Substring(0, $kind.Length - 1)
                module = [string]$ModuleEntry.Name
                qualifiedName = $qualifiedName
                slug = $slug
                note = "Split L2 artefact was materialised from aggregate $kind.json during transition."
            }) | Out-Null
        }

        $indexObject = [ordered]@{
            objectType = $collectionObjectType
            module = [string]$ModuleEntry.Name
            sourceRun = $RunFolderName
            l0Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir $collectionL0)
            l1Path = Get-OverviewLogicalPath -Path (Join-Path $ModuleEntry.KbLogicalRelativeDir $collectionL1)
            l2Path = Get-OverviewLogicalPath -Path "app-overview/current/$($ModuleEntry.ExportRelativeDir)/$kind/INDEX.json"
            items = $items
        }
        Write-JsonUtf8NoBom -Path $indexPath -Value $indexObject
        Add-OverviewManifestArtifact -Artifacts $Artifacts -SeenKeys $SeenArtifactKeys -Type $indexType -Path $indexPath
    }
}

function Sync-AppOverviewCurrentAlias {
    param(
        [Alias("RunFolderPath")]
        [string]$RunFolder,
        [Alias("CurrentPath", "TargetCurrentAliasPath")]
        [string]$CurrentAliasPath,
        [Alias("ManifestObject")]
        [object]$Manifest,
        [hashtable]$ModuleCatalogByName
    )

    if ([string]::IsNullOrWhiteSpace($RunFolder)) {
        throw "Sync-AppOverviewCurrentAlias requires a run folder path."
    }
    if (-not (Test-Path $RunFolder -PathType Container)) {
        throw "Run folder not found for current alias sync: $RunFolder"
    }

    $resolvedRunFolder = (Resolve-Path $RunFolder).Path
    if ([string]::IsNullOrWhiteSpace($CurrentAliasPath)) {
        $appOverviewRoot = Split-Path -Parent $resolvedRunFolder
        $currentPath = Join-Path $appOverviewRoot "current"
    }
    else {
        $currentPath = [System.IO.Path]::GetFullPath($CurrentAliasPath)
    }

    if ([string]::Equals($resolvedRunFolder.TrimEnd('\', '/'), $currentPath.TrimEnd('\', '/'), [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Current alias sync requires an immutable run folder, not app-overview/current."
    }

    if (Test-Path $currentPath) {
        Remove-Item -Path $currentPath -Recurse -Force
    }

    New-Item -ItemType Directory -Path $currentPath -Force | Out-Null
    foreach ($child in Get-ChildItem -Path $resolvedRunFolder -Force) {
        $destination = Join-Path $currentPath $child.Name
        if ($child.PSIsContainer) {
            Copy-Item -Path $child.FullName -Destination $destination -Recurse -Force
        } else {
            Copy-Item -Path $child.FullName -Destination $destination -Force
        }
    }

    $currentManifestPath = Join-Path $currentPath "manifest.json"
    $currentManifest = Load-OverviewManifest -RunFolder $currentPath
    $artifacts = New-Object System.Collections.Generic.List[object]
    $seenArtifactKeys = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($artifact in @($currentManifest.artifacts)) {
        Add-OverviewManifestArtifact -Artifacts $artifacts -SeenKeys $seenArtifactKeys -Type ([string]$artifact.type) -Path ([string]$artifact.path)
    }

    $debtRecords = New-Object System.Collections.Generic.List[object]
    $runFolderName = Split-Path $resolvedRunFolder -Leaf
    $effectiveModuleCatalogByName = $ModuleCatalogByName
    if ($null -eq $effectiveModuleCatalogByName -or $effectiveModuleCatalogByName.Count -eq 0) {
        $effectiveManifest = if ($null -ne $Manifest) { $Manifest } else { Load-OverviewManifest -RunFolder $resolvedRunFolder }
        $effectiveModuleCatalogByName = Get-OverviewModuleCatalogMap -ModuleCatalog (Get-OverviewModuleCatalog -RunFolder $resolvedRunFolder -Manifest $effectiveManifest)
    }

    foreach ($moduleEntry in @($effectiveModuleCatalogByName.Values | Sort-Object Name)) {
        Ensure-OverviewModuleSplitArtifacts `
            -TargetRunFolder $currentPath `
            -ModuleEntry $moduleEntry `
            -DebtRecords $debtRecords `
            -Artifacts $artifacts `
            -SeenArtifactKeys $seenArtifactKeys `
            -RunFolderName $runFolderName
    }

    $selectedModules = @()
    if ($null -ne $currentManifest.selectedModules) {
        $selectedModules = @($currentManifest.selectedModules | ForEach-Object { [string]$_ })
    }
    $artifactArray = $artifacts.ToArray()
    $updatedManifest = @{
        schemaVersion = [string]$currentManifest.schemaVersion
        generatedAtUtc = [string]$currentManifest.generatedAtUtc
        selectedModules = $selectedModules
        artifactCount = $artifactArray.Count
        artifacts = $artifactArray
    }
    Write-JsonUtf8NoBom -Path $currentManifestPath -Value $updatedManifest

    return [pscustomobject]@{
        CurrentAliasPath = $currentPath
        DebtRecords = $debtRecords.ToArray()
        ManifestPath = $currentManifestPath
    }
}

function Write-L2ContractDebtReport {
    param(
        [string]$KbRoot,
        [string]$RunFolder,
        [string]$CurrentAliasPath,
        [object[]]$DebtRecords,
        [string]$GeneratedAtUtc
    )

    $reportsDir = Join-Path $KbRoot "_reports"
    if (-not (Test-Path $reportsDir -PathType Container)) {
        New-Item -Path $reportsDir -ItemType Directory -Force | Out-Null
    }

    $debtJsonPath = Join-Path $reportsDir "l2-contract-debt.json"
    $debtMdPath = Join-Path $reportsDir "l2-contract-debt.md"

    $payload = [ordered]@{
        schemaVersion = "1.0"
        generatedAtUtc = $GeneratedAtUtc
        runFolder = $RunFolder
        currentAliasPath = $CurrentAliasPath
        debtCount = @($DebtRecords).Count
        items = @($DebtRecords)
    }
    Write-JsonUtf8NoBom -Path $debtJsonPath -Value $payload

    $rows = New-Object System.Collections.Generic.List[string]
    foreach ($record in @($DebtRecords | Sort-Object module, objectType, qualifiedName, slug, mode)) {
        $rows.Add("| $([string]$record.mode) | $([string]$record.objectType) | $([string]$record.module) | $([string]$record.qualifiedName) | $([string]$record.slug) | $([string]$record.note) |") | Out-Null
    }
    if ($rows.Count -eq 0) {
        $rows.Add("| none | none | none | none | none | No transitional L2 debt items were recorded. |") | Out-Null
    }

    $markdown = @"
# L2 Contract Debt Report

## Summary

- Generated at: $GeneratedAtUtc
- Run folder: $RunFolder
- Current alias: $CurrentAliasPath
- Debt items: $(@($DebtRecords).Count)

## Items

| Mode | Object type | Module | Qualified name | Slug | Note |
|---|---|---|---|---|---|
$($rows -join "`n")
"@

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($debtMdPath, $markdown.TrimEnd() + "`n", $utf8NoBom)

    return [pscustomobject]@{
        JsonPath = $debtJsonPath
        MarkdownPath = $debtMdPath
    }
}

function Resolve-OverviewRunFolderFromKnowledgeBase {
    param([string]$KbRootPath)

    $creatorLinkPath = Join-Path $KbRootPath "_sources/creator-link.json"
    if (Test-Path $creatorLinkPath -PathType Leaf) {
        $creatorLink = Get-Content -Raw $creatorLinkPath | ConvertFrom-Json
        if (
            -not [string]::IsNullOrWhiteSpace([string]$creatorLink.lastRunFolder) -and
            (Split-Path -Leaf ([string]$creatorLink.lastRunFolder)) -ne "current" -and
            (Test-Path ([string]$creatorLink.lastRunFolder) -PathType Container)
        ) {
            return (Resolve-Path ([string]$creatorLink.lastRunFolder)).Path
        }
    }

    $sourcesManifest = Join-Path $KbRootPath "_sources/manifest.json"
    if (-not (Test-Path $sourcesManifest -PathType Leaf)) { return $null }

    $manifest = Get-Content -Raw $sourcesManifest | ConvertFrom-Json
    $preferred = @($manifest.artifacts | Where-Object { $_.type -eq "general-all-modules-json" } | Select-Object -First 1)
    $artifactPath = if ($preferred.Count -gt 0) { [string]$preferred[0].path } else { [string]@($manifest.artifacts | Select-Object -First 1).path }
    if ([string]::IsNullOrWhiteSpace($artifactPath)) { return $null }

    $resolvedArtifactPath = $null
    if ([System.IO.Path]::IsPathRooted($artifactPath)) {
        if (Test-Path $artifactPath -PathType Leaf) {
            $resolvedArtifactPath = (Resolve-Path $artifactPath).Path
        }
    } elseif (Test-Path $artifactPath -PathType Leaf) {
        $resolvedArtifactPath = [System.IO.Path]::GetFullPath($artifactPath)
    } else {
        $dataRoot = Split-Path -Parent $KbRootPath
        $candidate = Join-Path $dataRoot $artifactPath
        if (Test-Path $candidate -PathType Leaf) {
            $resolvedArtifactPath = (Resolve-Path $candidate).Path
        }
    }

    if ([string]::IsNullOrWhiteSpace($resolvedArtifactPath)) { return $null }

    $artifactParent = Split-Path -Parent $resolvedArtifactPath
    $folderName = Split-Path -Leaf $artifactParent
    if ($folderName -eq "general") {
        return (Split-Path -Parent $artifactParent)
    }
    if ($folderName -eq "modules") {
        return (Split-Path -Parent $artifactParent)
    }
    $parentName = Split-Path -Leaf (Split-Path -Parent $artifactParent)
    if ($parentName -eq "modules") {
        return (Split-Path -Parent (Split-Path -Parent $artifactParent))
    }

    return $null
}
