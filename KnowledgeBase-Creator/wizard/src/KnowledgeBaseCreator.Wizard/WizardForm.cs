namespace KnowledgeBaseCreator.Wizard;

internal sealed class WizardForm : Form
{
    private readonly TextBox _mprPathBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _appNameBox = new() { Dock = DockStyle.Fill };
    private readonly ComboBox _extractionModeBox = new() { Dock = DockStyle.Fill, DropDownStyle = ComboBoxStyle.DropDownList };
    private readonly TextBox _installRootBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _mxPathBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _dataRootBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _appFolderBox = new() { Dock = DockStyle.Fill, ReadOnly = true };
    private readonly Button _browseInstallButton = new() { Text = "Browse...", AutoSize = true };
    private readonly Button _browseMxButton = new() { Text = "Browse...", AutoSize = true };
    private readonly Button _autoDetectMxButton = new() { Text = "Auto detect", AutoSize = true };
    private readonly Button _runButton = new() { Text = "Run Pipeline", AutoSize = true };
    private readonly Button _enrichButton = new() { Text = "Enrich KB", AutoSize = true, Enabled = false };
    private readonly Button _enrichModulesButton = new() { Text = "Enrich Modules...", AutoSize = true, Enabled = false };
    private readonly Button _updateAgentsButton = new() { Text = "Update Agents", AutoSize = true, Enabled = false };
    private readonly Button _addCopilotButton = new() { Text = "Add Copilot", AutoSize = true };
    private readonly Button _openAppButton = new() { Text = "Open App", AutoSize = true };
    private readonly Button _settingsButton = new() { Text = "AI Settings...", AutoSize = true };
    private readonly CheckBox _autoEnrichCheck = new() { Text = "Auto-enrich after pipeline", AutoSize = true };
    private readonly TextBox _logBox = new()
    {
        Multiline = true,
        ScrollBars = ScrollBars.Vertical,
        Dock = DockStyle.Fill,
        ReadOnly = true,
        WordWrap = false,
    };

    private readonly string _wizardRoot;
    private readonly string _packageRoot;
    private readonly string _configPath;
    private WizardConfig _config;
    private string? _suggestedDataRoot;

    public WizardForm()
    {
        Text = "KnowledgeBase Creator Setup Wizard";
        Width = 980;
        Height = 700;
        StartPosition = FormStartPosition.CenterScreen;

        _wizardRoot = WizardRuntime.FindWizardRoot(AppContext.BaseDirectory);
        _packageRoot = Directory.GetParent(_wizardRoot)?.FullName ?? _wizardRoot;
        _configPath = Path.Combine(_wizardRoot, "config.last.json");
        _config = WizardRuntime.LoadConfig(_configPath);

        BuildLayout();
        LoadDefaults();
    }

