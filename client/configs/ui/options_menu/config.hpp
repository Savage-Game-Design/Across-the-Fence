class para_Option {
    name = "Option Name"; // Display Name
    variable = "my_option_name"; // Variable name for saving in PFS
    tooltip = ""; // Tooltip
};

class para_OptionCheckbox: para_Option {
    type = "Checkbox";
    default = 0;
};

class para_OptionSlider: para_Option {
    type = "Slider";
    default = 50;
    range[] =  { 0, 100 };
    step = 10;
};

class para_OptionCombobox: para_Option {
    type = "Combobox";
    default = 0;
    values[] = {
        "Value Name",
        "Value Name 2"
    };
};

class para_CfgOptions {
    class para_enableWelcomeScreen {
        name = "Enable welcome screen";
        tooltip = "Enables the welcome screen on mission start";
        type = "Checkbox";
        default = 0;
    };
    class para_enableTutorial {
        name = "Enable gamemode tutorials";
        tooltip = "Enables tutorial card popups with gameplay hints.";
        type = "Checkbox";
        default = 1;
    };
    class para_enableDynamicViewDist {
        name = "Enable dynamic view distance settings";
        tooltip = "Enables all dynamic view distance settings, only disable it if you are using your own view distance mods";
        onChange = "para_c_perf_enable_dynamic_view_distance = _newValue";
        type = "Checkbox";
        default = 1;
    };
    class para_minViewDist {
		name = "Min. view distance"; // Display Name
		tooltip = "Minimum distance that the view distance will be reduced to"; // Tooltip
        onChange = "para_c_perf_min_view_distance = _newValue";
		type = "Slider";
		default = 800;
		range[] =  { 800, 12000 };
		step = 100;
	};
    class para_minObjectViewDist {
		name = "Min. object view distance";
		tooltip = "Minimum distance that object rendering will be reduced to";
        onChange = "para_c_perf_min_object_view_distance = _newValue";
		type = "Slider";
		default = 800;
		range[] =  { 800, 12000 };
		step = 100;
	};
    class para_maxViewDist {
		name = "Max. view distance"; // Display Name
		tooltip = "Maximum distance that the view distance will be increased to"; // Tooltip
        onChange = "para_c_perf_max_view_distance = _newValue";
		type = "Slider";
		default = 2000;
		range[] =  { 800, 12000 };
		step = 100;
	};
    class para_maxObjectViewDist {
		name = "Max. object view distance";
		tooltip = "Maximum distance that object rendering will be increased to";
        onChange = "para_c_perf_max_object_view_distance = _newValue";
		type = "Slider";
		default = 2000;
		range[] =  { 800, 12000 };
		step = 100;
	};
    class para_minFpsViewDist {
        name = "Min. desired FPS";
		tooltip = "Lower FPS than this will cause view distance to start decreasing";
        onChange = "para_c_perf_min_fps_to_reduce_view_distance = _newValue";
		type = "Slider";
		default = 20;
		range[] =  { 0, 120 };
		step = 10;
	};
    class para_disableDynViewDistWhenFlying {
        name = "Disable dynamic view distance when flying";
		tooltip = "Forces the view distance to the max allowed when flying";
        onChange = "para_c_perf_disable_dynamic_view_distance_when_flying = _newValue";
		type = "Checkbox";
		default = 0;
	};
//     class Test: para_OptionCheckbox {
//         name = "Test option 1";
//         tooltip = "This is the test option 1";
//         variable = "para_test1";
//     };
//     class Test2: para_OptionSlider {
//         name = "Test option 2";
//         tooltip = "This is the test option 2";
//         variable = "para_test2";
//     };
//     class Test3: para_OptionCombobox {
//         name = "Test option 3";
//         tooltip = "This is the test option 3";
//         variable = "para_test3";
//     };
};