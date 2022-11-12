class para_RscDisplayBuildingMenu
{
	idd = 120000;
	movingEnable = 0;
	enableSimulation = 1;

	// onLoad = "ctrlSetFocus (uiNamespace getVariable ['#para_c_BuildingMenu_Table', controlNull])";
	onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_display', (_this#0)]; [[]] call para_c_fnc_buildingMenu_onLoad;";
	onUnload = "para_l_buildmode = nil;para_l_placing = false;";
	// onKeyDown = "if ((_this#1) isEqualTo 28) then { _this call para_c_fnc_buildingMenu_build; };";

	class ControlsBackground
	{
		class Folder: para_RscPicture
		{
			idc = -1;
			x = PARA_FOLDER_X;
			y = PARA_FOLDER_Y;
			w = PARA_FOLDER_W;
			h = PARA_FOLDER_H;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			text = "\vn\ui_f_vietnam\ui\taskroster\img\tr_folder_background_sheetL.paa";
			tooltip = "";
		};
		class Picture: para_RscPicture
		{
			x = PARA_SHEET_R_X + UIW(1);
			y = PARA_SHEET_R_Y + PARA_SHEET_R_H - UIH(7.9);
			w = UIW(10);
			h = UIH(7);
			text = "";
			onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Picture', _this#0]";
		};
		class Right: para_RscPicture
		{
			idc = -1;
			x = PARA_SHEET_R_X;
			y = PARA_SHEET_R_Y;
			w = PARA_SHEET_R_W;
			h = PARA_SHEET_R_H;
			
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			text = "\vn\ui_f_vietnam\ui\buildingmenu\bn_rightSheet.paa";
			tooltip = "";
		};
	};

	class Controls
	{
		class Left: para_RscControlsGroupNoScrollbarHV
		{
			x = PARA_SHEET_L_X + UIW(1);
			y = PARA_SHEET_L_Y + UIH(0.2);
			w = PARA_SHEET_L_W - UIW(3);
			h = PARA_SHEET_L_H - UIH(3.5) + UIH(1.2);
			class Controls
			{
				class Title: para_RscText
				{
					x = 0;
					y = 0;
					w = PARA_SHEET_L_W - UIW(3);
					h = UIH(2.4);
					text = $STR_vn_mf_buildingMenu_ui_title;
					sizeEx = TXT_XXL;
					colorText[] = { 0, 0, 0, 1 };
					style = 2;
				};
				class CategoryText: para_RscText
				{
					x = 0;
					y = UIH(2);
					w = UIW(4);
					h = UIH(1);
					text = $STR_vn_mf_buildingMenu_category;
					colorText[] = { 0,0,0,1 };
					// colorBackground[] = { 0,0,0,0.5 };
				};
				class SearchText: CategoryText
				{
					text = $STR_vn_mf_buildingMenu_search;
					y = UIH(3.5);
				};
				class AvailableText: SearchText
				{
					text = $STR_vn_mf_buildingMenu_showLocked;
					y = UIH(5);
				};
				class Page: para_ControlsTable
				{
					x = 0;
					y = UIH(4.8) + UIH(1.2);
					w = PARA_SHEET_L_W - UIW(3);
					h = UIH(15.4);

					rowHeight = UIH(2.4);
					lineSpacing = UIH(0.1);

					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Table', _this#0]";
					// onLBSelChanged = "_this call para_c_fnc_buildingMenu_selectBuilding";
					onMouseZChanged = "[true, ([-1, 1] select (_this#1 < 0)), true] call para_c_fnc_buildingMenu_onPageChange";

					class RowTemplate
					{
						class RowBackground
						{
							controlBaseClassPath[] = {"RscText"};
							columnX = 0;
							columnW = PARA_SHEET_L_W - UIW(3);
							controlOffsetY = 0;
						};
						class Picture
						{
							controlBaseClassPath[] = {"RscPictureKeepAspect"};
							columnX = 0;
							columnW = UIW(4);
							controlOffsetY = 0;
						};
						class Name
						{
							controlBaseClassPath[] = {"vn_RscStructuredText"};
							columnX = UIW(5);
							columnW = PARA_SHEET_L_W - UIW(8);
							controlOffsetY = UIH(0.8);
						};
					};
				};
				class CategoryBox: para_RscCombo
				{
					idc = -1;
					x = UIW(5);
					y = UIH(2);
					w = UIW(10);
					h = UIH(1);
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Select', _this#0];";
					wholeHeight = UIH(8);
					colorBackground[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
					colorSelectBackground[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
					colorSelectBackground2[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
				};
				class Search: para_RscEdit
				{
					idc = -1;
					x = UIW(5);
					y = UIH(3.5);
					w = UIW(10);
					h = UIH(1);
					colorText[] = { 0,0,0,1 };
					colorBackground[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
					colorSelectBackground[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
					colorSelectBackground2[] = { (234 / 255), (233 / 255), (232 / 255), 1 };
					shadow = 0;
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Search', _this#0];";
					onKeyDown = "call para_c_fnc_buildingMenu_onUpdate";
					onKeyUp = "call para_c_fnc_buildingMenu_onUpdate";
				};
				class Available: para_RscCheckBoxes {
					idc = -1;
					x = UIW(5);
					y = UIH(5);
					w = UIW(1);
					h = UIH(1);
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Available', _this#0]";
					textureChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
					textureDisabledChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
					textureDisabledUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
					textureFocusedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
					textureFocusedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
					textureHoverChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
					textureHoverUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
					texturePressedChecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_checked_ca.paa";
					texturePressedUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
					textureUnchecked = "A3\Ui_f\data\GUI\RscCommon\RscCheckBox\CheckBox_unchecked_ca.paa";
					tooltipColorBox[] = {1,1,1,1};
					tooltipColorShade[] = {0,0,0,0.65};
					tooltipColorText[] = {1,1,1,1};
					type = 77;
					style = 0;
					checked = 1;
					color[] = {0,0,0,1};
					colorBackground[] = {0,0,0,0};
					colorBackgroundDisabled[] = {0,0,0,0};
					colorBackgroundFocused[] = {0,0,0,0};
					colorBackgroundHover[] = {0,0,0,0};
					colorBackgroundPressed[] = {0,0,0,0};
					colorDisabled[] = {0,0,0,0.2};
					colorFocused[] = {0,0,0,1};
					colorHover[] = {0,0,0,1};
					colorPressed[] = {0,0,0,1};
					soundClick[] = {"",0.1,1};
					soundEnter[] = {"",0.1,1};
					soundEscape[] = {"",0.1,1};
					soundPush[] = {"",0.1,1};
				};
				class Previous: para_RscButton
				{
					x = 0;
					y = PARA_SHEET_L_H - UIH(4.5) + UIH(0.8);
					w = (PARA_SHEET_L_W - UIW(3)) / 3;
					h = UIH(1);
					text = $STR_vn_mf_buildingMenu_ui_previousPage;
					sizeEx = TXT_S;
					colorText[] = { 0,0,0,1 };
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_PreviousPage', _this#0]";
					onButtonClick = "[true, -1, true] call para_c_fnc_buildingMenu_onPageChange";
					soundClick[]= {
						"\vn\sounds_f_vietnam\ui\RscCombo\soundCollapse.ogg",
						0.5,
						1
					};
				};
				class Next: Previous
				{
					x = ((PARA_SHEET_L_W - UIW(3)) / 3) * 2;
					text = $STR_vn_mf_buildingMenu_ui_nextPage;
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_NextPage', _this#0]";
					onButtonClick = "[true, 1, true] call para_c_fnc_buildingMenu_onPageChange";
					soundClick[]= {
						"\vn\sounds_f_vietnam\ui\RscCombo\soundExpand.ogg",
						0.5,
						1
					};
				};
				class Pages: para_RscText
				{
					idc = 238298;
					x = (PARA_SHEET_L_W - UIW(3)) / 3;
					y = PARA_SHEET_L_H - UIH(4.5) + UIH(0.8);
					w = (PARA_SHEET_L_W - UIW(3)) / 3;
					h = UIH(1);
					sizeEx = TXT_S;
					colorText[] = { 0,0,0,1 };
					text = "";
					style = 2;

					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Page', _this#0]";
					onMouseZChanged = "[true, ([-1, 1] select (_this#1 < 0)), true] call para_c_fnc_buildingMenu_onPageChange";
				};
			};
		};
		class Right: para_RscControlsGroupNoScrollbarHV
		{
			x = PARA_SHEET_R_X + UIW(2.2);
			y = PARA_SHEET_R_Y + UIH(1);
			w = PARA_SHEET_R_W - UIW(3);
			h = PARA_SHEET_R_H - UIH(1.5);
			class Controls
			{
				class Title: para_RscText
				{
					sizeEx = TXT_XL;
					style = 2;
					x = 0;
					y = UIH(1.5);
					w = PARA_SHEET_R_W - UIW(3);
					h = UIH(3);
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Title', _this#0]";
					colorText[] = { 0,0,0,1 };
					text = "";
				};
				class Costs: para_RscStructuredText
				{
					x = 0;
					y = UIH(4.5);
					w = PARA_SHEET_R_W - UIW(3);
					h = UIH(10);
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Cost', _this#0]";
				};
				class Favorite: para_RscPicture {
					x = UIW(15);
					y = UIH(2.5);
					w = UIW(1);
					h = UIH(1);
					text = "\a3\ui_f\data\GUI\Rsc\RscDisplayMultiplayer\favouriteColumnTitle_ca.paa";
					colorText[] = {0.5,0.5,0.5,1};
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_FavIcon', _this#0]";
				};
				class FavoriteBtn: para_RscButton {
					x = UIW(15);
					y = UIH(2.5);
					w = UIW(1);
					h = UIH(1);
					onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_FavBtn', _this#0]";
					colorBackground[] = {1,1,1,0};
					colorBackgroundActive[] = {1,1,1,0};
					colorBackgroundDisabled[] = {1,1,1,0};
					colorFocused[] = {1,1,1,0};
				};
			};
		};
		class Build: para_RscButton
		{
			x = PARA_SHEET_R_X + PARA_SHEET_R_W - UIW(7.8);
			y = PARA_SHEET_R_Y + PARA_SHEET_R_H - UIH(5.9);
			w = UIW(7.1);
			h = UIH(3);
			text = $STR_vn_mf_buildingMenu_ui_build;
			onLoad = "uiNamespace setVariable ['#para_c_BuildingMenu_Build', _this#0];";
			onButtonClick = "[true] call para_c_fnc_buildingMenu_onBuild;";
			sizeEx = TXT_L;
			colorText[] = { 1,0,0,1 };
			colorDisabled[] = { 0.25, 0.25, 0.25, 1 };
		};
		class folder_cordels: para_RscPicture
		{
			idc = -1;
			x = PARA_CORDLES_X;
			y = PARA_CORDLES_Y;
			w = PARA_CORDLES_W;
			h = PARA_CORDLES_H;
			
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			text = "\vn\ui_f_vietnam\ui\taskroster\img\tr_folder_cordels.paa";
			tooltip = "";
			onLoad = "(_this#0) ctrlenable false;";
		};
	};
};
