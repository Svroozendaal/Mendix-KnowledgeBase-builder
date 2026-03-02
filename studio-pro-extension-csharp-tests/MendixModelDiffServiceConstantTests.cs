using System.Text.Json;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for Constants parser in MendixModelDiffService.
/// Tests the BuildConstantDetails method via CompareDumps with synthetic JSON dumps.
/// </summary>
public class MendixModelDiffServiceConstantTests
{
    /// <summary>
    /// Helper: creates a minimal dump with one Constant resource.
    /// </summary>
    private static string CreateConstantDump(string constantId, string constantName, string? value, string? type)
    {
        var valueJson = string.IsNullOrWhiteSpace(value) ? "null" : $"\"{EscapeJson(value)}\"";
        var typeJson = string.IsNullOrWhiteSpace(type) ? "null" : $"\"{EscapeJson(type)}\"";

        return $$"""
        {
            "units": [
                {
                    "$ID": "{{constantId}}",
                    "$Type": "System$Constant",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.{{constantName}}",
                    "name": "{{constantName}}",
                    "value": {{valueJson}},
                    "type": {{typeJson}}
                }
            ]
        }
        """;
    }

    /// <summary>
    /// Helper: escape JSON special characters.
    /// </summary>
    private static string EscapeJson(string input)
    {
        return input
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("\n", "\\n")
            .Replace("\r", "\\r")
            .Replace("\t", "\\t");
    }

    /// <summary>
    /// Helper: write dump to temp file and return path.
    /// </summary>
    private static string WriteDumpToTemp(string dumpJson)
    {
        var tempPath = Path.Combine(Path.GetTempPath(), $"dump_{Guid.NewGuid()}.json");
        File.WriteAllText(tempPath, dumpJson);
        return tempPath;
    }

