class RscTextNoShadowLeft
{
    access = 0;
    colorBackground[] = {0,0,0,0};
    colorShadow[] = {0,0,0,0.5};
    colorText[] = {1,1,1,1};
    deletable = 0;
    fade = 0;
    fixedWidth = 0;
    font = "RobotoCondensed";
    h = 0.037;
    idc = -1;
    linespacing = 1;
    shadow = 0;
    SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
    style = 0;
    text = "";
    tooltipColorBox[] = {1,1,1,1};
    tooltipColorShade[] = {0,0,0,0.65};
    tooltipColorText[] = {1,1,1,1};
    type = 0;
    w = 0.3;
    x = 0;
    y = 0;
};

class RscTextNoShadowRight: RscTextNoShadowLeft
{
    style = 1;
};

class para_optionsMenu
{
    idd = 12038;
    onUnload = "_this call para_c_fnc_optionsMenu_onUnload";
    class Controls
    {
        class Title: para_Overlay_RscText
		{
			text = "Options Menu";
			colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
			x = UIX(0);
			y = UIY(0);
			w = UIW(40);
			h = UIH(1);
		};
        class Body: para_RscControlsGroupNoScrollbarHV
        {
            x = UIX(0);
            y = UIY(1.1);
            w = UIW(40);
            h = UIH(23.9);
            class Controls
            {
                class Background: para_Overlay_Text_Background
                {
                    x = UIW(0);
                    y = UIH(0);
                    w = UIW(40);
                    h = UIH(22.7);
                };

                class TitleOption: para_Overlay_RscText
                {
                    text = "Option";
                    colorBackground[] = { 0,0,0, 1 };
                    x = UIW(0.4);
                    y = UIH(0.4);
                    w = UIW(28.2);
                    h = UIH(1);
                };
                class TitleValue: TitleOption
                {
                    text = "Value";
                    x = UIW(28.6);
                    w = UIW(11);
                };
                class OptionsBackground: para_Overlay_Text_Background
                {
                    x = UIW(0.4);
                    y = UIH(1.4);
                    w = UIW(39.2);
                    h = UIH(20.9);
                };

                class Options: para_RscControlsGroupNoScrollbarH
                {
                    x = UIW(0.4);
                    y = UIH(1.4);
                    w = UIW(39.2);
                    h = UIH(20.9);
                    onLoad = "uiNamespace setVariable ['Table', _this#0]";
                };

                class Cancel: para_RscButton
                {
                    idc = 2;
                    x = UIW(0);
                    y = UIH(22.8);
                    w = UIW(6);
                    h = UIH(1);
                    text = "Cancel";
                    font = "RobotoCondensed";

                    style = 0 + 192;
                    colorText[] = {1,1,1,1.0};
                    colorDisabled[] = {1,1,1,0.25};
                    colorBackground[] = {0,0,0,0.8};
                    colorBackgroundActive[] = {0,0,0,1};
                    colorBackgroundDisabled[] = {0,0,0,0.5};
                    colorFocused[] = {0,0,0,1};
                    colorShadow[] = {0,0,0,0};
                    onButtonClick = "closeDialog 2";
                };
                class ResetAll: Cancel
                {
                    idc = 3;
                    x = UIW(6.1);
                    y = UIH(22.8);
                    text = "Reset All";
                    onButtonClick = "closeDialog 3";
                };
                // class ResetSelected: Cancel
                // {
                //     x = UIW(12.2);
                //     y = UIH(22.8);
                //     text = "Reset Selected";
                // };
                class Ok: Cancel
                {
                    idc = 1;
                    x = UIW(34);
                    y = UIH(22.8);
                    text = "Ok";
                    onButtonClick = "closeDialog 1";
                };
            };
        };
    };
};
