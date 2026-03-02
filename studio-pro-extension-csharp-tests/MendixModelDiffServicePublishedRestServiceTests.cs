using System.Text.Json;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for PublishedRestService parser in MendixModelDiffService.
/// Tests the BuildPublishedRestServiceDetails method via CompareDumps with synthetic JSON dumps.
/// </summary>
public class MendixModelDiffServicePublishedRestServiceTests
{
    /// <summary>
    /// Helper: creates a minimal dump with one PublishedRestService resource.
    /// </summary>
    private static string CreatePublishedRestServiceDump(
        string serviceId,
        string serviceName,
        int operationCount = 0,
        string? accessLevel = null)
    {
        var accessLevelJson = string.IsNullOrWhiteSpace(accessLevel) ? "null" : $"\"{EscapeJson(accessLevel)}\"";

        var operationsArray = operationCount > 0
            ? $"[{string.Join(",", Enumerable.Range(0, operationCount).Select(_ => "{{\"$Type\":\"RestServices$PublishedOperation\"}}"))}]"
            : "[]";

        return $$"""
        {
            "units": [
                {
                    "$ID": "{{serviceId}}",
                    "$Type": "System$PublishedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.{{serviceName}}",
                    "name": "{{serviceName}}",
                    "publicAccessLevel": {{accessLevelJson}},
                    "operations": {{operationsArray}}
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
    public void CompareDumps_PublishedRestServiceAdded_EmitsConfiguration()
    {
        // Arrange: service added
        var emptyHeadDump = CreatePublishedRestServiceDump("dummy-id", "DummyService", 0, null);
        var workingDump = CreatePublishedRestServiceDump("service-1", "PublicAPI", 4, "Public");

        var headPath = WriteDumpToTemp(emptyHeadDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "PublishedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Added", serviceChange.ChangeType);
            Assert.Equal("PublicAPI", serviceChange.ElementName);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("operations=4", serviceChange.Details);
            Assert.Contains("accessLevel=Public", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_PublishedRestServiceDeleted_EmitsConfiguration()
    {
        // Arrange: service deleted
        var headDump = CreatePublishedRestServiceDump("service-1", "OldPublishedAPI", 3, "Private");
        var emptyWorkingDump = CreatePublishedRestServiceDump("dummy-id", "DummyService", 0, null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(emptyWorkingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "PublishedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Deleted", serviceChange.ChangeType);
            Assert.Equal("OldPublishedAPI", serviceChange.ElementName);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("operations=3", serviceChange.Details);
            Assert.Contains("accessLevel=Private", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_PublishedRestServiceOperationsCountChanged_EmitsOperationsDelta()
    {
        // Arrange: operations count changed
        var headDump = CreatePublishedRestServiceDump("service-1", "ExposedAPI", 2, "Public");
        var workingDump = CreatePublishedRestServiceDump("service-1", "ExposedAPI", 5, "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "PublishedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Modified", serviceChange.ChangeType);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("operations 2->5", serviceChange.Details);
            // Access level should not change
            Assert.DoesNotContain("accessLevel", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_PublishedRestServiceAccessLevelChanged_EmitsAccessLevelDelta()
    {
        // Arrange: access level changed
        var headDump = CreatePublishedRestServiceDump("service-1", "RestAPI", 3, "Private");
        var workingDump = CreatePublishedRestServiceDump("service-1", "RestAPI", 3, "Public");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "PublishedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Modified", serviceChange.ChangeType);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("accessLevel Private->Public", serviceChange.Details);
            // Operations should not change
            Assert.DoesNotContain("operations", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_PublishedRestServiceNoChanges_NoModifiedEntry()
    {
        // Arrange: unchanged service
        var dump = CreatePublishedRestServiceDump("service-1", "StaticPublishedAPI", 2, "Public");

        var headPath = WriteDumpToTemp(dump);
        var workingPath = WriteDumpToTemp(dump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "PublishedRestService");
            Assert.Null(serviceChange);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_MultiplePublishedRestServices_EmitsAllChanges()
    {
        // Arrange: multiple services with different changes
        var headDump = $$"""
        {
            "units": [
                {
                    "$ID": "service-1",
                    "$Type": "System$PublishedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.PubService1",
                    "name": "PubService1",
                    "publicAccessLevel": "Private",
                    "operations": []
                },
                {
                    "$ID": "service-2",
                    "$Type": "System$PublishedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.PubService2",
                    "name": "PubService2",
                    "publicAccessLevel": "Public",
                    "operations": []
                }
            ]
        }
        """;

        var workingDump = $$"""
        {
            "units": [
                {
                    "$ID": "service-1",
                    "$Type": "System$PublishedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.PubService1",
                    "name": "PubService1",
                    "publicAccessLevel": "Public",
                    "operations": []
                },
                {
                    "$ID": "service-3",
                    "$Type": "System$PublishedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.PubService3",
                    "name": "PubService3",
                    "publicAccessLevel": "Public",
                    "operations": []
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
            var serviceChanges = changes.Where(c => c.ElementType == "PublishedRestService").ToList();
            Assert.Equal(3, serviceChanges.Count);

            // PubService1: modified (access level changed)
            var service1 = serviceChanges.FirstOrDefault(c => c.ElementName == "PubService1");
            Assert.NotNull(service1);
            Assert.Equal("Modified", service1.ChangeType);
            Assert.Contains("accessLevel Private->Public", service1.Details!);

            // PubService2: deleted
            var service2 = serviceChanges.FirstOrDefault(c => c.ElementName == "PubService2");
            Assert.NotNull(service2);
            Assert.Equal("Deleted", service2.ChangeType);

            // PubService3: added
            var service3 = serviceChanges.FirstOrDefault(c => c.ElementName == "PubService3");
            Assert.NotNull(service3);
            Assert.Equal("Added", service3.ChangeType);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
