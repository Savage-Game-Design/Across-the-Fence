class VGM_DisplayLoading
{
    idd = -1;
    onLoad = "uiNamespace setVariable ['vgm_displayLoading', _this select 0]";
    duration = 1e39;
    fadeIn = 0;
    fadeOut = 0;
    name = "Across the Fence loading screen";

    class ControlsBackground
    {
        class Black: RscText
        {
            idc = 5001;
            colorBackground[] = {0,0,0,1};
            x = "safezoneXAbs";
            y = "safezoneY";
            w = "safezoneWAbs";
            h = "safezoneH";
        };

        class Overlay: RscPicture
        {
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
            colorText[] = {1,1,1,0.8};
            x = "safezoneX";
            y = "safezoneY";
            w = "safezoneW";
            h = "safezoneH";
        };
    };

    class Controls
    {
        class LoadingProgress: RscProgress
        {
            idc = 104; // progress bar, has to have idc 104
            style = ST_HORIZONTAL;
            colorBar[] = {
                "(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
                "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
            };
            texture = "#(argb,8,8,3)color(1,1,1,1)";

            x = 0.295761 * safezoneW + safezoneX;
            y = 0.9 * safezoneH + safezoneY;
            w = 0.408477 * safezoneW;
            h = 0.0066 * safezoneH;
        };
        class LoadingText: RscStructuredText
        {
            idc = 5050;
            text = "";

            sizeEx = "0.8 * GUI_GRID_H";
            class Attributes
            {
                size = 0.8 * GUI_GRID_H;
                align = "center";
            };

            x = 0.314328 * safezoneW + safezoneX;
            y = 0.80 * safezoneH + safezoneY;
            w = 0.350767 * safezoneW;
            h = 0.0396 * safezoneH;
        };
    };
};