    private void BuildLayout()
    {
        var root = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 2,
        };
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100f));
        Controls.Add(root);

        var settings = new TableLayoutPanel
        {
            Dock = DockStyle.Top,
            ColumnCount = 4,
            RowCount = 11,
            AutoSize = true,
            Padding = new Padding(12),
        };
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 190));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 110));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 110));

        var browseMprButton = new Button { Text = "Browse...", AutoSize = true };
        browseMprButton.Click += (_, _) => BrowseMpr();
        _browseInstallButton.Click += (_, _) => BrowseInstallRoot();
        _browseMxButton.Click += (_, _) => BrowseMx();
        var browseDataRootButton = new Button { Text = "Browse...", AutoSize = true };
        browseDataRootButton.Click += (_, _) => BrowseDataRoot();
        _autoDetectMxButton.Click += (_, _) => AutoDetectMx();

        _mprPathBox.TextChanged += (_, _) => OnMprPathChanged();
        _dataRootBox.TextChanged += (_, _) => RefreshEnrichReady();
        _extractionModeBox.SelectedIndexChanged += (_, _) => ApplyExtractionModeUiState();

        AddRow(settings, 0, "MPR file", _mprPathBox, browseMprButton, EmptyControl());
        AddRow(settings, 1, "App name", _appNameBox, EmptyControl(), EmptyControl());
        AddRow(settings, 2, "Extraction mode", _extractionModeBox, EmptyControl(), EmptyControl());
        AddRow(settings, 3, "Mendix install root", _installRootBox, _browseInstallButton, EmptyControl());
        AddRow(settings, 4, "mx.exe", _mxPathBox, _autoDetectMxButton, _browseMxButton);
        AddRow(settings, 5, "Output data root", _dataRootBox, browseDataRootButton, EmptyControl());
        AddRow(settings, 6, "Mendix app folder", _appFolderBox, EmptyControl(), EmptyControl());
        AddRow(settings, 7, string.Empty, _autoEnrichCheck, _settingsButton, EmptyControl());

        var actionFlow = new FlowLayoutPanel { Dock = DockStyle.Fill, AutoSize = true, WrapContents = false };
        actionFlow.Controls.AddRange([_runButton, _enrichButton, _enrichModulesButton, _updateAgentsButton]);
        AddRow(settings, 8, string.Empty, actionFlow, EmptyControl(), EmptyControl());

        var appFlow = new FlowLayoutPanel { Dock = DockStyle.Fill, AutoSize = true, WrapContents = false };
        appFlow.Controls.AddRange([_addCopilotButton, _openAppButton]);
        AddRow(settings, 9, string.Empty, appFlow, EmptyControl(), EmptyControl());

        _runButton.Click += async (_, _) => await RunPipelineAsync();
        _enrichButton.Click += async (_, _) => await RunEnrichmentAsync();
        _enrichModulesButton.Click += async (_, _) => await RunEnrichModulesAsync();
        _updateAgentsButton.Click += async (_, _) => await RunUpdateAgentsAsync();
        _addCopilotButton.Click += async (_, _) => await RunAddCopilotAsync();
        _openAppButton.Click += (_, _) => RunOpenApp();
        _settingsButton.Click += (_, _) => OpenAiSettings();
        root.Controls.Add(settings, 0, 0);

        var logPanel = new GroupBox
        {
            Text = "Run log",
            Dock = DockStyle.Fill,
            Padding = new Padding(8),
        };
        logPanel.Controls.Add(_logBox);
        root.Controls.Add(logPanel, 0, 1);
    }

    private static Control EmptyControl() => new Panel { Width = 1, Height = 1 };

    private static void AddRow(TableLayoutPanel panel, int row, string label, Control main, Control action1, Control action2)
    {
        panel.RowStyles.Add(new RowStyle(SizeType.AutoSize));
        panel.Controls.Add(new Label { Text = label, AutoSize = true, Anchor = AnchorStyles.Left }, 0, row);
        panel.Controls.Add(main, 1, row);
        panel.Controls.Add(action1, 2, row);
        panel.Controls.Add(action2, 3, row);
    }

    private void LoadDefaults()
    {
        _extractionModeBox.Items.Clear();
        _extractionModeBox.Items.Add(ExtractionMode.LegacyDumpParser.ToString());
        _extractionModeBox.Items.Add(ExtractionMode.MxCli.ToString());

        _mprPathBox.Text = _config.LastMprPath ?? string.Empty;
        _appNameBox.Text = _config.LastAppName ?? string.Empty;
        _installRootBox.Text = WizardRuntime.ResolveInstallRootDefault(_config);
        _mxPathBox.Text = _config.LastMxExePath ?? string.Empty;
        _dataRootBox.Text = _config.LastDataRoot ?? string.Empty;
        _autoEnrichCheck.Checked = _config.AutoEnrichAfterPipeline ?? false;
        _extractionModeBox.SelectedItem = WizardRuntime.ResolveExtractionModeDefault(_config).ToString();
        if (_extractionModeBox.SelectedIndex < 0)
        {
            _extractionModeBox.SelectedItem = ExtractionMode.MxCli.ToString();
        }
        ApplyExtractionModeUiState();
        RefreshDataRoot();
    }

    private ExtractionMode GetSelectedExtractionMode()
    {
        if (_extractionModeBox.SelectedItem is string selected &&
            Enum.TryParse<ExtractionMode>(selected, ignoreCase: true, out var mode))
        {
            return mode;
        }

        return ExtractionMode.MxCli;
    }

    private void ApplyExtractionModeUiState()
    {
        var mode = GetSelectedExtractionMode();
        var usesLegacyMx = mode == ExtractionMode.LegacyDumpParser;

        _installRootBox.Enabled = usesLegacyMx;
        _mxPathBox.Enabled = usesLegacyMx;
        _browseInstallButton.Enabled = usesLegacyMx;
        _browseMxButton.Enabled = usesLegacyMx;
        _autoDetectMxButton.Enabled = usesLegacyMx;
    }

    private void OnMprPathChanged()
    {
        RefreshDataRoot();
        var mprPath = _mprPathBox.Text.Trim();
        if (File.Exists(mprPath) && string.IsNullOrWhiteSpace(_appNameBox.Text))
        {
            _appNameBox.Text = Path.GetFileNameWithoutExtension(mprPath);
        }
    }

    private void RefreshDataRoot()
    {
        var mprPath = _mprPathBox.Text.Trim();
        if (File.Exists(mprPath))
        {
            var suggested = WizardRuntime.GetSuggestedDataRoot(mprPath);
            if (string.IsNullOrWhiteSpace(_dataRootBox.Text) ||
                string.Equals(_dataRootBox.Text.Trim(), _suggestedDataRoot, StringComparison.OrdinalIgnoreCase))
            {
                _dataRootBox.Text = suggested;
            }
            _suggestedDataRoot = suggested;
            _appFolderBox.Text = Path.GetDirectoryName(mprPath)!;
        }
        else
        {
            if (string.Equals(_dataRootBox.Text.Trim(), _suggestedDataRoot, StringComparison.OrdinalIgnoreCase))
            {
                _dataRootBox.Text = string.Empty;
            }
            _suggestedDataRoot = null;
            _appFolderBox.Text = "<select a valid .mpr file>";
        }

        RefreshEnrichReady();
    }

    private void RefreshEnrichReady()
    {
        var dataRoot = _dataRootBox.Text.Trim();
        if (string.IsNullOrWhiteSpace(dataRoot))
        {
            _enrichReady = false;
        }
        else
        {
            try
            {
                var normalized = WizardRuntime.NormalizeDataRootInput(dataRoot);
                var creatorLink = Path.Combine(normalized, "knowledge-base", "_sources", "creator-link.json");
                _enrichReady = File.Exists(creatorLink);
            }
            catch
            {
                _enrichReady = false;
            }
        }

        _enrichButton.Enabled = _enrichReady;
        _enrichModulesButton.Enabled = _enrichReady;
        _updateAgentsButton.Enabled = _enrichReady;
    }

    private void BrowseMpr()
    {
        using var dialog = new OpenFileDialog
        {
            Filter = "Mendix Project (*.mpr)|*.mpr|All files (*.*)|*.*",
            CheckFileExists = true,
            Multiselect = false,
            Title = "Select Mendix .mpr file",
        };

        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            _mprPathBox.Text = dialog.FileName;
            if (string.IsNullOrWhiteSpace(_appNameBox.Text))
            {
                _appNameBox.Text = Path.GetFileNameWithoutExtension(dialog.FileName);
            }
        }
    }

    private void BrowseInstallRoot()
    {
        using var dialog = new FolderBrowserDialog
        {
            Description = "Select Mendix installation root",
            UseDescriptionForTitle = true,
            InitialDirectory = _installRootBox.Text,
        };

        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            _installRootBox.Text = dialog.SelectedPath;
        }
    }

    private void BrowseMx()
    {
        using var dialog = new OpenFileDialog
        {
            Filter = "mx.exe|mx.exe|Executable files (*.exe)|*.exe|All files (*.*)|*.*",
            CheckFileExists = true,
            Multiselect = false,
            Title = "Select mx.exe",
        };

        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            _mxPathBox.Text = dialog.FileName;
        }
    }

    private void BrowseDataRoot()
    {
        using var dialog = new FolderBrowserDialog
        {
            Description = "Select the target mendix-data or knowledge-base folder",
            UseDescriptionForTitle = true,
            InitialDirectory = string.IsNullOrWhiteSpace(_dataRootBox.Text) ? _appFolderBox.Text : _dataRootBox.Text,
        };

        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            _dataRootBox.Text = dialog.SelectedPath;
        }
    }

    private void AutoDetectMx()
    {
        if (GetSelectedExtractionMode() != ExtractionMode.LegacyDumpParser)
        {
            AppendLog("mx.exe auto-detect is only used in LegacyDumpParser mode.");
            return;
        }

        try
        {
            var mprPath = WizardRuntime.ValidateMprPath(_mprPathBox.Text);
            var installRoot = _installRootBox.Text.Trim();
            var detection = WizardRuntime.DetectMxPath(mprPath, installRoot);

            if (!detection.Success || string.IsNullOrWhiteSpace(detection.SelectedMxPath))
            {
                var detail = detection.Error ?? "Unknown detection failure.";
                AppendLog($"Auto-detect failed: {detail}");
                MessageBox.Show(this, detail, "Auto-detect failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            _mxPathBox.Text = detection.SelectedMxPath;
            AppendLog($"Detected version {detection.RequiredVersion} using {detection.SelectedMxPath} ({(detection.UsedFallback ? "fallback" : "exact")}).");
        }
        catch (Exception ex)
        {
            MessageBox.Show(this, ex.Message, "Auto-detect failed", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
    }

    private void OpenAiSettings()
    {
        var currentSettings = _config.AiSettings ?? new AiSettings();
        using var form = new SettingsForm(currentSettings);
        if (form.ShowDialog(this) == DialogResult.OK)
        {
            _config.AiSettings = form.Result;
            WizardRuntime.SaveConfig(_configPath, _config);
            AppendLog($"AI provider set to: {ProviderLabel(form.Result.Provider)}");
        }
    }

    private static string ProviderLabel(AiProvider provider) => provider switch
    {
        AiProvider.ClaudeCli => "Claude CLI",
        AiProvider.CodexCli => "Codex CLI",
        AiProvider.ClaudeApi => "Claude API",
        _ => provider.ToString(),
    };

    private async Task RunPipelineAsync()
    {
        try
        {
            ToggleUi(false);
            _logBox.Clear();

            var mprPath = WizardRuntime.ValidateMprPath(_mprPathBox.Text);
            var appName = _appNameBox.Text.Trim();
            var extractionMode = GetSelectedExtractionMode();
            if (string.IsNullOrWhiteSpace(appName))
            {
                appName = Path.GetFileNameWithoutExtension(mprPath);
                _appNameBox.Text = appName;
            }

            string? mxPath = null;
            if (extractionMode == ExtractionMode.LegacyDumpParser)
            {
                var mxPathInput = _mxPathBox.Text.Trim();
                if (string.IsNullOrWhiteSpace(mxPathInput))
                {
                    AppendLog("mx.exe not provided. Attempting auto-detection...");
                    AutoDetectMx();
                    mxPathInput = _mxPathBox.Text.Trim();
                }

                mxPath = WizardRuntime.ValidateMxPath(mxPathInput);
            }
            else
            {
                var (foundMxCli, mxCliPath, mxCliVersion, mxCliError) = WizardRuntime.DetectMxCli();
                if (!foundMxCli)
                {
                    var detail = string.IsNullOrWhiteSpace(mxCliError)
                        ? "mxcli not found on PATH."
                        : mxCliError;
                    throw new InvalidOperationException(
                        $"MxCli mode requires mxcli on PATH. {detail} Install mxcli and verify 'mxcli --version'.");
                }

                AppendLog($"mxcli: {mxCliPath}");
                if (!string.IsNullOrWhiteSpace(mxCliVersion))
                {
                    AppendLog($"mxcli version: {mxCliVersion}");
                }
            }

            var dataRoot = WizardRuntime.NormalizeDataRootInput(_dataRootBox.Text);
            var kbRoot = Path.Combine(dataRoot, "knowledge-base");
            var creatorLinkPath = Path.Combine(kbRoot, "_sources", "creator-link.json");

            AppendLog("Starting pipeline...");
            AppendLog($"MPR: {mprPath}");
            AppendLog($"App: {appName}");
            AppendLog($"Extraction mode: {extractionMode}");
            if (extractionMode == ExtractionMode.LegacyDumpParser)
            {
                AppendLog($"mx.exe: {mxPath}");
            }
            AppendLog($"Data root: {dataRoot}");
            AppendLog($"Knowledge base root: {kbRoot}");

            _config = new WizardConfig
            {
                LastMprPath = mprPath,
                LastAppName = appName,
                LastInstallRoot = _installRootBox.Text.Trim(),
                LastMxExePath = extractionMode == ExtractionMode.LegacyDumpParser ? mxPath : _config.LastMxExePath,
                LastDataRoot = dataRoot,
                LastExtractionMode = extractionMode.ToString(),
                AutoEnrichAfterPipeline = _autoEnrichCheck.Checked,
                AiSettings = _config.AiSettings, // preserve AI settings across pipeline runs
            };
            WizardRuntime.SaveConfig(_configPath, _config);

            var exitCode = await WizardRuntime.RunPipelineAsync(
                packageRoot: _packageRoot,
                wizardRoot: _wizardRoot,
                mprPath: mprPath,
                appName: appName,
                mxPath: mxPath,
                dataRoot: dataRoot,
                extractionMode: extractionMode,
                log: AppendLog
            );

            if (exitCode != 0)
            {
                AppendLog($"Pipeline failed with exit code {exitCode}.");
                MessageBox.Show(this, $"Pipeline failed with exit code {exitCode}.", "Run failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            AppendLog("Pipeline completed successfully.");
            AppendLog($"Knowledge base: {kbRoot}");

            var runFolder = WizardRuntime.FindLatestRunFolder(dataRoot);
            if (!string.IsNullOrWhiteSpace(runFolder))
            {
                creatorLinkPath = WizardRuntime.WriteCreatorLink(
                    _packageRoot, kbRoot, dataRoot, appName, mprPath, runFolder, extractionMode);
                AppendLog($"Creator link written: {creatorLinkPath}");
            }
            else
            {
                AppendLog("WARNING: Could not find run folder — creator-link.json not written.");
            }

            AppendLog($"Mendix app folder: {Path.GetDirectoryName(mprPath)}");

            _enrichReady = true;
            _enrichButton.Enabled = true;
            _enrichModulesButton.Enabled = true;
            _updateAgentsButton.Enabled = true;

            if (_autoEnrichCheck.Checked)
            {
                AppendLog("Auto-enrich is enabled. Starting enrichment...");
                await RunEnrichmentAsync();
                return;
            }

            var appFolder = Path.GetDirectoryName(mprPath)!;
            MessageBox.Show(
                this,
                $"Knowledge base creation completed.{Environment.NewLine}{Environment.NewLine}Knowledge base:{Environment.NewLine}{kbRoot}{Environment.NewLine}{Environment.NewLine}Click \"Enrich KB\" to add AI narratives.{Environment.NewLine}{Environment.NewLine}Mendix app folder:{Environment.NewLine}{appFolder}",
                "Success",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Run failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            ToggleUi(true);
        }
    }

    private async Task RunEnrichmentAsync()
    {
        try
        {
            ToggleUi(false);
            AppendLog("");
            AppendLog("=== Starting AI enrichment ===");

            var dataRoot = WizardRuntime.NormalizeDataRootInput(_dataRootBox.Text);
            var kbRoot = Path.Combine(dataRoot, "knowledge-base");
            var creatorLinkPath = Path.Combine(kbRoot, "_sources", "creator-link.json");

            if (!File.Exists(creatorLinkPath))
            {
                AppendLog("ERROR: creator-link.json not found. Run the pipeline first.");
                MessageBox.Show(
                    this,
                    $"creator-link.json not found at:{Environment.NewLine}{creatorLinkPath}{Environment.NewLine}{Environment.NewLine}Run the pipeline first to generate the knowledge base.",
                    "Enrichment not available",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            var appName = _appNameBox.Text.Trim();
            var aiSettings = _config.AiSettings ?? new AiSettings();

            AppendLog($"Knowledge base: {kbRoot}");
            AppendLog($"App name: {appName}");
            AppendLog($"AI provider: {ProviderLabel(aiSettings.Provider)}");

            // Resolve the effective CLI path for the selected provider
            string? effectiveCliPath = null;
            switch (aiSettings.Provider)
            {
                case AiProvider.ClaudeCli:
                    var (claudeFound, detectedClaudePath) = WizardRuntime.DetectClaudeCli(aiSettings.ClaudeCliPath);
                    effectiveCliPath = detectedClaudePath;
                    if (claudeFound)
                        AppendLog($"Claude CLI: {detectedClaudePath}");
                    break;
                case AiProvider.CodexCli:
                    var (codexFound, detectedCodexPath) = WizardRuntime.DetectCodexCli(aiSettings.CodexCliPath);
                    effectiveCliPath = detectedCodexPath;
                    if (codexFound)
                        AppendLog($"Codex CLI: {detectedCodexPath}");
                    break;
                case AiProvider.ClaudeApi:
                    AppendLog($"Model: {aiSettings.ClaudeApiModel}");
                    break;
            }

            var exitCode = await WizardRuntime.RunEnrichmentAsync(
                packageRoot: _packageRoot,
                wizardRoot: _wizardRoot,
                kbRoot: kbRoot,
                appName: appName,
                claudePath: effectiveCliPath,
                aiSettings: aiSettings,
                log: AppendLog
            );

            if (exitCode == 2)
            {
                AppendLog("Claude CLI not found. Install it to use AI enrichment.");
                MessageBox.Show(
                    this,
                    $"Claude CLI not found.{Environment.NewLine}{Environment.NewLine}Install with:{Environment.NewLine}npm install -g @anthropic-ai/claude-code{Environment.NewLine}{Environment.NewLine}Then authenticate with:{Environment.NewLine}claude login",
                    "Claude CLI required",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            if (exitCode == 3)
            {
                AppendLog("Claude CLI authentication failed.");
                MessageBox.Show(
                    this,
                    $"Claude CLI authentication failed.{Environment.NewLine}{Environment.NewLine}Run the following command to authenticate:{Environment.NewLine}claude login",
                    "Authentication required",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            if (exitCode != 0)
            {
                AppendLog($"Enrichment failed with exit code {exitCode}.");
                MessageBox.Show(this, $"Enrichment failed with exit code {exitCode}.", "Enrichment failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            AppendLog("Enrichment completed successfully.");
            MessageBox.Show(
                this,
                $"AI enrichment completed.{Environment.NewLine}{Environment.NewLine}Knowledge base:{Environment.NewLine}{kbRoot}{Environment.NewLine}{Environment.NewLine}Review the enriched files and check the log for validation results.",
                "Enrichment complete",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Enrichment failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            ToggleUi(true);
        }
    }

    private async Task RunEnrichModulesAsync()
    {
        try
        {
            var dataRoot = WizardRuntime.NormalizeDataRootInput(_dataRootBox.Text);
            var kbRoot = Path.Combine(dataRoot, "knowledge-base");

            AppendLog($"Loading modules from KB: {kbRoot}");
            var modules = WizardRuntime.LoadModuleList(kbRoot);
            AppendLog($"Found {modules.Count} module(s)");

            if (modules.Count == 0)
            {
                MessageBox.Show(
                    this,
                    $"No modules found.{Environment.NewLine}{Environment.NewLine}Checked KB root: {kbRoot}{Environment.NewLine}{Environment.NewLine}Ensure the pipeline has been run and all-modules.json exists in the source run folder referenced by creator-link.json.",
                    "No modules",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            using var picker = new ModulePickerForm(modules);
            if (picker.ShowDialog(this) != DialogResult.OK || picker.SelectedModules.Length == 0)
                return;

            ToggleUi(false);
            AppendLog("");
            AppendLog($"=== Starting AI enrichment for {picker.SelectedModules.Length} selected module(s) ===");
            foreach (var m in picker.SelectedModules)
                AppendLog($"  - {m}");

            var creatorLinkPath = Path.Combine(kbRoot, "_sources", "creator-link.json");
            if (!File.Exists(creatorLinkPath))
            {
                AppendLog("ERROR: creator-link.json not found. Run the pipeline first.");
                return;
            }

            var appName = _appNameBox.Text.Trim();
            var aiSettings = _config.AiSettings ?? new AiSettings();

            AppendLog($"AI provider: {ProviderLabel(aiSettings.Provider)}");

            string? effectiveCliPath = null;
            switch (aiSettings.Provider)
            {
                case AiProvider.ClaudeCli:
                    var (claudeFound, detectedClaudePath) = WizardRuntime.DetectClaudeCli(aiSettings.ClaudeCliPath);
                    effectiveCliPath = detectedClaudePath;
                    if (claudeFound) AppendLog($"Claude CLI: {detectedClaudePath}");
                    break;
                case AiProvider.CodexCli:
                    var (codexFound, detectedCodexPath) = WizardRuntime.DetectCodexCli(aiSettings.CodexCliPath);
                    effectiveCliPath = detectedCodexPath;
                    if (codexFound) AppendLog($"Codex CLI: {detectedCodexPath}");
                    break;
                case AiProvider.ClaudeApi:
                    AppendLog($"Model: {aiSettings.ClaudeApiModel}");
                    break;
            }

            var exitCode = await WizardRuntime.RunEnrichmentAsync(
                packageRoot: _packageRoot,
                wizardRoot: _wizardRoot,
                kbRoot: kbRoot,
                appName: appName,
                claudePath: effectiveCliPath,
                aiSettings: aiSettings,
                enrichModules: picker.SelectedModules,
                log: AppendLog
            );

            if (exitCode == 2)
            {
                AppendLog("Claude CLI not found.");
                return;
            }

            if (exitCode != 0)
            {
                AppendLog($"Enrichment failed with exit code {exitCode}.");
                MessageBox.Show(this, $"Enrichment failed with exit code {exitCode}.", "Enrichment failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            AppendLog("Module enrichment completed successfully.");
            MessageBox.Show(
                this,
                $"AI enrichment completed for {picker.SelectedModules.Length} module(s).{Environment.NewLine}{Environment.NewLine}Knowledge base:{Environment.NewLine}{kbRoot}",
                "Enrichment complete",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Enrichment failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            ToggleUi(true);
        }
    }

    private async Task RunUpdateAgentsAsync()
    {
        try
        {
            ToggleUi(false);
            AppendLog("");
            AppendLog("=== Updating KB agents ===");

            var dataRoot = WizardRuntime.NormalizeDataRootInput(_dataRootBox.Text);
            var kbRoot = Path.Combine(dataRoot, "knowledge-base");

            if (!Directory.Exists(kbRoot))
            {
                AppendLog("ERROR: Knowledge base not found. Run the pipeline first.");
                MessageBox.Show(this, "Knowledge base folder not found. Run the pipeline first.",
                    "Not found", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var exitCode = await WizardRuntime.UpdateKbAgentsAsync(
                packageRoot: _packageRoot,
                kbRoot: kbRoot,
                log: AppendLog
            );

            if (exitCode != 0)
            {
                AppendLog("Agents update failed.");
                MessageBox.Show(this, "Failed to update agents. Check the log for details.",
                    "Update failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            AppendLog("Agents updated successfully.");
            MessageBox.Show(
                this,
                $"KB agents folder updated from package artifacts.{Environment.NewLine}{Environment.NewLine}Destination:{Environment.NewLine}{Path.Combine(kbRoot, ".agents")}",
                "Agents updated",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Update failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            ToggleUi(true);
        }
    }

    private async Task RunAddCopilotAsync()
    {
        try
        {
            var mprPath = _mprPathBox.Text.Trim();
            if (!File.Exists(mprPath))
            {
                MessageBox.Show(this, "Select a valid .mpr file first.", "No app selected",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var appFolder = Path.GetDirectoryName(mprPath)!;
            var copilotDest = Path.Combine(appFolder, "extensions", "kb-copilot");

            if (Directory.Exists(copilotDest))
            {
                var answer = MessageBox.Show(
                    this,
                    $"CoPilot already exists at:{Environment.NewLine}{copilotDest}{Environment.NewLine}{Environment.NewLine}Replace it?",
                    "CoPilot exists",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question
                );
                if (answer != DialogResult.Yes) return;
            }

            ToggleUi(false);
            _logBox.Clear();
            AppendLog("=== Adding CoPilot extension ===");
            AppendLog($"App folder: {appFolder}");

            var exitCode = await WizardRuntime.AddCopilotAsync(
                packageRoot: _packageRoot,
                appFolder: appFolder,
                log: AppendLog
            );

            if (exitCode != 0)
            {
                AppendLog($"Add CoPilot failed with exit code {exitCode}.");
                MessageBox.Show(this, $"Failed to add CoPilot. Check the log for details.",
                    "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            AppendLog($"CoPilot extension installed at: {copilotDest}");
            AppendLog("Use \"Open App\" to launch Studio Pro with extension support.");

            MessageBox.Show(
                this,
                $"CoPilot extension added.{Environment.NewLine}{Environment.NewLine}" +
                $"Location:{Environment.NewLine}{copilotDest}{Environment.NewLine}{Environment.NewLine}" +
                $"Use \"Open App\" to launch Studio Pro with --enable-extension-development.",
                "CoPilot added",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information
            );
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
        finally
        {
            ToggleUi(true);
        }
    }

    private void RunOpenApp()
    {
        try
        {
            var mprPath = _mprPathBox.Text.Trim();
            if (!File.Exists(mprPath))
            {
                MessageBox.Show(this, "Select a valid .mpr file first.", "No app selected",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var mxPath = _mxPathBox.Text.Trim();
            var installRoot = _installRootBox.Text.Trim();
            var studioProExe = WizardRuntime.FindStudioProExe(
                string.IsNullOrWhiteSpace(mxPath) ? null : mxPath,
                string.IsNullOrWhiteSpace(installRoot) ? null : installRoot
            );

            if (string.IsNullOrWhiteSpace(studioProExe))
            {
                MessageBox.Show(
                    this,
                    $"Could not find studiopro.exe.{Environment.NewLine}{Environment.NewLine}" +
                    "Ensure the Mendix install root or mx.exe path is set correctly.",
                    "Studio Pro not found",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning
                );
                return;
            }

            AppendLog($"Opening Studio Pro: {studioProExe}");
            AppendLog($"App: {mprPath}");
            AppendLog("Flags: --enable-extension-development");

            WizardRuntime.OpenMendixApp(studioProExe, mprPath);

            AppendLog("Studio Pro launched.");
        }
        catch (Exception ex)
        {
            AppendLog($"ERROR: {ex.Message}");
            MessageBox.Show(this, ex.Message, "Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
    }

    private bool _enrichReady;

    private void ToggleUi(bool enabled)
    {
        _runButton.Enabled = enabled;
        _autoEnrichCheck.Enabled = enabled;
        _extractionModeBox.Enabled = enabled;
        _enrichButton.Enabled = enabled && _enrichReady;
        _enrichModulesButton.Enabled = enabled && _enrichReady;
        _updateAgentsButton.Enabled = enabled && _enrichReady;
        _addCopilotButton.Enabled = enabled;
        _openAppButton.Enabled = enabled;
        if (enabled)
        {
            ApplyExtractionModeUiState();
        }
        else
        {
            _installRootBox.Enabled = false;
            _mxPathBox.Enabled = false;
            _browseInstallButton.Enabled = false;
            _browseMxButton.Enabled = false;
            _autoDetectMxButton.Enabled = false;
        }
        Cursor = enabled ? Cursors.Default : Cursors.WaitCursor;
    }

    private void AppendLog(string message)
    {
        if (InvokeRequired)
        {
            BeginInvoke(new Action<string>(AppendLog), message);
            return;
        }

        _logBox.AppendText(message + Environment.NewLine);
    }
}
