class para_RscDisplayDynamicGroups	
{
	onLoad = "['onLoad', _this] call para_c_fnc_ui_dynamicGroups;";
	onUnload = "uiNamespace setVariable ['para_c_dynamicGroups_display', displayNull],['onUnload', _this] call para_c_fnc_ui_dynamicGroups;";
	idd = PARA_C_DYNAMICGROUPS_IDD;
	movingEnable = 1;
	enableSimulation = 1;
    class controlsBackground
    {
		class folderBackground: para_RscPicture
		{
			x = PARA_FOLDER_X;
			y = PARA_FOLDER_Y;
			w = PARA_FOLDER_W;
			h = PARA_FOLDER_H;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			text = "\vn\ui_f_vietnam\ui\taskroster\img\tr_folder_background_sheetL.paa";
			tooltip = "";
		};
        //Clean Sheet, already adjusted to Standard Folder Size and correct position
        class PARA_DG_sheet_clean_R_base: para_RscPicture
        {
            x = PARA_SHEET_R_X;
            y = PARA_SHEET_R_Y;
            w = PARA_SHEET_R_W;
            h = PARA_SHEET_R_H;
            
            colorText[] = {1,1,1,1};
            colorBackground[] = {1,1,1,1};
            text = "\vn\ui_f_vietnam\ui\taskroster\img\tr_sheet_clean.paa";
            tooltip = "";
        };
        //Cordels in the center of the folder. Must be loaded as last item!
        class PARA_DG_cordels: para_RscPicture
        {
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
    class Controls 
    {
        class ButtonJoin : para_RscButton 
        {
            idc = PARA_C_DYNAMICGROUPS_BUTTONJOIN_IDC;
            x = UIX_CL(9.5);
            y = UIY_CD(9);
            w = UIW(8);
            h = UIH(2);
            text = "$STR_A3_RscDisplayDynamicGroups_Button_Join";
            colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
            colorDisabled[] = {1,0.05,0.05,1};
        };
        class ButtonInvite : ButtonJoin 
        {
            idc = PARA_C_DYNAMICGROUPS_BUTTONINVITE_IDC;
            x = PARA_DG_MANAGE_X;
            y = UIY_CD(9);
            w = UIW(8);
            h = UIH(2);
            text = "$STR_A3_RscDisplayDynamicGroups_Button_Invite";
            colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
        };
        class ButtonCreateLeaveKick : ButtonJoin 
        {
            idc = PARA_C_DYNAMICGROUPS_BUTTONCREATELEAVEKICK_IDC;
            x = PARA_DG_GROUP_X;
            y = UIY_CD(9);
            w = UIW(8);
            h = UIH(2);	
            text = "$STR_A3_RscDisplayDynamicGroups_Button_Create";
            colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
        };
        class ButtonPromoteDisband : ButtonJoin 
        {
            idc = PARA_C_DYNAMICGROUPS_BUTTONPROMOTEDISBAND_IDC;
            x = UIX_CR(11);
            y = UIY_CD(9);
            w = UIW(8);
            h = UIH(2);
            text = "$STR_A3_RscDisplayDynamicGroups_Button_Promote";
            colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
        };
        class SectionManage : para_RscControlsGroupNoScrollbarHV 
        {
            idc = PARA_C_DYNAMICGROUPS_SECTIONMANAGE_IDC;
            x = PARA_DG_MANAGE_X;
            y = PARA_DG_MANAGE_Y;
            w = PARA_DG_MANAGE_W;
            h = PARA_DG_MANAGE_H;

