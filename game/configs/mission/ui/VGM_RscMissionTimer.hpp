class VGM_RscMissionTimer
{
    idd = -1;
    onLoad = "uiNamespace setVariable ['vgm_RscMissionTimer', _this#0]";
    duration = 1e10;
    fadeIn = 0;
    fadeOut = 0.5;

    class Controls
    {
        class TimerText: RscStructuredText
        {
            idc = 9500;
            style = 0x01; // ST_CENTER
            text = "";
            size = "0.04 * safezoneH";
            x = "safezoneX + safezoneW / 2 - 0.06";
            y = "safezoneY + 0.02";
            w = "0.12";
            h = "0.065";
            shadow = 2;
            colorBackground[] = {0,0,0,0};
        };
    };
};
