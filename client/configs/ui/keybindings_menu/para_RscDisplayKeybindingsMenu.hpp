class para_RscDisplayKeybindingsMenu
{
	idd = PARA_KEYBINDINGSMENU_IDD;
	// PARA_INIT_DISPLAY(para_RscDisplayKeybindingsMenu)
	onLoad = "[""onLoad"", _this, ""para_RscDisplayKeybindingsMenu""] call para_c_fnc_ui_initMissionDisplay";
	onUnload = "[""onUnload"", _this, ""para_RscDisplayKeybindingsMenu""] call para_c_fnc_ui_initMissionDisplay";
	class controlsBackground
	{
		class Title: para_RscText
		{
			text = $STR_vn_mf_keybindings_title;
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
			x = UIX(10);
			y = UIY(2.5);
			w = UIW(20);
			h = UIH(1);
		};
		class BackgroundList: para_RscText
		{
			colorBackground[] = {0,0,0,0.8};
			x = UIX(10);
			y = UIY(3.6);
			w = UIW(20);
			h = UIH(18.9);
		};
	};
	class controls
	{
		// A pretty stupid way to use idc=-1 with the listnbox when the arrows should not be drawn
		class LNBCatcher: para_RscText
		{
			idc = -1;
		};
		class KeybindsHeader: para_RscListNBox
		{
			colorSelectBackground2[] = {0,0,0,0}; // Selected item fill color
			colorSelectBackground[] = {0,0,0,0}; // Selected item fill color
			columns[] = {0,0.5};
			class items
			{
				class Action
				{
					text = $STR_vn_mf_keybindings_header_action;
				};
				class Keybind
				{
					text = $STR_vn_mf_keybindings_header_keybind;
				};
			};
			x = UIX(10.1);
			y = UIY(3.7);
			w = UIW(19.8);
			h = UIH(1);
		};
		class Keybinds: para_RscListNBox
		{
			idc = PARA_KEYBINDINGSMENU_KEYBINDS_IDC;
			columns[] = {0,0.5};
			x = UIX(10.1);
			y = UIY(4.8);
			w = UIW(19.8);
			h = UIH(15.4);
		};
		class Reset: para_RscButtonMenu
		{
			idc = PARA_KEYBINDINGSMENU_RESET_IDC;
			text = $STR_vn_mf_keybindings_reset;
			x = UIX(10.1);
			y = UIY(20.2);
			w = UIW(19.8);
			h = UIH(1);
			class Attributes
			{
				font = USEDFONT;
				color = "#FFFFFF";
				align = "left";
				shadow = "false";
			};
		};
		class Confirm: Reset
		{
			idc = 1;
			text = $STR_vn_mf_keybindings_confirm;
			y = UIY(21.4);
			w = UIW(9);
		};
		class Cancel: Reset
		{
			idc = 2;
			text = $STR_vn_mf_keybindings_cancel;
			x = UIX(20.9);
			y = UIY(21.4);
			w = UIW(9);
		};
	};
};