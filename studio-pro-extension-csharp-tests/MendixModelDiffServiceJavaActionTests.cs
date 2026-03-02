using System.Text.Json;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for JavaAction parser in MendixModelDiffService.
/// Tests the BuildJavaActionDetails method via CompareDumps with synthetic JSON dumps.
/// </summary>
public class MendixModelDiffServiceJavaActionTests
{
    /// <summary>
    /// Helper: creates a minimal dump with one JavaAction resource.
    /// </summary>
    private static string CreateJavaActionDump(
        string actionId,
        string actionName,
        int parameterCount = 0,
        string? returnType = null,
        string? accessLevel = null)
    {
        var returnTypeJson = string.IsNullOrWhiteSpace(returnType) ? "null" : $"\"{EscapeJson(returnType)}\"";
        var accessLevelJson = string.IsNullOrWhiteSpace(accessLevel) ? "null" : $"\"{EscapeJson(accessLevel)}\"";

        var parametersArray = parameterCount > 0
            ? $"[{string.Join(",", Enumerable.Range(0, parameterCount).Select(_ => "{{\"$Type\":\"System$JavaActionParameter\"}}"))}]"
            : "[]";

        return $$"""
        {
            "units": [
                {
                    "$ID": "{{actionId}}",
                    "$Type": "System$JavaAction",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.{{actionName}}",
                    "name": "{{actionName}}",
                    "returnType": {{returnTypeJson}},
                    "publicAccessLevel": {{accessLevelJson}},
                    "parameters": {{parametersArray}}
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
    public void CompareDumps_JavaActionAdded_EmitsConfiguration()
    {
        // Arrange: action added
        var emptyHeadDump = CreateJavaActionDump("dummy-id", "DummyAction", 0, null, null);
        var workingDump = CreateJavaActionDump("action-1", "ProcessOrder", 3, "String", "Public");

        var headPath = WriteDumpToTemp(emptyHeadDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Added", actionChange.ChangeType);
            Assert.Equal("ProcessOrder", actionChange.ElementName);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("parameters=3", actionChange.Details);
            Assert.Contains("returnType=String", actionChange.Details);
            Assert.Contains("accessLevel=Public", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionDeleted_EmitsConfiguration()
    {
        // Arrange: action deleted
        var headDump = CreateJavaActionDump("action-1", "LegacyHandler", 2, "Boolean", "Private");
        var emptyWorkingDump = CreateJavaActionDump("dummy-id", "DummyAction", 0, null, null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(emptyWorkingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Deleted", actionChange.ChangeType);
            Assert.Equal("LegacyHandler", actionChange.ElementName);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("parameters=2", actionChange.Details);
            Assert.Contains("returnType=Boolean", actionChange.Details);
            Assert.Contains("accessLevel=Private", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionParametersCountChanged_EmitsParametersDelta()
    {
        // Arrange: parameter count changed
        var headDump = CreateJavaActionDump("action-1", "DataProcessor", 2, "String", "Public");
        var workingDump = CreateJavaActionDump("action-1", "DataProcessor", 5, "String", "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Modified", actionChange.ChangeType);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("parameters 2->5", actionChange.Details);
            // Return type and access level should not change
            Assert.DoesNotContain("returnType", actionChange.Details);
            Assert.DoesNotContain("accessLevel", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionReturnTypeChanged_EmitsReturnTypeDelta()
    {
        // Arrange: return type changed
        var headDump = CreateJavaActionDump("action-1", "Converter", 1, "String", "Public");
        var workingDump = CreateJavaActionDump("action-1", "Converter", 1, "Boolean", "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Modified", actionChange.ChangeType);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("returnType String->Boolean", actionChange.Details);
            // Parameters and access level should not change
            Assert.DoesNotContain("parameters", actionChange.Details);
            Assert.DoesNotContain("accessLevel", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionAccessLevelChanged_EmitsAccessLevelDelta()
    {
        // Arrange: access level changed
        var headDump = CreateJavaActionDump("action-1", "Helper", 1, "String", "Private");
        var workingDump = CreateJavaActionDump("action-1", "Helper", 1, "String", "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Modified", actionChange.ChangeType);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("accessLevel Private->Public", actionChange.Details);
            // Parameters and return type should not change
            Assert.DoesNotContain("parameters", actionChange.Details);
            Assert.DoesNotContain("returnType", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionMultipleFieldsChanged_EmitsAllDeltas()
    {
        // Arrange: multiple fields changed
        var headDump = CreateJavaActionDump("action-1", "ComplexAction", 2, "String", "Private");
        var workingDump = CreateJavaActionDump("action-1", "ComplexAction", 4, "Boolean", "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.NotNull(actionChange);
            Assert.Equal("Modified", actionChange.ChangeType);
            Assert.NotNull(actionChange.Details);
            Assert.Contains("parameters 2->4", actionChange.Details);
            Assert.Contains("returnType String->Boolean", actionChange.Details);
            Assert.Contains("accessLevel Private->Public", actionChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_JavaActionNoChanges_NoModifiedEntry()
    {
        // Arrange: unchanged action
        var dump = CreateJavaActionDump("action-1", "StaticHelper", 1, "String", "Public");

        var headPath = WriteDumpToTemp(dump);
        var workingPath = WriteDumpToTemp(dump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var actionChange = changes.FirstOrDefault(c => c.ElementType == "JavaAction");
            Assert.Null(actionChange);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_MultipleJavaActions_EmitsAllChanges()
    {
        // Arrange: multiple actions with different changes
        var headDump = $$"""
        {
            "units": [
                {
                    "$ID": "action-1",
                    "$Type": "System$JavaAction",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Action1",
                    "name": "Action1",
                    "returnType": "String",
                    "publicAccessLevel": "Public",
                    "parameters": []
                },
                {
                    "$ID": "action-2",
                    "$Type": "System$JavaAction",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Action2",
                    "name": "Action2",
                    "returnType": "Integer",
                    "publicAccessLevel": "Private",
                    "parameters": []
                }
            ]
        }
        """;

        var workingDump = $$"""
        {
            "units": [
                {
                    "$ID": "action-1",
                    "$Type": "System$JavaAction",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Action1",
                    "name": "Action1",
                    "returnType": "Boolean",
                    "publicAccessLevel": "Public",
                    "parameters": []
                },
                {
                    "$ID": "action-3",
                    "$Type": "System$JavaAction",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Action3",
                    "name": "Action3",
                    "returnType": "String",
                    "publicAccessLevel": "Public",
                    "parameters": []
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
            var actionChanges = changes.Where(c => c.ElementType == "JavaAction").ToList();
            Assert.Equal(3, actionChanges.Count);

            // Action1: modified (return type changed)
            var action1 = actionChanges.FirstOrDefault(c => c.ElementName == "Action1");
            Assert.NotNull(action1);
            Assert.Equal("Modified", action1.ChangeType);
            Assert.Contains("returnType String->Boolean", action1.Details!);

            // Action2: deleted
            var action2 = actionChanges.FirstOrDefault(c => c.ElementName == "Action2");
            Assert.NotNull(action2);
            Assert.Equal("Deleted", action2.ChangeType);

            // Action3: added
            var action3 = actionChanges.FirstOrDefault(c => c.ElementName == "Action3");
            Assert.NotNull(action3);
            Assert.Equal("Added", action3.ChangeType);
            Assert.Contains("returnType=String", action3.Details!);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
