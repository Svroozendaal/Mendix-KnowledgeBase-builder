using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for flow-specific detail extraction in MendixModelDiffService.
/// </summary>
public class MendixModelDiffServiceFlowDetailsTests
{
    private static string WriteDumpToTemp(string dumpJson)
    {
        var tempPath = Path.Combine(Path.GetTempPath(), $"dump_{Guid.NewGuid()}.json");
        File.WriteAllText(tempPath, dumpJson);
        return tempPath;
    }

    [Fact]
    public void CompareDumps_MicroflowAnnotationAddedWithoutContainerId_IsReportedAsModified()
    {
        var headDump = """
        {
            "units": [
                {
                    "$ID": "mf-1",
                    "$Type": "Microflows$Microflow",
                    "$QualifiedName": "New_Module.ACO_new",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "objectCollection": {
                        "$ID": "mf-oc-1",
                        "$Type": "Microflows$MicroflowObjectCollection",
                        "objects": [
                            {
                                "$ID": "activity-1",
                                "$Type": "Microflows$ActionActivity",
                                "action": {
                                    "$ID": "action-1",
                                    "$Type": "Microflows$CloseFormAction"
                                }
                            }
                        ]
                    }
                }
            ]
        }
        """;

        var workingDump = """
        {
            "units": [
                {
                    "$ID": "mf-1",
                    "$Type": "Microflows$Microflow",
                    "$QualifiedName": "New_Module.ACO_new",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "objectCollection": {
                        "$ID": "mf-oc-1",
                        "$Type": "Microflows$MicroflowObjectCollection",
                        "objects": [
                            {
                                "$ID": "activity-1",
                                "$Type": "Microflows$ActionActivity",
                                "relativeMiddlePoint": "10,10",
                                "action": {
                                    "$ID": "action-1",
                                    "$Type": "Microflows$CloseFormAction"
                                }
                            },
                            {
                                "$ID": "annotation-1",
                                "$Type": "Microflows$Annotation",
                                "text": "Added from test"
                            }
                        ]
                    }
                }
            ]
        }
        """;

        var headPath = WriteDumpToTemp(headDump);
        var workingPath = WriteDumpToTemp(workingDump);

        try
        {
            var changes = MendixModelDiffService.CompareDumps(workingPath, headPath);
            var flowChange = changes.FirstOrDefault(change =>
                change.ElementType == "Microflow" &&
                change.ElementName == "New_Module.ACO_new");

            Assert.NotNull(flowChange);
            Assert.Equal("Modified", flowChange.ChangeType);
            Assert.NotNull(flowChange.Details);
            Assert.Contains("annotations delta: added 1, removed 0, modified 0", flowChange.Details);
            Assert.Contains("annotations added (1): text=Added from test", flowChange.Details);
            Assert.DoesNotContain("relativeMiddlePoint", flowChange.Details, StringComparison.OrdinalIgnoreCase);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
