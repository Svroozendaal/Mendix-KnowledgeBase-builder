namespace KnowledgeBaseCreator.Wizard;

internal sealed class WizardForm : Form
{
    private readonly TextBox _mprPathBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _appNameBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _installRootBox = new() { Dock = DockStyle.Fill };
    private readonly TextBox _mxPathBox = new() { Dock = DockStyle.Fill };
    private readonly Label _dataRootLabel = new() { AutoSize = true };
    private readonly TextBox _appFolderBox = new() { Dock = DockStyle.Fill, ReadOnly = true };
    private readonly Button _runButton = new() { Text = "Run Pipeline", AutoSize = true };
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
            RowCount = 8,
            AutoSize = true,
            Padding = new Padding(12),
        };
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 190));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 110));
        settings.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 110));

        var browseMprButton = new Button { Text = "Browse...", AutoSize = true };
        browseMprButton.Click += (_, _) => BrowseMpr();
        var browseInstallButton = new Button { Text = "Browse...", AutoSize = true };
        browseInstallButton.Click += (_, _) => BrowseInstallRoot();
        var browseMxButton = new Button { Text = "Browse...", AutoSize = true };
        browseMxButton.Click += (_, _) => BrowseMx();
        var autoDetectMxButton = new Button { Text = "Auto detect", AutoSize = true };
        autoDetectMxButton.Click += (_, _) => AutoDetectMx();

        _mprPathBox.TextChanged += (_, _) => OnMprPathChanged();

        AddRow(settings, 0, "MPR file", _mprPathBox, browseMprButton, EmptyControl());
        AddRow(settings, 1, "App name", _appNameBox, EmptyControl(), EmptyControl());
        AddRow(settings, 2, "Mendix install root", _installRootBox, browseInstallButton, EmptyControl());
        AddRow(settings, 3, "mx.exe", _mxPathBox, autoDetectMxButton, browseMxButton);
        AddRow(settings, 4, "Output data root", _dataRootLabel, EmptyControl(), EmptyControl());
        AddRow(settings, 5, "Mendix app folder", _appFolderBox, EmptyControl(), EmptyControl());
        AddRow(settings, 6, string.Empty, _runButton, EmptyControl(), EmptyControl());

        _runButton.Click += async (_, _) => await RunPipelineAsync();
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
        _mprPathBox.Text = _config.LastMprPath ?? string.Empty;
        _appNameBox.Text = _config.LastAppName ?? string.Empty;
        _installRootBox.Text = WizardRuntime.ResolveInstallRootDefault(_config);
        _mxPathBox.Text = _config.LastMxExePath ?? string.Empty;
        RefreshDataRoot();
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
            _dataRootLabel.Text = Path.Combine(Path.GetDirectoryName(mprPath)!, "mendix-data");
            _appFolderBox.Text = Path.GetDirectoryName(mprPath)!;
        }
        else
        {
            _dataRootLabel.Text = "<select a valid .mpr file>";
            _appFolderBox.Text = "<select a valid .mpr file>";
        }
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

    private void AutoDetectMx()
    {
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

    private async Task RunPipelineAsync()
    {
        try
        {
            ToggleUi(false);
            _logBox.Clear();

            var mprPath = WizardRuntime.ValidateMprPath(_mprPathBox.Text);
            var appName = _appNameBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(appName))
            {
                appName = Path.GetFileNameWithoutExtension(mprPath);
                _appNameBox.Text = appName;
            }

            var mxPathInput = _mxPathBox.Text.Trim();
            if (string.IsNullOrWhiteSpace(mxPathInput))
            {
                AppendLog("mx.exe not provided. Attempting auto-detection...");
                AutoDetectMx();
                mxPathInput = _mxPathBox.Text.Trim();
            }

            var mxPath = WizardRuntime.ValidateMxPath(mxPathInput);
            var dataRoot = Path.Combine(Path.GetDirectoryName(mprPath)!, "mendix-data");
            var kbRoot = Path.Combine(dataRoot, "knowledge-base");

            AppendLog("Starting full pipeline...");
            AppendLog($"MPR: {mprPath}");
            AppendLog($"App: {appName}");
            AppendLog($"mx.exe: {mxPath}");
            AppendLog($"Data root: {dataRoot}");

            _config = new WizardConfig
            {
                LastMprPath = mprPath,
                LastAppName = appName,
                LastInstallRoot = _installRootBox.Text.Trim(),
                LastMxExePath = mxPath,
                LastOpenVsCode = _config.LastOpenVsCode,
            };
            WizardRuntime.SaveConfig(_configPath, _config);

            var exitCode = await WizardRuntime.RunPipelineAsync(
                packageRoot: _packageRoot,
                wizardRoot: _wizardRoot,
                mprPath: mprPath,
                appName: appName,
                mxPath: mxPath,
                dataRoot: dataRoot,
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
            AppendLog($"Mendix app folder: {Path.GetDirectoryName(mprPath)}");

            var appFolder = Path.GetDirectoryName(mprPath)!;
            MessageBox.Show(
                this,
                $"Knowledge base creation completed.{Environment.NewLine}{Environment.NewLine}Mendix app folder:{Environment.NewLine}{appFolder}",
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

    private void ToggleUi(bool enabled)
    {
        _runButton.Enabled = enabled;
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
