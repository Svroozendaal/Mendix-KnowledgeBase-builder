using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoCommitMessage;

/// <summary>
/// Caches HEAD model dumps by commit SHA to avoid repeated mx.exe dump operations during refresh.
/// Cache key format: <normalized mpr path> + <HEAD commit SHA>
/// Cache storage: <DataRoot>/dumps/head-cache/<commitHash>/<mpr-filename-without-extension>.json
/// </summary>
public static class AutoCommitMessageHeadDumpCacheService
{
    private const string HeadCacheSubfolder = "head-cache";
    private static readonly Regex InvalidPathCharsRegex = new Regex(@"[\\/:*?""<>|]");

    /// <summary>
    /// Attempts to retrieve a cached HEAD dump for the given MPR and commit SHA.
    /// </summary>
    /// <param name="mprPath">Full path to the .mpr file.</param>
    /// <param name="headCommitSha">Git HEAD commit SHA (short or full).</param>
    /// <param name="dumpFilePath">Output path to cached dump JSON, if found and valid.</param>
    /// <returns>True if cache hit and file exists; false otherwise.</returns>
    public static bool TryGetCachedDump(string mprPath, string headCommitSha, out string? dumpFilePath)
    {
        dumpFilePath = null;

        if (string.IsNullOrWhiteSpace(mprPath) || string.IsNullOrWhiteSpace(headCommitSha))
        {
            return false;
        }

        var cachePath = GetCachePath(mprPath, headCommitSha);
        if (!File.Exists(cachePath))
        {
            return false;
        }

        dumpFilePath = cachePath;
        return true;
    }

    /// <summary>
    /// Gets the cache path for a given MPR file and commit SHA.
    /// </summary>
    /// <param name="mprPath">Full path to the .mpr file.</param>
    /// <param name="headCommitSha">Git HEAD commit SHA.</param>
    /// <returns>Full path where the cached dump should be stored.</returns>
    public static string GetCachePath(string mprPath, string headCommitSha)
    {
        if (string.IsNullOrWhiteSpace(mprPath))
        {
            throw new ArgumentException("MPR path cannot be null or empty.", nameof(mprPath));
        }

        if (string.IsNullOrWhiteSpace(headCommitSha))
        {
            throw new ArgumentException("HEAD commit SHA cannot be null or empty.", nameof(headCommitSha));
        }

        // Normalize MPR filename: remove extension, sanitize for file path
        var mprFilename = Path.GetFileNameWithoutExtension(mprPath);
        var sanitizedFilename = InvalidPathCharsRegex.Replace(mprFilename, "_");

        // Build cache directory: <DataRoot>/dumps/head-cache/<commitHash>/
        var cacheDir = Path.Combine(ExtensionDataPaths.DataRoot, "dumps", HeadCacheSubfolder, headCommitSha);

        // Create directory if it doesn't exist
        if (!Directory.Exists(cacheDir))
        {
            Directory.CreateDirectory(cacheDir);
        }

        // Return cache file path
        return Path.Combine(cacheDir, $"{sanitizedFilename}.json");
    }

    /// <summary>
    /// Caches a HEAD dump file for later reuse.
    /// </summary>
    /// <param name="sourceDumpPath">Path to the generated dump JSON file.</param>
    /// <param name="mprPath">Full path to the .mpr file.</param>
    /// <param name="headCommitSha">Git HEAD commit SHA.</param>
    /// <returns>True if cache save succeeded; false on error.</returns>
    public static bool TryCacheDump(string sourceDumpPath, string mprPath, string headCommitSha)
    {
        if (string.IsNullOrWhiteSpace(sourceDumpPath) || !File.Exists(sourceDumpPath))
        {
            return false;
        }

        try
        {
            var cachePath = GetCachePath(mprPath, headCommitSha);
            File.Copy(sourceDumpPath, cachePath, overwrite: true);
            return true;
        }
        catch
        {
            // Silently fail on cache write errors; dump is still usable for this session
            return false;
        }
    }

    /// <summary>
    /// Prunes old cache entries, keeping only the most recent commit hashes.
    /// Prune is best-effort and non-blocking; failures log but do not throw.
    /// </summary>
    /// <param name="dataRoot">Data root path (if null, uses default).</param>
    /// <param name="currentHeadCommitSha">Current HEAD commit SHA; this folder is preserved.</param>
    /// <param name="maxAgeDays">Maximum age in days for cache folders (default: 30).</param>
    public static void PruneOldCacheEntries(string dataRoot, string currentHeadCommitSha, int maxAgeDays = 30)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(dataRoot))
            {
                dataRoot = ExtensionDataPaths.DataRoot;
            }

            var cacheDirPath = Path.Combine(dataRoot, "dumps", HeadCacheSubfolder);
            if (!Directory.Exists(cacheDirPath))
            {
                return;
            }

            var now = DateTime.Now;
            var maxAgeTimespan = TimeSpan.FromDays(maxAgeDays);

            foreach (var commitHashDir in Directory.GetDirectories(cacheDirPath))
            {
                var dirName = Path.GetFileName(commitHashDir);

                // Preserve current HEAD commit folder
                if (string.Equals(dirName, currentHeadCommitSha, StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                try
                {
                    var dirInfo = new DirectoryInfo(commitHashDir);
                    if (now - dirInfo.LastWriteTime > maxAgeTimespan)
                    {
                        Directory.Delete(commitHashDir, recursive: true);
                    }
                }
                catch
                {
                    // Log warning but continue with other entries
                    // TODO: Log: Failed to prune cache folder {commitHashDir}
                }
            }
        }
        catch
        {
            // Prune failures are non-critical; log warning but do not throw
            // TODO: Log: HEAD dump cache prune failed
        }
    }
}
