#define para_RscDisplayBuildingMenu_headerHeight (UIH(1))
#define para_RscDisplayBuildingMenu_gutterHeight (UIH(0.1))
#define para_RscDisplayBuildingMenu_gutterWidth (UIW(0.1))
#define para_RscDisplayBuildingMenu_backgroundHeight (UIH(25) - para_RscDisplayBuildingMenu_headerHeight - para_RscDisplayBuildingMenu_gutterHeight)
#define para_RscDisplayBuildingMenu_paddingHeight (UIH(0.5))
#define para_RscDisplayBuildingMenu_paddingWidth (UIW(0.5))

class para_RscBugReport
{
	idd = 126037;
    class ControlsBackground
    {
        // Header
        class Header : para_Overlay_RscText
        {
            x = 0;
            y = 0;
            w = UIW(40);
            h = para_RscDisplayBuildingMenu_headerHeight;
            text = "Report a bug";
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
        };
        // Background
        class Background : para_Overlay_Text_Background
        {
            x = 0;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight;
            w = UIW(40);
            h = para_RscDisplayBuildingMenu_backgroundHeight;
            colorBackground[] = { 0,0,0,0.7 };
        };
        class Describe : para_Overlay_RscText
        {
            x = para_RscDisplayBuildingMenu_paddingWidth;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight;
            h = UIH(1);
            w = UIW(40);
            text = "Describe what happened:";
            colorText[] = { 1,1,1,0.6 };
        };
        class TextBackground : para_RscText
        {
            x = para_RscDisplayBuildingMenu_paddingWidth;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight + UIH(1);
            w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth;
            h = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(1.1);
            colorBackground[] = { 0,0,0,1 };
        };
        class Hint : para_RscText
        {
            idc = 10;
            x = para_RscDisplayBuildingMenu_paddingWidth + para_RscDisplayBuildingMenu_gutterWidth;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight + UIH(1) + para_RscDisplayBuildingMenu_gutterHeight;
            w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth - para_RscDisplayBuildingMenu_gutterWidth * 2;
            h = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(1.1) - para_RscDisplayBuildingMenu_gutterHeight * 2;
            font = "RobotoCondensed";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
            shadow = 0;
            style = ST_MULTI + ST_NO_RECT;
            colorBackground[] = { 0,0,0,0 };
            colorText[] = { 1,1,1,0.37 };
            text = "What happened that should/shouldn't have?\n\
Describe what you did leading up to the bug, step by step\n\
Is there any other information that would help us trigger the bug?";
        };

        class DebugTitle : para_Overlay_RscText
        {
            x = para_RscDisplayBuildingMenu_paddingWidth;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight + UIH(1) + para_RscDisplayBuildingMenu_gutterHeight + UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(0.8) - para_RscDisplayBuildingMenu_gutterHeight * 2;
            h = UIH(1);
            w = UIW(5);
            text = "Debug Data:";
        };
    };

    class Controls
    {
        // class Group : para_RscControlsGroupNoScrollbarH
        class Group : para_RscControlsGroup
        {
            idc = 40;
            x = para_RscDisplayBuildingMenu_paddingWidth + para_RscDisplayBuildingMenu_gutterWidth;
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight + UIH(1) + para_RscDisplayBuildingMenu_gutterHeight;
            w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth - para_RscDisplayBuildingMenu_gutterWidth * 2;
            h = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(1.1) - para_RscDisplayBuildingMenu_gutterHeight * 2;
            class Controls
            {
                class Dummy : para_RscText {
                    idc = 50;
                    x = 0;
                    y = 0;
                    w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth - para_RscDisplayBuildingMenu_gutterWidth * 2;
                    h = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(1.1) - para_RscDisplayBuildingMenu_gutterHeight * 2;
                    colorText[] = { 0,0,0,0 };
                    colorBackground[] = { 0,0,0,0 };
                    style = ST_MULTI + ST_NO_RECT;
                };
                class Input : para_RscEdit
                {
                    idc = 20;
                    x = 0;
                    y = 0;
                    w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth - para_RscDisplayBuildingMenu_gutterWidth * 2;
                    h = UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(1.1) - para_RscDisplayBuildingMenu_gutterHeight * 2;
                    font = "RobotoCondensed";
                    sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
                    shadow = 0;
                    autocomplete = "";
                    style = ST_MULTI + ST_NO_RECT;
                    colorBackground[] = { 0,0,0,0 };
                };
            };
        };

        class Debug : para_RscEdit
        {
            idc = 60;
            x = para_RscDisplayBuildingMenu_paddingWidth + para_RscDisplayBuildingMenu_gutterWidth + UIW(5);
            y = para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight + para_RscDisplayBuildingMenu_paddingHeight + UIH(1) + para_RscDisplayBuildingMenu_gutterHeight + UIH(25) - UIH(2) - 3 * para_RscDisplayBuildingMenu_paddingHeight - para_RscDisplayBuildingMenu_headerHeight + para_RscDisplayBuildingMenu_gutterHeight - UIH(1) - UIH(0.8) - para_RscDisplayBuildingMenu_gutterHeight * 2;
            w = UIW(40) - 2 * para_RscDisplayBuildingMenu_paddingWidth - para_RscDisplayBuildingMenu_gutterWidth * 2 - UIW(5);
            h = UIH(1);
            style = ST_NO_RECT;
            colorBackground[] = { 0,0,0,0.75 };
            colorText[] = { 1,1,1,0.6 };
            canModify = 0;
            font = "RobotoCondensed";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
            shadow = 0;
        };

        // Submit button
        class Submit : para_RscButton
        {
            idc = 30;
            y = UIH(25) - UIH(2) - para_RscDisplayBuildingMenu_paddingHeight;
            h = UIH(2);
            w = UIW(7);
            // x = UIW(20.5);
            text = "Submit Report";
            font = "RobotoCondensed";
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
            shadow = 0;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
            colorBackgroundDisabled[] = {38/255, 38/255, 38/255, 1};
            colorDisabled[] = {1,1,1,0.37};
        };
    };
};