            class Controls 
            {
                class TextPlayerCount : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERCOUNT_IDC;
                    x = UIW(15.5);
                    y = UIH(0.1);
                    w = UIW(1.5);
                    h = UIH(1.5);
                    text = "6";
					tooltip="$STR_A3_RscDisplayDynamicGroups_Tooltip_PlayersInGroup";
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    size = TXT_XL;
                };
                class BackgroundGroupName : para_RscStructuredText 
                {
                    idc = PARA_C_DYNAMICGROUPS_BACKGROUNDGROUPNAME_IDC;
                    x = 0;
                    y = UIH(0.1);
                    w = UIW(15.5);
                    h = UIH(1.5);
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class GroupIcon : para_RscPictureKeepAspect 
                {
                    idc = PARA_C_DYNAMICGROUPS_GROUPICON_IDC;
                    x = UIW(10);
                    y = UIH(2.1);
                    w = UIW(7);
                    h = UIH(6);
					text="\A3\Ui_f\data\GUI\Cfg\UnitInsignia\bi_ca.paa";
                };
                class EditGroupName : para_RscEdit 
                {
                    idc = PARA_C_DYNAMICGROUPS_EDITGROUPNAME_IDC;
                    x = 0;
                    y = 0;
                    w = UIW(15.6);
                    h = UIH(1.5);
					text="Alpha 1-2";
					tooltip="$STR_A3_RscDisplayDynamicGroups_Tooltip_EditGroupName";
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    shadow = 0;
                };
                class CheckboxPrivate : para_RscCheckBox 
                {
                    idc = PARA_C_DYNAMICGROUPS_CHECKBOXPRIVATE_IDC;
                    x = UIW(4);
                    y = UIH(6.6);
                    w = UIW(1);
                    h = UIH(1);
					tooltip="$STR_A3_RscDisplayDynamicGroups_Tooltip_PrivateGroup";
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class ListboxManage : para_RscListNBox 
                {
                    idc = PARA_C_DYNAMICGROUPS_LISTBOXMANAGE_IDC;
                    x = UIW(0);
                    y = UIH(8.1);
                    w = UIW(17);
                    h = UIH(12);	
                    columns[]={UIW(0),UIW(1.5),UIW(17)};
					colorSelect2[]={0.94999999,0.94999999,0.94999999,1};
					colorSelectBackground[]={1,1,1,0.25};
					colorSelectBackground2[]={1,1,1,0.25};
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
					colorPicture[]={1,1,1,1};
					colorPictureSelected[]={1,1,1,1};
					colorPictureDisabled[]={1,1,1,0.5};
                };
                class TextPlayerName : para_RscStructuredText 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERNAME_IDC;
                    x = UIW(0);
                    y = UIH(2.1);
                    w = UIW(4);
                    h = UIH(1.4);
					text="$STR_A3_RscDisplayDynamicGroups_You";
                    size = TXT_L;
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    valign = "middle";
                };
                class TextPlayerSide : para_RscStructuredText 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERSIDE_IDC;
                    x = UIW(0);
                    y = UIH(3.6);
                    w = UIW(4);
                    h = UIH(1.4);
					text="$STR_A3_RscDisplayDynamicGroups_Side";
                    size = TXT_L;
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    valign = "middle";
                };
                class TextPlayerScore : para_RscStructuredText 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERSCORE_IDC;
                    x = UIW(0);
                    y = UIH(5.1);
                    w = UIW(4);
                    h = UIH(1.4);
					text="$STR_A3_RscDisplayDynamicGroups_Score";
                    size = TXT_L;
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    valign = "middle";
                };
                class TextPrivate : para_RscStructuredText 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPRIVATE_IDC;
                    x = UIW(0);
                    y = UIH(6.6);
                    w = UIW(4);
                    h = UIH(1.4);
					text="$STR_A3_RscDisplayDynamicGroups_Private";
                    size = TXT_L;
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                    valign = "middle";
                };
                class TextPlayerNameFill : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERNAMEFILL_IDC;
                    x = UIW(4);
                    y = UIH(2.1);
                    w = UIW(6);
                    h = UIH(1.4);
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class TextPlayerSideFill : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERSIDEFILL_IDC;
                    x = UIW(4);
                    y = UIH(3.6);
                    w = UIW(6);
                    h = UIH(1.4);
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class TextPlayerScoreFill : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TEXTPLAYERSCOREFILL_IDC;
                    x = UIW(4);
                    y = UIH(5.1);
                    w = UIW(6);
                    h = UIH(1.4);
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
            };
        };
        class SectionGroups : para_RscControlsGroupNoScrollbarHV
        {
            idc = PARA_C_DYNAMICGROUPS_SECTIONGROUPS_IDC;
            x = PARA_DG_GROUP_X;
            y = PARA_DG_GROUP_Y;
            w = PARA_DG_GROUP_W;
            h = PARA_DG_GROUP_H;

            class Controls 
            {
                class TabButtonGroups : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TABBUTTONGROUPS_IDC;
                    x = 0;
                    y = 0;
                    w = UIW(8.5);
                    h = UIH(2);	
					text="$STR_A3_RscDisplayDynamicGroups_Groups";
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class TabButtonPlayers : para_RscButton 
                {
                    idc = PARA_C_DYNAMICGROUPS_TABBUTTONPLAYERS_IDC;
                    x = UIW(8.5);
                    y = 0;
                    w = UIW(8.5);
                    h = UIH(2);
					text="$STR_A3_RscDisplayDynamicGroups_Players";
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class ListboxGroups : para_RscTree 
                {
                    idc = PARA_C_DYNAMICGROUPS_LISTBOXGROUPS_IDC;
                    x = UIW(0);
                    y = UIH(2);
                    w = UIW(17);
                    h = UIH(17);
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
                };
                class ListboxPlayers : para_RscListNBox 
                {
                    idc = PARA_C_DYNAMICGROUPS_LISTBOXPLAYERS_IDC;
                    x = UIW(0);
                    y = UIH(2);
                    w = UIW(17);
                    h = UIH(17);
                    columns[]={UIW(0),UIW(1.5),UIW(17)};
					colorSelect2[]={0.94999999,0.94999999,0.94999999,1};
					colorSelectBackground[]={1,1,1,0.25};
					colorSelectBackground2[]={1,1,1,0.25};
                    colorText[] = PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG;
					colorPicture[]={1,1,1,1};
					colorPictureSelected[]={1,1,1,1};
					colorPictureDisabled[]={1,1,1,0.5};
                };
            };
        };
    };
};
