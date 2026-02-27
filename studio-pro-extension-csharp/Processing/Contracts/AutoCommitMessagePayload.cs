using System.Collections.Generic;

namespace AutoCommitMessage;

/// <summary>
/// Represents one uncommitted file change in the current Git repository.
/// </summary>
public sealed record AutoCommitMessageFileChange
{
    /// <summary>
    /// Gets the repository-relative file path.
    /// </summary>
    public string FilePath { get; init; } = string.Empty;

    /// <summary>
    /// Gets the normalized Git status label.
    /// </summary>
    public string Status { get; init; } = string.Empty;

    /// <summary>
    /// Gets a value indicating whether the file change is staged in the Git index.
    /// </summary>
    public bool IsStaged { get; init; }

    /// <summary>
    /// Gets the textual patch content for this file, or an informative fallback message.
    /// </summary>
    public string DiffText { get; init; } = string.Empty;

    /// <summary>
    /// Gets optional model-level change details for .mpr files.
    /// </summary>
    public IReadOnlyList<MendixModelChange>? ModelChanges { get; init; }

    /// <summary>
    /// Gets optional model changes grouped per module and category.
    /// </summary>
    public IReadOnlyList<MendixModuleChangeGroup>? ModelChangesByModule { get; init; }

    /// <summary>
    /// Gets optional persisted dump artifact paths for model analysis.
    /// </summary>
    public ModelDumpArtifact? ModelDumpArtifact { get; init; }
}

/// <summary>
/// Represents the Git changes read result for the currently opened project.
/// </summary>
public sealed record AutoCommitMessagePayload
{
    /// <summary>
    /// Gets a value indicating whether the project path belongs to a Git repository.
    /// </summary>
    public bool IsGitRepo { get; init; }

    /// <summary>
    /// Gets the currently checked out branch name.
    /// </summary>
    public string BranchName { get; init; } = string.Empty;

    /// <summary>
    /// Gets the collection of filtered uncommitted file changes.
    /// </summary>
    public IReadOnlyList<AutoCommitMessageFileChange> Changes { get; init; } = new List<AutoCommitMessageFileChange>();

    /// <summary>
    /// Gets an optional user-friendly error message.
    /// </summary>
    public string? Error { get; init; }
}

/// <summary>
/// Paths to persisted model dump artifacts for a single changed model file.
/// </summary>
public sealed record ModelDumpArtifact(
    string FolderPath,
    string WorkingDumpPath,
    string HeadDumpPath
);

/// <summary>
/// Represents model changes grouped by Mendix module.
/// </summary>
/// <param name="Module">Mendix module name derived from element name prefix.</param>
/// <param name="DomainModel">Changes for Entity elements.</param>
/// <param name="Microflows">Changes for Microflow elements.</param>
/// <param name="Pages">Changes for Page elements.</param>
/// <param name="Nanoflows">Changes for Nanoflow elements.</param>
/// <param name="Resources">Changes for all other element types.</param>
public sealed record MendixModuleChangeGroup(
    string Module,
    IReadOnlyList<MendixModelChange> DomainModel,
    IReadOnlyList<MendixModelChange> Microflows,
    IReadOnlyList<MendixModelChange> Pages,
    IReadOnlyList<MendixModelChange> Nanoflows,
    IReadOnlyList<MendixModelChange> Resources
);



