using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for page/snippet detail extraction in MendixModelDiffService.
/// </summary>
public class MendixModelDiffServicePageDetailsTests
{
    private static string WriteDumpToTemp(string dumpJson)
    {
        var tempPath = Path.Combine(Path.GetTempPath(), $"dump_{Guid.NewGuid()}.json");
        File.WriteAllText(tempPath, dumpJson);
        return tempPath;
    }

    [Fact]
    public void CompareDumps_ModifiedPageActionBinding_EmitsDeltaWithoutUsedNoise()
    {
        var headDump = """
        {
            "units": [
                {
                    "$ID": "page-1",
                    "$Type": "Pages$Page",
                    "$QualifiedName": "TestModule.Page_Edit",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "layoutCall": {
                        "$ID": "layout-1",
                        "$Type": "Pages$LayoutCall",
                        "layout": "General.VU_PopupLayout",
                        "widgets": [
                            {
                                "$ID": "button-1",
                                "$Type": "Pages$ActionButton",
                                "action": {
                                    "$ID": "action-1",
                                    "$Type": "Pages$MicroflowClientAction",
                                    "microflow": "TestModule.ACT_Old"
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
                    "$ID": "page-1",
                    "$Type": "Pages$Page",
                    "$QualifiedName": "TestModule.Page_Edit",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "layoutCall": {
                        "$ID": "layout-1",
                        "$Type": "Pages$LayoutCall",
                        "layout": "General.VU_PopupLayout",
                        "widgets": [
                            {
                                "$ID": "button-1",
                                "$Type": "Pages$ActionButton",
                                "action": {
                                    "$ID": "action-1",
                                    "$Type": "Pages$MicroflowClientAction",
                                    "microflow": "TestModule.ACT_New"
                                }
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
            var pageChange = changes.FirstOrDefault(change =>
                change.ElementType == "Page" &&
                change.ElementName == "TestModule.Page_Edit");

            Assert.NotNull(pageChange);
            Assert.Equal("Modified", pageChange.ChangeType);
            Assert.NotNull(pageChange.Details);
            Assert.Contains("modified ActionButton", pageChange.Details);
            Assert.Contains("onClick TestModule.ACT_Old->TestModule.ACT_New", pageChange.Details);
            Assert.DoesNotContain("layoutCall updated", pageChange.Details, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("actions delta:", pageChange.Details, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("actions used", pageChange.Details, StringComparison.OrdinalIgnoreCase);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_ModifiedSnippetActionBinding_EmitsDeltaWithoutGenericWidgetNoise()
    {
        var headDump = """
        {
            "units": [
                {
                    "$ID": "snippet-1",
                    "$Type": "Pages$Snippet",
                    "$QualifiedName": "TestModule.SNP_Request_Overview",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "layoutCall": {
                        "$ID": "layout-2",
                        "$Type": "Pages$LayoutCall",
                        "widgets": [
                            {
                                "$ID": "button-2",
                                "$Type": "Pages$ActionButton",
                                "action": {
                                    "$ID": "action-2",
                                    "$Type": "Pages$PageClientAction",
                                    "page": "TestModule.Page_Old"
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
                    "$ID": "snippet-1",
                    "$Type": "Pages$Snippet",
                    "$QualifiedName": "TestModule.SNP_Request_Overview",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "layoutCall": {
                        "$ID": "layout-2",
                        "$Type": "Pages$LayoutCall",
                        "widgets": [
                            {
                                "$ID": "button-2",
                                "$Type": "Pages$ActionButton",
                                "action": {
                                    "$ID": "action-2",
                                    "$Type": "Pages$PageClientAction",
                                    "page": "TestModule.Page_New"
                                }
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
            var snippetChange = changes.FirstOrDefault(change =>
                change.ElementType == "Snippet" &&
                change.ElementName == "TestModule.SNP_Request_Overview");

            Assert.NotNull(snippetChange);
            Assert.Equal("Modified", snippetChange.ChangeType);
            Assert.NotNull(snippetChange.Details);
            Assert.Contains("modified ActionButton", snippetChange.Details);
            Assert.Contains("showPage TestModule.Page_Old->TestModule.Page_New", snippetChange.Details);
            Assert.DoesNotContain("widgets entries updated", snippetChange.Details, StringComparison.OrdinalIgnoreCase);
            Assert.DoesNotContain("actions delta:", snippetChange.Details, StringComparison.OrdinalIgnoreCase);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }

    [Fact]
    public void CompareDumps_AddedPage_EmitsFunctionalWidgetSummary()
    {
        var headDump = """
        {
            "units": []
        }
        """;

        var workingDump = """
        {
            "units": [
                {
                    "$ID": "page-functional-1",
                    "$Type": "Pages$Page",
                    "$QualifiedName": "TestModule.Page_Functional",
                    "$ContainerID": "module-1",
                    "$ContainerProperty": "documents",
                    "layoutCall": {
                        "$ID": "layout-functional-1",
                        "$Type": "Pages$LayoutCall",
                        "layout": "Atlas_Core.Atlas_Default",
                        "widgets": [
                            { "$ID": "widget-1", "$Type": "Pages$ActionButton" },
                            { "$ID": "widget-2", "$Type": "Pages$DataView" },
                            { "$ID": "widget-3", "$Type": "Pages$DataGrid" },
                            { "$ID": "widget-4", "$Type": "Pages$DataGrid2" },
                            { "$ID": "widget-5", "$Type": "Pages$SnippetCallWidget" },
                            { "$ID": "widget-6", "$Type": "Pages$DivContainer" }
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
            var pageChange = changes.FirstOrDefault(change =>
                change.ElementType == "Page" &&
                change.ElementName == "TestModule.Page_Functional");

            Assert.NotNull(pageChange);
            Assert.Equal("Added", pageChange.ChangeType);
            Assert.NotNull(pageChange.Details);
            Assert.Contains("functional widgets (5):", pageChange.Details);
            Assert.Contains("ActionButton x1", pageChange.Details);
            Assert.Contains("DataView x1", pageChange.Details);
            Assert.Contains("DataGrid x1", pageChange.Details);
            Assert.Contains("DataGrid2 x1", pageChange.Details);
            Assert.Contains("Snippet x1", pageChange.Details);
        }
        finally
        {
            File.Delete(headPath);
            File.Delete(workingPath);
        }
    }
}
