namespace KnowledgeBaseCreator.Wizard;

internal sealed class SettingsForm : Form
{
    private readonly RadioButton _radioClaudeCli = new() { Text = "Claude CLI", AutoSize = true, Checked = true };
    private readonly RadioButton _radioCodexCli = new() { Text = "Codex CLI (OpenAI)", AutoSize = true };
    private readonly RadioButton _radioClaudeApi = new() { Text = "Claude API", AutoSize = true };

    // Claude CLI panel
    private readonly TextBox _claudeCliPathBox = new() { Dock = DockStyle.Fill };
    private readonly Label _claudeCliStatus = new() { AutoSize = true, ForeColor = Color.Gray, Text = "Not checked" };

    // Codex CLI panel
    private readonly TextBox _codexCliPathBox = new() { Dock = DockStyle.Fill };
    private readonly Label _codexCliStatus = new() { AutoSize = true, ForeColor = Color.Gray, Text = "Not checked" };

    // Claude API panel
    private readonly TextBox _apiKeyBox = new() { Dock = DockStyle.Fill, UseSystemPasswordChar = true };
    private readonly ComboBox _apiModelBox = new()
    {
        Dock = DockStyle.Fill,
        DropDownStyle = ComboBoxStyle.DropDown,
        Items = { "claude-sonnet-4-20250514", "claude-haiku-4-5-20251001", "claude-opus-4-6" },
    };
    private readonly CheckBox _showApiKey = new() { Text = "Show", AutoSize = true };

    // Provider panels (toggled by radio selection)
    private readonly Panel _claudeCliPanel = new() { Dock = DockStyle.Top, AutoSize = true };
    private readonly Panel _codexCliPanel = new() { Dock = DockStyle.Top, AutoSize = true, Visible = false };
    private readonly Panel _claudeApiPanel = new() { Dock = DockStyle.Top, AutoSize = true, Visible = false };

    private readonly Button _saveButton = new() { Text = "Save", AutoSize = true, DialogResult = DialogResult.OK };
    private readonly Button _cancelButton = new() { Text = "Cancel", AutoSize = true, DialogResult = DialogResult.Cancel };

    public AiSettings Result { get; private set; } = new();

    public SettingsForm(AiSettings? current)
    {
        Text = "AI Enrichment Settings";
        Width = 620;
        Height = 440;
        StartPosition = FormStartPosition.CenterParent;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox = false;
        MinimizeBox = false;
        AcceptButton = _saveButton;
        CancelButton = _cancelButton;

        BuildLayout();
        LoadCurrent(current);
        WireEvents();
    }

