#define _PICTURE_H (safeZoneH * 0.70)
#define _PICTURE_W (_PICTURE_H)
#define _PROGRESS_BAR_W (_PICTURE_H * 0.98)
#define _PROGRESS_BAR_H (0.007 * safeZoneH)
#define _TEXT_H (0.03 * safeZoneH)

class VGM_DisplayLoading {
    idd = -1;
    onLoad = "uiNamespace setVariable ['vgm_displayLoading', _this select 0]";
    duration = 1e39;
    fadeIn = 0;
    fadeOut = 0;
    name = "Across the Fence loading screen";

    class ControlsBackground {
        class Black: RscText
        {
            idc = 5001;
            colorBackground[] = {0,0,0,1};
            x = "safezoneXAbs";
            y = "safezoneY";
            w = "safezoneWAbs";
            h = "safezoneH";
        };
        // based on:
        // configFile >> "RscDisplayLoading" >> "Variants" >> "Loading" >> "controlsBackground" >> "Map"
        class Table: RscPictureKeepAspect
        {
            // 2048 x 1024
            text = __EVAL(\
                selectRandom [\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_01.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_02.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_03.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_04.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_05.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_06.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_07.paa"\
                ]\
            );

            x = "safezoneX + safeZoneW/2 - safeZoneH*2/2";
            y = "safezoneY";
            w = "safeZoneH*2";
            h = "safezoneH";
        };
        class TableOverlay: Table
        {
            style = ST_PICTURE;
            text = "#(argb,2048,1024,3)color(0,0,0,1)";
            colorText[] = {1,1,1,0.42};
        };
    };

    class Controls {
        class Header: RscControlsGroupNoScrollbars {
            class Controls {
                class Title: RscText {
                };
            };
        };
        class LoadingPicture: RscText {
            idc = 5002;
            style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
            text = __EVAL(\
                selectRandom [\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_01_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_02_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_03_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_04_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_05_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_06_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_07_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_08_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_09_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_10_ca.paa",\
                    "\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_11_ca.paa"\
                ]\
            );
            colorText[] = {1,1,1,1};
            colorBackground[] = {1,0,0,1};

            x = safeZoneX + safezoneW/2 - _PICTURE_W/2;
            y = safeZoneY + safeZoneH/2 - _PICTURE_H*2/2;
            w = _PICTURE_W;
            h = _PICTURE_H*2;
        };
        class LoadingProgress: RscProgress {
            idc = 104; // engine looks for IDC 104
            style = ST_HORIZONTAL;
            colorBar[] = {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
            };
            colorFrame[] = {1,1,1,0.7};
            texture = "#(argb,8,8,3)color(1,1,1,1)";

            x = safeZoneX + safezoneW/2 - _PROGRESS_BAR_W/2;
            y = safeZoneY + safeZoneH/2 + _PICTURE_H/2 + 1.7*_PROGRESS_BAR_H;
            w = _PROGRESS_BAR_W;
            h = _PROGRESS_BAR_H;
        };
        class LoadingText: RscStructuredText {
            idc = 5050;
            text = "$STR_LOADING";

            size = _TEXT_H;
            class Attributes
            {
                align = "center";
            };

            x = safeZoneX;
            y = safeZoneY + safeZoneH/2 + _PICTURE_H/2 + 1.7*_PROGRESS_BAR_H*2 + _PROGRESS_BAR_H;
            w = safeZoneW;
            h = _TEXT_H;
        };
    };
};

#undef _PICTURE_W
#undef _PICTURE_H
#undef _PROGRESS_BAR_W
#undef _PROGRESS_BAR_H
#undef _TEXT_H
