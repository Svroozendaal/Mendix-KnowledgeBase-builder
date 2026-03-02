using System.Text.Json;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for ConsumedRestService parser in MendixModelDiffService.
/// Tests the BuildConsumedRestServiceDetails method via CompareDumps with synthetic JSON dumps.
/// </summary>
public class MendixModelDiffServiceConsumedRestServiceTests
{
    /// <summary>
    /// Helper: creates a minimal dump with one ConsumedRestService resource.
    /// </summary>
    private static string CreateConsumedRestServiceDump(
        string serviceId,
        string serviceName,
        string? baseURL,
        string? authenticationType,
        int operationCount = 0)
    {
        var baseUrlJson = string.IsNullOrWhiteSpace(baseURL) ? "null" : $"\"{EscapeJson(baseURL)}\"";
        var authTypeJson = string.IsNullOrWhiteSpace(authenticationType) ? "null" : $"\"{EscapeJson(authenticationType)}\"";

        var operationsArray = operationCount > 0
            ? $"[{string.Join(",", Enumerable.Range(0, operationCount).Select(_ => "{{\"$Type\":\"RestServices$Operation\"}}"))}]"
            : "[]";

        return $$"""
        {
            "units": [
                {
                    "$ID": "{{serviceId}}",
                    "$Type": "System$ConsumedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.{{serviceName}}",
                    "name": "{{serviceName}}",
                    "baseURL": {{baseUrlJson}},
                    "authenticationType": {{authTypeJson}},
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
    public void CompareDumps_ConsumedRestServiceAdded_EmitsConfiguration()
    {
        // Arrange: service added
        var emptyHeadDump = CreateConsumedRestServiceDump("dummy-id", "DummyService", null, null, 0);
        var workingDump = CreateConsumedRestServiceDump(
            "service-1",
            "PaymentAPI",
            "https://api.payment.com/v1",
            "OAuth",
            3);

        var headPath = WriteDumpToTemp(emptyHeadDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Added", serviceChange.ChangeType);
            Assert.Equal("PaymentAPI", serviceChange.ElementName);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("baseURL=https://api.payment.com/v1", serviceChange.Details);
            Assert.Contains("auth=OAuth", serviceChange.Details);
            Assert.Contains("operations=3", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConsumedRestServiceDeleted_EmitsConfiguration()
    {
        // Arrange: service deleted
        var headDump = CreateConsumedRestServiceDump(
            "service-1",
            "LegacyAPI",
            "https://old.api.com",
            "Basic",
            2);
        var emptyWorkingDump = CreateConsumedRestServiceDump("dummy-id", "DummyService", null, null, 0);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(emptyWorkingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Deleted", serviceChange.ChangeType);
            Assert.Equal("LegacyAPI", serviceChange.ElementName);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("baseURL=https://old.api.com", serviceChange.Details);
            Assert.Contains("auth=Basic", serviceChange.Details);
            Assert.Contains("operations=2", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConsumedRestServiceBaseURLChanged_EmitsURLDelta()
    {
        // Arrange: baseURL changed
        var headDump = CreateConsumedRestServiceDump(
            "service-1",
            "APIClient",
            "https://old.api.com",
            "OAuth",
            2);
        var workingDump = CreateConsumedRestServiceDump(
            "service-1",
            "APIClient",
            "https://new.api.com",
            "OAuth",
            2);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Modified", serviceChange.ChangeType);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("baseURL https://old.api.com->https://new.api.com", serviceChange.Details);
            // Auth and operations should not change
            Assert.DoesNotContain("auth", serviceChange.Details);
            Assert.DoesNotContain("operations", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConsumedRestServiceAuthChanged_EmitsAuthDelta()
    {
        // Arrange: authentication type changed
        var headDump = CreateConsumedRestServiceDump(
            "service-1",
            "SecureAPI",
            "https://api.secure.com",
            "Basic",
            2);
        var workingDump = CreateConsumedRestServiceDump(
            "service-1",
            "SecureAPI",
            "https://api.secure.com",
            "OAuth",
            2);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Modified", serviceChange.ChangeType);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("auth Basic->OAuth", serviceChange.Details);
            // URL and operations should not change
            Assert.DoesNotContain("baseURL", serviceChange.Details);
            Assert.DoesNotContain("operations", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConsumedRestServiceOperationsCountChanged_EmitsOperationsDelta()
    {
        // Arrange: operations count changed
        var headDump = CreateConsumedRestServiceDump(
            "service-1",
            "DataAPI",
            "https://api.data.com",
            "OAuth",
            2);
        var workingDump = CreateConsumedRestServiceDump(
            "service-1",
            "DataAPI",
            "https://api.data.com",
            "OAuth",
            5);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.NotNull(serviceChange);
            Assert.Equal("Modified", serviceChange.ChangeType);
            Assert.NotNull(serviceChange.Details);
            Assert.Contains("operations 2->5", serviceChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ConsumedRestServiceNoChanges_NoModifiedEntry()
    {
        // Arrange: unchanged service
        var dump = CreateConsumedRestServiceDump(
            "service-1",
            "StaticAPI",
            "https://api.static.com",
            "None",
            1);

        var headPath = WriteDumpToTemp(dump);
        var workingPath = WriteDumpToTemp(dump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var serviceChange = changes.FirstOrDefault(c => c.ElementType == "ConsumedRestService");
            Assert.Null(serviceChange);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_MultipleConsumedRestServices_EmitsAllChanges()
    {
        // Arrange: multiple services with different changes
        var headDump = $$"""
        {
            "units": [
                {
                    "$ID": "service-1",
                    "$Type": "System$ConsumedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Service1",
                    "name": "Service1",
                    "baseURL": "https://old.api.com",
                    "authenticationType": "Basic",
                    "operations": []
                },
                {
                    "$ID": "service-2",
                    "$Type": "System$ConsumedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Service2",
                    "name": "Service2",
                    "baseURL": "https://service2.com",
                    "authenticationType": "OAuth",
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
                    "$Type": "System$ConsumedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Service1",
                    "name": "Service1",
                    "baseURL": "https://new.api.com",
                    "authenticationType": "Basic",
                    "operations": []
                },
                {
                    "$ID": "service-3",
                    "$Type": "System$ConsumedRestService",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Service3",
                    "name": "Service3",
                    "baseURL": "https://service3.com",
                    "authenticationType": "None",
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
            var serviceChanges = changes.Where(c => c.ElementType == "ConsumedRestService").ToList();
            Assert.Equal(3, serviceChanges.Count);

            // Service1: modified (baseURL changed)
            var service1 = serviceChanges.FirstOrDefault(c => c.ElementName == "Service1");
            Assert.NotNull(service1);
            Assert.Equal("Modified", service1.ChangeType);
            Assert.Contains("baseURL https://old.api.com->https://new.api.com", service1.Details!);

            // Service2: deleted
            var service2 = serviceChanges.FirstOrDefault(c => c.ElementName == "Service2");
            Assert.NotNull(service2);
            Assert.Equal("Deleted", service2.ChangeType);

            // Service3: added
            var service3 = serviceChanges.FirstOrDefault(c => c.ElementName == "Service3");
            Assert.NotNull(service3);
            Assert.Equal("Added", service3.ChangeType);
            Assert.Contains("baseURL=https://service3.com", service3.Details!);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