    private void BuildLayout()
    {
        var root = new TableLayoutPanel
        {
            Dock = DockStyle.Fill,
            ColumnCount = 1,
            RowCount = 4,
            Padding = new Padding(12),
        };
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize)); // provider radios
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100f)); // settings panels
        root.RowStyles.Add(new RowStyle(SizeType.Absolute, 8)); // spacer
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize)); // buttons

        // --- Provider selection ---
        var providerGroup = new GroupBox { Text = "AI Provider", Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(8) };
        var providerFlow = new FlowLayoutPanel { Dock = DockStyle.Fill, AutoSize = true, WrapContents = false };
        providerFlow.Controls.AddRange([_radioClaudeCli, _radioCodexCli, _radioClaudeApi]);
        providerGroup.Controls.Add(providerFlow);
        root.Controls.Add(providerGroup, 0, 0);

        // --- Provider-specific panels ---
        var settingsContainer = new Panel { Dock = DockStyle.Fill };
        BuildClaudeCliPanel();
        BuildCodexCliPanel();
        BuildClaudeApiPanel();
        settingsContainer.Controls.AddRange([_claudeApiPanel, _codexCliPanel, _claudeCliPanel]); // reverse order for Top dock
        root.Controls.Add(settingsContainer, 0, 1);

        // --- Buttons ---
        var buttonFlow = new FlowLayoutPanel
        {
            Dock = DockStyle.Bottom,
            AutoSize = true,
            FlowDirection = FlowDirection.RightToLeft,
        };
        buttonFlow.Controls.AddRange([_cancelButton, _saveButton]);
        root.Controls.Add(buttonFlow, 0, 3);

        Controls.Add(root);
    }

    private void BuildClaudeCliPanel()
    {
        var grid = new TableLayoutPanel
        {
            Dock = DockStyle.Top,
            ColumnCount = 3,
            RowCount = 2,
            AutoSize = true,
            Padding = new Padding(4),
        };
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 100));

        var browseBtn = new Button { Text = "Browse...", AutoSize = true };
        browseBtn.Click += (_, _) => BrowseCliPath(_claudeCliPathBox, "claude");
        var detectBtn = new Button { Text = "Auto detect", AutoSize = true };
        detectBtn.Click += (_, _) => AutoDetectClaude();

        grid.Controls.Add(new Label { Text = "claude path", AutoSize = true, Anchor = AnchorStyles.Left }, 0, 0);
        grid.Controls.Add(_claudeCliPathBox, 1, 0);
        grid.Controls.Add(browseBtn, 2, 0);
        grid.Controls.Add(_claudeCliStatus, 1, 1);
        grid.Controls.Add(detectBtn, 2, 1);

        var group = new GroupBox { Text = "Claude CLI Settings", Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(6) };
        group.Controls.Add(grid);
        _claudeCliPanel.Controls.Add(group);
    }

    private void BuildCodexCliPanel()
    {
        var grid = new TableLayoutPanel
        {
            Dock = DockStyle.Top,
            ColumnCount = 3,
            RowCount = 2,
            AutoSize = true,
            Padding = new Padding(4),
        };
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 100));

        var browseBtn = new Button { Text = "Browse...", AutoSize = true };
        browseBtn.Click += (_, _) => BrowseCliPath(_codexCliPathBox, "codex");
        var detectBtn = new Button { Text = "Auto detect", AutoSize = true };
        detectBtn.Click += (_, _) => AutoDetectCodex();

        grid.Controls.Add(new Label { Text = "codex path", AutoSize = true, Anchor = AnchorStyles.Left }, 0, 0);
        grid.Controls.Add(_codexCliPathBox, 1, 0);
        grid.Controls.Add(browseBtn, 2, 0);
        grid.Controls.Add(_codexCliStatus, 1, 1);
        grid.Controls.Add(detectBtn, 2, 1);

        var group = new GroupBox { Text = "Codex CLI Settings", Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(6) };
        group.Controls.Add(grid);
        _codexCliPanel.Controls.Add(group);
    }

    private void BuildClaudeApiPanel()
    {
        var grid = new TableLayoutPanel
        {
            Dock = DockStyle.Top,
            ColumnCount = 3,
            RowCount = 2,
            AutoSize = true,
            Padding = new Padding(4),
        };
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 120));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100f));
        grid.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 100));

        _showApiKey.CheckedChanged += (_, _) => _apiKeyBox.UseSystemPasswordChar = !_showApiKey.Checked;

        grid.Controls.Add(new Label { Text = "API Key", AutoSize = true, Anchor = AnchorStyles.Left }, 0, 0);
        grid.Controls.Add(_apiKeyBox, 1, 0);
        grid.Controls.Add(_showApiKey, 2, 0);
        grid.Controls.Add(new Label { Text = "Model", AutoSize = true, Anchor = AnchorStyles.Left }, 0, 1);
        grid.Controls.Add(_apiModelBox, 1, 1);

        var group = new GroupBox { Text = "Claude API Settings", Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(6) };
        group.Controls.Add(grid);
        _claudeApiPanel.Controls.Add(group);
    }

    private void LoadCurrent(AiSettings? settings)
    {
        if (settings is null) return;

        switch (settings.Provider)
        {
            case AiProvider.ClaudeCli:
                _radioClaudeCli.Checked = true;
                break;
            case AiProvider.CodexCli:
                _radioCodexCli.Checked = true;
                break;
            case AiProvider.ClaudeApi:
                _radioClaudeApi.Checked = true;
                break;
        }

        _claudeCliPathBox.Text = settings.ClaudeCliPath ?? string.Empty;
        _codexCliPathBox.Text = settings.CodexCliPath ?? string.Empty;
        _apiKeyBox.Text = settings.ClaudeApiKey ?? string.Empty;
        _apiModelBox.Text = settings.ClaudeApiModel ?? "claude-sonnet-4-20250514";

        UpdatePanelVisibility();
        UpdateStatusLabels();
    }

    private void WireEvents()
    {
        _radioClaudeCli.CheckedChanged += (_, _) => UpdatePanelVisibility();
        _radioCodexCli.CheckedChanged += (_, _) => UpdatePanelVisibility();
        _radioClaudeApi.CheckedChanged += (_, _) => UpdatePanelVisibility();

        _claudeCliPathBox.TextChanged += (_, _) => UpdateStatusLabels();
        _codexCliPathBox.TextChanged += (_, _) => UpdateStatusLabels();

        _saveButton.Click += (_, _) => OnSave();
    }

    private void UpdatePanelVisibility()
    {
        _claudeCliPanel.Visible = _radioClaudeCli.Checked;
        _codexCliPanel.Visible = _radioCodexCli.Checked;
        _claudeApiPanel.Visible = _radioClaudeApi.Checked;
    }

    private void UpdateStatusLabels()
    {
        // Claude CLI
        var claudePath = _claudeCliPathBox.Text.Trim();
        if (string.IsNullOrWhiteSpace(claudePath))
        {
            var (found, detected) = WizardRuntime.DetectClaudeCli();
            if (found)
            {
                _claudeCliStatus.Text = $"Auto-detected: {detected}";
                _claudeCliStatus.ForeColor = Color.Green;
            }
            else
            {
                _claudeCliStatus.Text = "Not found. Install: npm install -g @anthropic-ai/claude-code";
                _claudeCliStatus.ForeColor = Color.OrangeRed;
            }
        }
        else if (File.Exists(claudePath))
        {
            _claudeCliStatus.Text = "Found";
            _claudeCliStatus.ForeColor = Color.Green;
        }
        else
        {
            _claudeCliStatus.Text = "File not found";
            _claudeCliStatus.ForeColor = Color.Red;
        }

        // Codex CLI
        var codexPath = _codexCliPathBox.Text.Trim();
        if (string.IsNullOrWhiteSpace(codexPath))
        {
            var (found, detected) = WizardRuntime.DetectCodexCli();
            if (found)
            {
                _codexCliStatus.Text = $"Auto-detected: {detected}";
                _codexCliStatus.ForeColor = Color.Green;
            }
            else
            {
                _codexCliStatus.Text = "Not found. Install: npm install -g @openai/codex";
                _codexCliStatus.ForeColor = Color.OrangeRed;
            }
        }
        else if (File.Exists(codexPath))
        {
            _codexCliStatus.Text = "Found";
            _codexCliStatus.ForeColor = Color.Green;
        }
        else
        {
            _codexCliStatus.Text = "File not found";
            _codexCliStatus.ForeColor = Color.Red;
        }
    }

    private void AutoDetectClaude()
    {
        var (found, path) = WizardRuntime.DetectClaudeCli();
        if (found && !string.IsNullOrWhiteSpace(path))
        {
            _claudeCliPathBox.Text = path;
        }
        else
        {
            MessageBox.Show(this, "Claude CLI not found.\n\nInstall with:\nnpm install -g @anthropic-ai/claude-code\n\nThen authenticate:\nclaude login",
                "Not found", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
    }

    private void AutoDetectCodex()
    {
        var (found, path) = WizardRuntime.DetectCodexCli();
        if (found && !string.IsNullOrWhiteSpace(path))
        {
            _codexCliPathBox.Text = path;
        }
        else
        {
            MessageBox.Show(this, "Codex CLI not found.\n\nInstall with:\nnpm install -g @openai/codex",
                "Not found", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
    }

    private void BrowseCliPath(TextBox target, string cliName)
    {
        using var dialog = new OpenFileDialog
        {
            Filter = $"{cliName} CLI|{cliName}*.*|Executable files (*.exe;*.cmd)|*.exe;*.cmd|All files (*.*)|*.*",
            CheckFileExists = true,
            Title = $"Select {cliName} CLI executable",
        };
        if (dialog.ShowDialog(this) == DialogResult.OK)
        {
            target.Text = dialog.FileName;
        }
    }

    private void OnSave()
    {
        var provider = _radioClaudeCli.Checked ? AiProvider.ClaudeCli
            : _radioCodexCli.Checked ? AiProvider.CodexCli
            : AiProvider.ClaudeApi;

        // Validate the selected provider has what it needs
        if (provider == AiProvider.ClaudeApi)
        {
            var key = _apiKeyBox.Text.Trim();
            if (!WizardRuntime.ValidateClaudeApiKey(key))
            {
                MessageBox.Show(this, "Please enter a valid Anthropic API key (starts with sk-ant-).",
                    "Invalid API Key", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                DialogResult = DialogResult.None;
                return;
            }
        }

        Result = new AiSettings
        {
            Provider = provider,
            ClaudeCliPath = NullIfEmpty(_claudeCliPathBox.Text),
            CodexCliPath = NullIfEmpty(_codexCliPathBox.Text),
            ClaudeApiKey = NullIfEmpty(_apiKeyBox.Text),
            ClaudeApiModel = string.IsNullOrWhiteSpace(_apiModelBox.Text)
                ? "claude-sonnet-4-20250514"
                : _apiModelBox.Text.Trim(),
        };
    }

    private static string? NullIfEmpty(string? s)
        => string.IsNullOrWhiteSpace(s) ? null : s.Trim();
}
