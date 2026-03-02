using Xunit;

namespace AutoCommitMessage.Tests;

/// <summary>
/// Unit tests for deterministic display-text formatting.
/// </summary>
public class MendixModelChangeDisplayTextFormatterTests
{
    [Fact]
    public void DisplayText_FlowDecisionChanges_AreFoldedIntoActionBuckets()
    {
        var details =
            "flows count 19->21; " +
            "actions delta: added 0, removed 1, modified 0; " +
            "actions removed (1): ValidationFeedbackAction x1; " +
            "removed action details: ValidationFeedbackAction: action payload changed; " +
            "decisions delta: added 0, removed 1, modified 1; " +
            "decisions removed (1): FTE >=0 expression=$JournalItem/Quantity >= 0; " +
            "decisions modified (1): is TWK? expression=$JournalItem/EntryType = TWK.Enum_JournalItemType.TWK -> is TWK? expression=$JournalItem/EntryType";

        var change = new MendixModelChange(
            ChangeType: "Modified",
            ElementType: "Microflow",
            ElementName: "TWK.SUB_JournalItem_QuantityChange",
            Details: details);

        var displayText = change.DisplayText;

        Assert.Contains("removed: validation feedback, decision FTE >=0", displayText);
        Assert.Contains("modified: decision is TWK?", displayText);
        Assert.DoesNotContain("decisions:", displayText, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void DisplayText_FlowDecisionAdded_AppearsInsideAddedBucket()
    {
        var details =
            "actions delta: added 1, removed 0, modified 0; " +
            "actions added (1): ChangeVariableAction x1; " +
            "added action details: ChangeVariableAction: change variable isOk=false; " +
            "decisions delta: added 1, removed 0, modified 0; " +
            "decisions added (1): amount valid? expression=$Value > 0";

        var change = new MendixModelChange(
            ChangeType: "Modified",
            ElementType: "Microflow",
            ElementName: "TWK.VAL_Helper",
            Details: details);

        var displayText = change.DisplayText;

        Assert.Contains("added: change variable, decision amount valid?", displayText);
        Assert.DoesNotContain("decisions:", displayText, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void DisplayText_FlowAnnotationAdded_AppearsInsideAddedBucket()
    {
        var details =
            "annotations delta: added 1, removed 0, modified 0; " +
            "annotations added (1): text=Need validation";

        var change = new MendixModelChange(
            ChangeType: "Modified",
            ElementType: "Microflow",
            ElementName: "New_Module.ACO_new",
            Details: details);

        var displayText = change.DisplayText;

        Assert.Contains("added: annotation Need validation", displayText);
        Assert.DoesNotContain("annotations delta:", displayText, StringComparison.OrdinalIgnoreCase);
    }
}
