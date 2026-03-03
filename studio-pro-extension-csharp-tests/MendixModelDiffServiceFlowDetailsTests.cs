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

    [Fact]
    public void CompareDumps_MicroflowAllowedRolesOnlyChange_DoesNotEmitBaselineFlowMetadata()
    {
        var headDump = """
        {
            "units": [
                {
                    "$ID": "mf-roles-1",
                    "$Type": "Microflows$Microflow",
                    "$QualifiedName": "IXAGOProject.DS_ResearcherProfile_SelectableSections",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "allowedModuleRoles": [
                        { "$ID": "role-1" },
                        { "$ID": "role-2" },
                        { "$ID": "role-3" }
                    ],
                    "objectCollection": {
                        "$ID": "mf-oc-roles-1",
                        "$Type": "Microflows$MicroflowObjectCollection",
                        "objects": [
                            {
                                "$ID": "activity-1",
                                "$Type": "Microflows$ActionActivity",
                                "action": { "$ID": "action-1", "$Type": "Microflows$CloseFormAction" }
                            }
                        ]
                    },
                    "flows": [
                        { "$ID": "sf-1", "$Type": "Microflows$SequenceFlow" }
                    ]
                }
            ]
        }
        """;

        var workingDump = """
        {
            "units": [
                {
                    "$ID": "mf-roles-1",
                    "$Type": "Microflows$Microflow",
                    "$QualifiedName": "IXAGOProject.DS_ResearcherProfile_SelectableSections",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "allowedModuleRoles": [
                        { "$ID": "role-1" },
                        { "$ID": "role-2" },
                        { "$ID": "role-3" },
                        { "$ID": "role-4" }
                    ],
                    "objectCollection": {
                        "$ID": "mf-oc-roles-1",
                        "$Type": "Microflows$MicroflowObjectCollection",
                        "objects": [
                            {
                                "$ID": "activity-1",
                                "$Type": "Microflows$ActionActivity",
                                "action": { "$ID": "action-1", "$Type": "Microflows$CloseFormAction" }
                            }
                        ]
                    },
                    "flows": [
                        { "$ID": "sf-1", "$Type": "Microflows$SequenceFlow" }
                    ]
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
                change.ElementName == "IXAGOProject.DS_ResearcherProfile_SelectableSections");

            Assert.NotNull(flowChange);
            Assert.Equal("Modified", flowChange.ChangeType);
            Assert.NotNull(flowChange.Details);
            Assert.Contains("allowedModuleRoles count 3->4", flowChange.Details);
            Assert.DoesNotContain("flow structure:", flowChange.Details, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("flow metadata:", flowChange.Details, StringComparison.OrdinalIgnoreCase);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
