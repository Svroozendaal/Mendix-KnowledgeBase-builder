namespace AutoCommitMessage;

/// <summary>
/// Service for one-time migration of legacy folder names.
/// Safely renames legacy folders to _legacy_* variants and logs warnings.
/// Idempotent - safe to call every startup.
/// </summary>
internal static class AutoCommitMessageFolderMigrationService
{
    /// <summary>
    /// Runs folder migration once during startup.
    /// Checks for legacy folders (exports/, structured/) and renames them safely.
    /// </summary>
    public static void MigrateIfNeeded(string dataRootPath)
    {
        if (string.IsNullOrWhiteSpace(dataRootPath))
        {
            return;
        }

        try
        {
            var legacyExportsPath = Path.Combine(dataRootPath, "exports");
            var legacyStructuredPath = Path.Combine(dataRootPath, "structured");
            var migratedExportsPath = Path.Combine(dataRootPath, "_legacy_exports");
            var migratedStructuredPath = Path.Combine(dataRootPath, "_legacy_structured");

            // Migrate exports/ if it exists and _legacy_exports/ doesn't.
            if (Directory.Exists(legacyExportsPath) && !Directory.Exists(migratedExportsPath))
            {
                try
                {
                    Directory.Move(legacyExportsPath, migratedExportsPath);
                    System.Diagnostics.Debug.WriteLine(
                        $"[AutoCommitMessage] Migrated legacy folder: {legacyExportsPath} → {migratedExportsPath}. " +
                        $"This folder can be manually removed after validation.");
                }
                catch
                {
                    // If migration fails, ignore - folder might be locked or in use.
                }
            }

            // Migrate structured/ if it exists and _legacy_structured/ doesn't.
            if (Directory.Exists(legacyStructuredPath) && !Directory.Exists(migratedStructuredPath))
            {
                try
                {
                    Directory.Move(legacyStructuredPath, migratedStructuredPath);
                    System.Diagnostics.Debug.WriteLine(
                        $"[AutoCommitMessage] Migrated legacy folder: {legacyStructuredPath} → {migratedStructuredPath}. " +
                        $"This folder can be manually removed after validation.");
                }
                catch
                {
                    // If migration fails, ignore - folder might be locked or in use.
                }
            }
        }
        catch
        {
            // Silently ignore any migration errors - they are non-fatal.
        }
    }
}
