using System.Text.Json;
using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for ScheduledEvents parser in MendixModelDiffService.
/// Tests the BuildScheduledEventDetails method via CompareDumps with synthetic JSON dumps.
/// </summary>
public class MendixModelDiffServiceScheduledEventTests
{
    /// <summary>
    /// Helper: creates a minimal dump with one ScheduledEvent resource.
    /// </summary>
    private static string CreateScheduledEventDump(
        string eventId,
        string eventName,
        string? enabled,
        string? interval,
        string? microflowName,
        string? startTime)
    {
        var enabledJson = string.IsNullOrWhiteSpace(enabled) ? "null" : $"\"{enabled}\"";
        var intervalJson = string.IsNullOrWhiteSpace(interval) ? "null" : $"\"{EscapeJson(interval)}\"";
        var microflowJson = string.IsNullOrWhiteSpace(microflowName) ? "null" : $"\"{EscapeJson(microflowName)}\"";
        var startTimeJson = string.IsNullOrWhiteSpace(startTime) ? "null" : $"\"{startTime}\"";

        return $$"""
        {
            "units": [
                {
                    "$ID": "{{eventId}}",
                    "$Type": "System$ScheduledEvent",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.{{eventName}}",
                    "name": "{{eventName}}",
                    "enabled": {{enabledJson}},
                    "interval": {{intervalJson}},
                    "microflowName": {{microflowJson}},
                    "startTime": {{startTimeJson}}
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
    public void CompareDumps_ScheduledEventAdded_EmitsConfiguration()
    {
        // Arrange: event added
        var emptyHeadDump = CreateScheduledEventDump("dummy-id", "DummyEvent", null, null, null, null);
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "DailySync",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "MyModule.SyncFlow",
            startTime: "2026-03-01T00:00:00");

        var headPath = WriteDumpToTemp(emptyHeadDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Added", eventChange.ChangeType);
            Assert.Equal("DailySync", eventChange.ElementName);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("enabled=true", eventChange.Details);
            Assert.Contains("interval=0 0 * * *", eventChange.Details);
            Assert.Contains("microflow=MyModule.SyncFlow", eventChange.Details);
            Assert.Contains("startTime=2026-03-01T00:00:00", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventDeleted_EmitsConfiguration()
    {
        // Arrange: event deleted
        var headDump = CreateScheduledEventDump(
            "event-1",
            "OldSync",
            enabled: "false",
            interval: "0 12 * * *",
            microflowName: "Legacy.SyncMicroflow",
            startTime: "2025-01-01T12:00:00");
        var emptyWorkingDump = CreateScheduledEventDump("dummy-id", "DummyEvent", null, null, null, null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(emptyWorkingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Deleted", eventChange.ChangeType);
            Assert.Equal("OldSync", eventChange.ElementName);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("enabled=false", eventChange.Details);
            Assert.Contains("interval=0 12 * * *", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventEnabledToggled_EmitsEnabledDelta()
    {
        // Arrange: event enabled toggled
        var headDump = CreateScheduledEventDump(
            "event-1",
            "ToggleTest",
            enabled: "false",
            interval: "0 0 * * *",
            microflowName: "Test.Flow",
            startTime: null);
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "ToggleTest",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "Test.Flow",
            startTime: null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Modified", eventChange.ChangeType);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("enabled false->true", eventChange.Details);
            // Other fields should not change
            Assert.DoesNotContain("interval", eventChange.Details);
            Assert.DoesNotContain("microflow", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventIntervalChanged_EmitsIntervalDelta()
    {
        // Arrange: interval changed
        var headDump = CreateScheduledEventDump(
            "event-1",
            "FrequencyTest",
            enabled: "true",
            interval: "0 */2 * * *",
            microflowName: "Test.Flow",
            startTime: null);
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "FrequencyTest",
            enabled: "true",
            interval: "0 * * * *",
            microflowName: "Test.Flow",
            startTime: null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Modified", eventChange.ChangeType);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("interval", eventChange.Details);
            Assert.Contains("0 */2 * * *->0 * * * *", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventMicroflowChanged_EmitsMicroflowDelta()
    {
        // Arrange: microflow target changed
        var headDump = CreateScheduledEventDump(
            "event-1",
            "TargetTest",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "Old.TargetFlow",
            startTime: null);
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "TargetTest",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "New.TargetFlow",
            startTime: null);

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Modified", eventChange.ChangeType);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("microflow Old.TargetFlow->New.TargetFlow", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventStartTimeChanged_EmitsStartTimeDelta()
    {
        // Arrange: start time changed
        var headDump = CreateScheduledEventDump(
            "event-1",
            "TimeTest",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "Test.Flow",
            startTime: "2025-01-01T00:00:00");
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "TimeTest",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "Test.Flow",
            startTime: "2026-01-01T00:00:00");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Modified", eventChange.ChangeType);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("startTime", eventChange.Details);
            Assert.Contains("2025-01-01T00:00:00->2026-01-01T00:00:00", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventMultipleFieldsChanged_EmitsAllDeltas()
    {
        // Arrange: multiple fields changed
        var headDump = CreateScheduledEventDump(
            "event-1",
            "ComplexChange",
            enabled: "false",
            interval: "0 0 * * *",
            microflowName: "Old.Flow",
            startTime: "2025-01-01T00:00:00");
        var workingDump = CreateScheduledEventDump(
            "event-1",
            "ComplexChange",
            enabled: "true",
            interval: "0 * * * *",
            microflowName: "New.Flow",
            startTime: "2026-01-01T00:00:00");

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.NotNull(eventChange);
            Assert.Equal("Modified", eventChange.ChangeType);
            Assert.NotNull(eventChange.Details);
            Assert.Contains("enabled false->true", eventChange.Details);
            Assert.Contains("interval", eventChange.Details);
            Assert.Contains("microflow Old.Flow->New.Flow", eventChange.Details);
            Assert.Contains("startTime 2025-01-01T00:00:00->2026-01-01T00:00:00", eventChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ScheduledEventNoChanges_NoModifiedEntry()
    {
        // Arrange: unchanged event
        var dump = CreateScheduledEventDump(
            "event-1",
            "Unchanged",
            enabled: "true",
            interval: "0 0 * * *",
            microflowName: "Test.Flow",
            startTime: null);

        var headPath = WriteDumpToTemp(dump);
        var workingPath = WriteDumpToTemp(dump);

        try
        {
            // Act
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);

            // Assert
            var eventChange = changes.FirstOrDefault(c => c.ElementType == "ScheduledEvent");
            Assert.Null(eventChange);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_MultipleScheduledEvents_EmitsAllChanges()
    {
        // Arrange: multiple events with different changes
        var headDump = $$"""
        {
            "units": [
                {
                    "$ID": "event-1",
                    "$Type": "System$ScheduledEvent",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Event1",
                    "name": "Event1",
                    "enabled": "true",
                    "interval": "0 0 * * *",
                    "microflowName": "Test.Flow1",
                    "startTime": null
                },
                {
                    "$ID": "event-2",
                    "$Type": "System$ScheduledEvent",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Event2",
                    "name": "Event2",
                    "enabled": "false",
                    "interval": "0 12 * * *",
                    "microflowName": "Test.Flow2",
                    "startTime": null
                }
            ]
        }
        """;

        var workingDump = $$"""
        {
            "units": [
                {
                    "$ID": "event-1",
                    "$Type": "System$ScheduledEvent",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Event1",
                    "name": "Event1",
                    "enabled": "false",
                    "interval": "0 0 * * *",
                    "microflowName": "Test.Flow1",
                    "startTime": null
                },
                {
                    "$ID": "event-3",
                    "$Type": "System$ScheduledEvent",
                    "$ContainerID": "module-id",
                    "$ContainerProperty": "projectDocuments",
                    "$QualifiedName": "TestModule.Event3",
                    "name": "Event3",
                    "enabled": "true",
                    "interval": "0 6 * * *",
                    "microflowName": "Test.Flow3",
                    "startTime": null
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
            var eventChanges = changes.Where(c => c.ElementType == "ScheduledEvent").ToList();
            Assert.Equal(3, eventChanges.Count);

            // Event1: modified (enabled toggled)
            var event1 = eventChanges.FirstOrDefault(c => c.ElementName == "Event1");
            Assert.NotNull(event1);
            Assert.Equal("Modified", event1.ChangeType);
            Assert.Contains("enabled true->false", event1.Details!);

            // Event2: deleted
            var event2 = eventChanges.FirstOrDefault(c => c.ElementName == "Event2");
            Assert.NotNull(event2);
            Assert.Equal("Deleted", event2.ChangeType);

            // Event3: added
            var event3 = eventChanges.FirstOrDefault(c => c.ElementName == "Event3");
            Assert.NotNull(event3);
            Assert.Equal("Added", event3.ChangeType);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