    [Fact]
    public void CompareDumps_ConstantAdded_EmitsValueAndType()
    {
        // Arrange: constant added (not in HEAD, exists in WORKING)
        var emptyHeadDump = CreateConstantDump("dummy-id", "DummyConstant", null, null);
        var workingDump = CreateConstantDump("const-1", "MAX_ITEMS", "100", "Integer");

        var headPath = WriteDumpToTemp(emptyHeadDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Added", constantChange.ChangeType);
            Assert.Equal("MAX_ITEMS", constantChange.ElementName);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("value=100", constantChange.Details);
            Assert.Contains("type=Integer", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantDeleted_EmitsValueAndType()
    {
        // Arrange: constant deleted (exists in HEAD, not in WORKING)
        var headDump = CreateConstantDump("const-1", "OLD_TIMEOUT", "30", "String");
        var emptyWorkingDump = CreateConstantDump("dummy-id", "DummyConstant", null, null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(emptyWorkingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Deleted", constantChange.ChangeType);
            Assert.Equal("OLD_TIMEOUT", constantChange.ElementName);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("value=30", constantChange.Details);
            Assert.Contains("type=String", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantValueChanged_EmitsValueDelta()
    {
        // Arrange: constant value modified
        var headDump = CreateConstantDump("const-1", "RETRY_COUNT", "3", "Integer");
        var workingDump = CreateConstantDump("const-1", "RETRY_COUNT", "5", "Integer");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Modified", constantChange.ChangeType);
            Assert.Equal("RETRY_COUNT", constantChange.ElementName);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("value 3->5", constantChange.Details);
            // Type should not appear in details since it didn't change
            Assert.DoesNotContain("type", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantTypeChanged_EmitsTypeDelta()
    {
        // Arrange: constant type modified
        var headDump = CreateConstantDump("const-1", "CONFIG_PORT", "8080", "String");
        var workingDump = CreateConstantDump("const-1", "CONFIG_PORT", "8080", "Integer");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Modified", constantChange.ChangeType);
            Assert.Equal("CONFIG_PORT", constantChange.ElementName);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("type String->Integer", constantChange.Details);
            // Value should not appear in details since it didn't change
            Assert.DoesNotContain("value", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantValueAndTypeChanged_EmitsBothDeltas()
    {
        // Arrange: both value and type modified
        var headDump = CreateConstantDump("const-1", "APP_VERSION", "1.0", "String");
        var workingDump = CreateConstantDump("const-1", "APP_VERSION", "20", "Integer");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Modified", constantChange.ChangeType);
            Assert.Equal("APP_VERSION", constantChange.ElementName);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("value 1.0->20", constantChange.Details);
            Assert.Contains("type String->Integer", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantValueClearedToEmpty_EmitsEmptyMarker()
    {
        // Arrange: constant value cleared (set to null/empty)
        var headDump = CreateConstantDump("const-1", "DEBUG_MODE", "true", "Boolean");
        var workingDump = CreateConstantDump("const-1", "DEBUG_MODE", "", "Boolean");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.NotNull(constantChange);
            Assert.Equal("Modified", constantChange.ChangeType);
            Assert.NotNull(constantChange.Details);
            Assert.Contains("<empty>", constantChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantNoChanges_NoModifiedEntry()
    {
        // Arrange: constant unchanged
        var dump = CreateConstantDump("const-1", "STATIC_VALUE", "42", "Integer");

        var headPath = WriteDumpToTemp(dump);
        var workingPath = WriteDumpToTemp(dump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChange = changes.FirstOrDefault(c => c.ElementType == "Constant");
            Assert.Null(constantChange);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_MultipleConstantsChanged_EmitsAllChanges()
    {
        // Arrange: multiple constants with different changes
        var headDump = $$"""
        {
            "units": [
                {
                    "$ID": "const-1",
                    "$Type": "System$Constant",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.CONSTANT1",
                    "name": "CONSTANT1",
                    "value": "old",
                    "type": "String"
                },
                {
                    "$ID": "const-2",
                    "$Type": "System$Constant",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.CONSTANT2",
                    "name": "CONSTANT2",
                    "value": "5",
                    "type": "Integer"
                }
            ]
        }
        """;

        var workingDump = $$"""
        {
            "units": [
                {
                    "$ID": "const-1",
                    "$Type": "System$Constant",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.CONSTANT1",
                    "name": "CONSTANT1",
                    "value": "new",
                    "type": "String"
                },
                {
                    "$ID": "const-3",
                    "$Type": "System$Constant",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.CONSTANT3",
                    "name": "CONSTANT3",
                    "value": "added",
                    "type": "String"
                }
            ]
        }
        """;

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var constantChanges = changes.Where(c => c.ElementType == "Constant").ToList();
            Assert.Equal(3, constantChanges.Count);

            // CONSTANT1: modified
            var const1 = constantChanges.FirstOrDefault(c => c.ElementName == "CONSTANT1");
            Assert.NotNull(const1);
            Assert.Equal("Modified", const1.ChangeType);
            Assert.Contains("old->new", const1.Details!);

            // CONSTANT2: deleted
            var const2 = constantChanges.FirstOrDefault(c => c.ElementName == "CONSTANT2");
            Assert.NotNull(const2);
            Assert.Equal("Deleted", const2.ChangeType);

            // CONSTANT3: added
            var const3 = constantChanges.FirstOrDefault(c => c.ElementName == "CONSTANT3");
            Assert.NotNull(const3);
            Assert.Equal("Added", const3.ChangeType);
            Assert.Contains("value=added", const3.Details!);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConstantDetailsAreDeterministic_SameInputProducesSameOutput()
    {
        // Arrange: same constant change
        var dump1 = CreateConstantDump("const-1", "TEST_CONST", "100", "Integer");
        var dump2 = CreateConstantDump("const-1", "TEST_CONST", "50", "Integer");

        // Run twice
        var changes1 = MendixModelDiffService.CompareDumps(
            WriteDumpToTemp(dump2),
            WriteDumpToTemp(dump1));

        var changes2 = MendixModelDiffService.CompareDumps(
            WriteDumpToTemp(dump2),
            WriteDumpToTemp(dump1));

        try
        {
            // Assert: output should be identical
            var const1 = changes1.FirstOrDefault(c => c.ElementType == "Constant");
            var const2 = changes2.FirstOrDefault(c => c.ElementType == "Constant");

            Assert.NotNull(const1);
            Assert.NotNull(const2);
            Assert.Equal(const1.ChangeType, const2.ChangeType);
            Assert.Equal(const1.ElementName, const2.ElementName);
            Assert.Equal(const1.Details, const2.Details);
        }
        finally
        {
            // Cleanup all temp files
            foreach (var file in Directory.GetFiles(Path.GetTempPath(), "dump_*.json"))
            {
                try
                {
                    File.Delete(file);
                }
                catch
                {
                    // Ignore cleanup errors
                }
            }
        }
    }
}
