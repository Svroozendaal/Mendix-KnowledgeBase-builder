namespace KnowledgeBaseCreator.Wizard;

internal sealed class ModulePickerForm : Form
{
    private readonly CheckedListBox _moduleList = new()
    {
        Dock = DockStyle.Fill,
        CheckOnClick = true,
        IntegralHeight = false,
    };

    private readonly Button _selectAllCustom = new() { Text = "All Custom", AutoSize = true };
    private readonly Button _selectAll = new() { Text = "All", AutoSize = true };
    private readonly Button _selectNone = new() { Text = "None", AutoSize = true };
    private readonly Button _okButton = new() { Text = "Enrich Selected", AutoSize = true, DialogResult = DialogResult.OK };
    private readonly Button _cancelButton = new() { Text = "Cancel", AutoSize = true, DialogResult = DialogResult.Cancel };
    private readonly Label _statusLabel = new() { AutoSize = true, Dock = DockStyle.Bottom, Padding = new Padding(4) };

    private readonly List<ModuleInfo> _modules;

    public string[] SelectedModules { get; private set; } = [];

    public ModulePickerForm(List<ModuleInfo> modules)
    {
        _modules = modules;

        Text = "Select Modules to Enrich";
        Width = 520;
        Height = 480;
        StartPosition = FormStartPosition.CenterParent;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox = false;
        MinimizeBox = false;
        AcceptButton = _okButton;
        CancelButton = _cancelButton;

        BuildLayout();
        PopulateModules();
        UpdateStatus();
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
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));   // quick-select buttons
        root.RowStyles.Add(new RowStyle(SizeType.Percent, 100f)); // module list
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));   // status
        root.RowStyles.Add(new RowStyle(SizeType.AutoSize));   // OK/Cancel

        // Quick-select buttons
        var quickFlow = new FlowLayoutPanel { Dock = DockStyle.Top, AutoSize = true, Padding = new Padding(0, 0, 0, 4) };
        quickFlow.Controls.AddRange([_selectAllCustom, _selectAll, _selectNone]);
        root.Controls.Add(quickFlow, 0, 0);

        // Module list
        var listGroup = new GroupBox
        {
            Text = "Modules (category shown in brackets)",
            Dock = DockStyle.Fill,
            Padding = new Padding(6),
        };
        listGroup.Controls.Add(_moduleList);
        root.Controls.Add(listGroup, 0, 1);

        // Status
        root.Controls.Add(_statusLabel, 0, 2);

        // Buttons
        var buttonFlow = new FlowLayoutPanel
        {
            Dock = DockStyle.Bottom,
            AutoSize = true,
            FlowDirection = FlowDirection.RightToLeft,
        };
        buttonFlow.Controls.AddRange([_cancelButton, _okButton]);
        root.Controls.Add(buttonFlow, 0, 3);

        Controls.Add(root);

        // Wire events
        _selectAllCustom.Click += (_, _) => SelectByCategory("Custom");
        _selectAll.Click += (_, _) => SetAll(true);
        _selectNone.Click += (_, _) => SetAll(false);
        _okButton.Click += (_, _) => OnOk();
        // ItemCheck is wired after PopulateModules to avoid BeginInvoke before handle exists
    }

    private void PopulateModules()
    {
        // Sort: Custom first, then Marketplace, then System. Within each group, alphabetical.
        var sorted = _modules
            .OrderBy(m => m.Category switch
            {
                "Custom" => 0,
                "Marketplace" => 1,
                "System" => 2,
                _ => 3,
            })
            .ThenBy(m => m.Name, StringComparer.OrdinalIgnoreCase)
            .ToList();

        foreach (var module in sorted)
        {
            var label = $"{module.Name}  [{module.Category}]  ({module.EntityCount}E / {module.FlowCount}F / {module.PageCount}P)";
            var isCustom = string.Equals(module.Category, "Custom", StringComparison.OrdinalIgnoreCase);
            _moduleList.Items.Add(new ModuleListItem(module, label), isChecked: isCustom);
        }

        // Wire ItemCheck after population so BeginInvoke is not called before handle exists
        _moduleList.ItemCheck += (_, _) =>
        {
            if (IsHandleCreated)
                BeginInvoke(new Action(UpdateStatus));
        };
    }

    private void SelectByCategory(string category)
    {
        for (int i = 0; i < _moduleList.Items.Count; i++)
        {
            if (_moduleList.Items[i] is ModuleListItem item)
            {
                _moduleList.SetItemChecked(i,
                    string.Equals(item.Module.Category, category, StringComparison.OrdinalIgnoreCase));
            }
        }
        UpdateStatus();
    }

    private void SetAll(bool isChecked)
    {
        for (int i = 0; i < _moduleList.Items.Count; i++)
        {
            _moduleList.SetItemChecked(i, isChecked);
        }
        UpdateStatus();
    }

    private void UpdateStatus()
    {
        var count = _moduleList.CheckedItems.Count;
        var total = _moduleList.Items.Count;
        _statusLabel.Text = $"{count} of {total} modules selected";
        _okButton.Enabled = count > 0;
    }

    private void OnOk()
    {
        SelectedModules = _moduleList.CheckedItems
            .Cast<ModuleListItem>()
            .Select(item => item.Module.Name)
            .ToArray();
    }

    private sealed class ModuleListItem
    {
        public ModuleInfo Module { get; }
        private readonly string _display;

        public ModuleListItem(ModuleInfo module, string display)
        {
            Module = module;
            _display = display;
        }

        public override string ToString() => _display;
    }
}
