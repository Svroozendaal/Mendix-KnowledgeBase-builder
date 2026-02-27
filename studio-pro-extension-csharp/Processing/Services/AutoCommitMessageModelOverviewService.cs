using System.Text;

namespace AutoCommitMessage;

/// <summary>
/// Produces a scaffolded "model overview" output that can be replaced by a full single-dump parser pipeline.
/// </summary>
public static class AutoCommitMessageModelOverviewService
{
    public static ModelOverviewGenerationResult GenerateOverview(string projectPath)
    {
        var payload = AutoCommitMessageChangeService.ReadChanges(projectPath);

        if (!payload.IsGitRepo)
        {
            return new ModelOverviewGenerationResult(
                Success: false,
                Message: "Current project is not a Git repository.",
                OverviewText: null,
                ChangedFileCount: 0,
                ChangedModelFileCount: 0,
                GeneratedAtUtc: DateTimeOffset.UtcNow);
        }

        if (!string.IsNullOrWhiteSpace(payload.Error))
        {
            return new ModelOverviewGenerationResult(
                Success: false,
                Message: payload.Error,
                OverviewText: null,
                ChangedFileCount: 0,
                ChangedModelFileCount: 0,
                GeneratedAtUtc: DateTimeOffset.UtcNow);
        }

        var changedFiles = payload.Changes ?? Array.Empty<AutoCommitMessageFileChange>();
        var modelFiles = changedFiles
            .Where(change => change.FilePath.EndsWith(".mpr", StringComparison.OrdinalIgnoreCase))
            .ToList();

        var generatedAtUtc = DateTimeOffset.UtcNow;
        var overviewBuilder = new StringBuilder();
        overviewBuilder.AppendLine("# Model Overview (Skeleton)");
        overviewBuilder.AppendLine($"GeneratedAtUtc: {generatedAtUtc:O}");
        overviewBuilder.AppendLine($"Branch: {payload.BranchName}");
        overviewBuilder.AppendLine($"ChangedFilesInScope: {changedFiles.Count}");
        overviewBuilder.AppendLine($"ChangedModelFilesInScope: {modelFiles.Count}");
        overviewBuilder.AppendLine();
        overviewBuilder.AppendLine("// TODO: Replace this scaffold with a full single-dump model inventory.");
        overviewBuilder.AppendLine("// TODO: Add a parser pipeline that enumerates all model elements, not only diffs.");
        overviewBuilder.AppendLine("// TODO: Keep deterministic ordering for stable overview output.");
        overviewBuilder.AppendLine();

        if (modelFiles.Count == 0)
        {
            overviewBuilder.AppendLine("No changed .mpr files are currently available.");
            overviewBuilder.AppendLine("This scaffold currently reuses diff payload data.");
        }
        else
        {
            foreach (var fileChange in modelFiles)
            {
                overviewBuilder.AppendLine($"## {fileChange.FilePath}");
                var groupedChanges = fileChange.ModelChangesByModule ?? Array.Empty<MendixModuleChangeGroup>();

                if (groupedChanges.Count == 0)
                {
                    overviewBuilder.AppendLine("- No grouped model change data available for this file.");
                    overviewBuilder.AppendLine();
                    continue;
                }

                foreach (var moduleGroup in groupedChanges.OrderBy(group => group.Module, StringComparer.OrdinalIgnoreCase))
                {
                    var moduleName = string.IsNullOrWhiteSpace(moduleGroup.Module) ? "Unknown" : moduleGroup.Module;
                    var moduleChangeCount =
                        moduleGroup.DomainModel.Count +
                        moduleGroup.Microflows.Count +
                        moduleGroup.Pages.Count +
                        moduleGroup.Nanoflows.Count +
                        moduleGroup.Resources.Count;

                    overviewBuilder.AppendLine($"### Module: {moduleName} ({moduleChangeCount} changes)");
                    AppendSection(overviewBuilder, "DomainModel", moduleGroup.DomainModel);
                    AppendSection(overviewBuilder, "Microflows", moduleGroup.Microflows);
                    AppendSection(overviewBuilder, "Pages", moduleGroup.Pages);
                    AppendSection(overviewBuilder, "Nanoflows", moduleGroup.Nanoflows);
                    AppendSection(overviewBuilder, "Resources", moduleGroup.Resources);
                }

                overviewBuilder.AppendLine();
            }
        }

        return new ModelOverviewGenerationResult(
            Success: true,
            Message: "Model overview generated from current scaffold.",
            OverviewText: overviewBuilder.ToString().TrimEnd(),
            ChangedFileCount: changedFiles.Count,
            ChangedModelFileCount: modelFiles.Count,
            GeneratedAtUtc: generatedAtUtc);
    }

    private static void AppendSection(
        StringBuilder overviewBuilder,
        string sectionName,
        IReadOnlyList<MendixModelChange> changes)
    {
        if (changes.Count == 0)
        {
            return;
        }

        overviewBuilder.AppendLine($"- {sectionName}: {changes.Count}");
        foreach (var change in changes.OrderBy(item => item.ElementName, StringComparer.OrdinalIgnoreCase))
        {
            var row = string.IsNullOrWhiteSpace(change.DisplayText)
                ? $"{change.ChangeType} {change.ElementType} {change.ElementName}"
                : change.DisplayText;

            overviewBuilder.AppendLine($"  - {row}");
        }
    }
}

public sealed record ModelOverviewGenerationResult(
    bool Success,
    string Message,
    string? OverviewText,
    int ChangedFileCount,
    int ChangedModelFileCount,
    DateTimeOffset GeneratedAtUtc);
