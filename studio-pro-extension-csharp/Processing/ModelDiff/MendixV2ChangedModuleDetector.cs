using System.Text.RegularExpressions;
using LibGit2Sharp;

namespace AutoCommitMessage;

/// <summary>
/// Detects changed modules in MPR v2 format by analyzing git status and diff.
/// Extracts module names from mprcontents/ directory structure.
/// </summary>
public static class MendixV2ChangedModuleDetector
{
    private static readonly Regex MprContentsModulePathRegex = new(@"^mprcontents[/\\]([^/\\]+)[/\\]", RegexOptions.IgnoreCase);

    /// <summary>
    /// Detects which modules have changed in an MPR v2 project.
    /// </summary>
    /// <param name="repository">Git repository instance.</param>
    /// <param name="mprContentsBasePath">Relative path to mprcontents directory (e.g., "mprcontents" or "path/to/mprcontents").</param>
    /// <returns>List of distinct module names with changes, or empty list if none detected.</returns>
    public static IReadOnlyList<string> DetectChangedModules(Repository repository, string mprContentsBasePath = "mprcontents")
    {
        if (repository is null)
        {
            return Array.Empty<string>();
        }

        try
        {
            var changedModules = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

            // Normalize mprcontents base path for use in path pattern matching
            var normalizedBasePath = mprContentsBasePath.Replace('\\', '/');
            if (!normalizedBasePath.EndsWith("/", StringComparison.Ordinal))
            {
                normalizedBasePath += "/";
            }

            // Retrieve git status to find all modified/added/deleted files
            var statusOptions = new StatusOptions
            {
                IncludeIgnored = false,
                IncludeUntracked = true,
                RecurseUntrackedDirs = true,
            };

            var statusEntries = repository.RetrieveStatus(statusOptions);

            foreach (var entry in statusEntries)
            {
                // Normalize path for comparison
                var normalizedPath = entry.FilePath.Replace('\\', '/');

                // Check if this file is under mprcontents
                if (!normalizedPath.StartsWith(normalizedBasePath, StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                // Extract module name from path: mprcontents/<module>/<rest-of-path>
                var relativePath = normalizedPath[normalizedBasePath.Length..];
                var moduleMatch = Regex.Match(relativePath, @"^([^/]+)[/]?", RegexOptions.IgnoreCase);
                if (moduleMatch.Success)
                {
                    var moduleName = moduleMatch.Groups[1].Value;
                    if (!string.IsNullOrWhiteSpace(moduleName))
                    {
                        changedModules.Add(moduleName);
                    }
                }
            }

            return changedModules.OrderBy(x => x, StringComparer.OrdinalIgnoreCase).ToList();
        }
        catch
        {
            // On any error, return empty list
            return Array.Empty<string>();
        }
    }
}
