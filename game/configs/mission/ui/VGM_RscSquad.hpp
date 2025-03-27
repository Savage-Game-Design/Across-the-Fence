class VGM_RscSquad {
    idd = -1;
    onLoad = VGM_UIEH(onLoad,Squad);
    onUnload = VGM_UIEH(onUnload,Squad);
    duration = 1e10;
    fadeIn = 0;
    fadeOut = 0;
    class Controls
    {
        class Bar: RscControlsGroupNoScrollbars
        {
            idc = VGM_IDC_RSCSQUAD_BAR;
            x = safeZoneX + 1 * GUI_GRID_W;
            y = safeZoneY + safeZoneH - 8.2 * GUI_GRID_H;
            w = safeZoneW - 2 * GUI_GRID_W;
            h = 7.1 * GUI_GRID_H;
            class Controls
            {
                class SquadMember: RscControlsGroupNoScrollbars
                {
                    idc = -1;
                    x = 0;
                    y = 0;
                    w = 3 * GUI_GRID_W;
                    h = 7.1 * GUI_GRID_H;
                    class Controls
                    {
                        // Notifications
                        class NotificationsBackground: RscText
                        {
                            x = 0;
                            y = 0;
                            w = 3 * GUI_GRID_W;
                            h = 4.5 * GUI_GRID_H;
                            colorBackground[] = { VGM_UI_COLOR_GREY,0.4 };
                            colorText[] = { VGM_UI_COLOR_GREY,0.8 };
                        };
                        class Notifications: RscControlsGroupNoScrollbars
                        {
                            x = 0;
                            y = 0;
                            w = 3 * GUI_GRID_W;
                            h = 3 * GUI_GRID_H;
                            class Controls
                            {
                                class Notifaction: RscPicture
                                {
                                    text = "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa";
                                    /*text = "#(argb,8,8,3)color(1,1,1,1)";*/
                                    colorText[] = {1,1,1,1};
                                    x = 0.3 * GUI_GRID_W;
                                    y = 0.3 * GUI_GRID_H;
                                    w = 2.4 * GUI_GRID_W;
                                    h = 2.4 * GUI_GRID_H;
                                    colorBackground[] = {0,1,0,1};
                                };
                            };
                        };
                        // Name
                        class NameBackground: RscText
                        {
                            x = 0;
                            y = 4.5 * GUI_GRID_H;
                            w = 3 * GUI_GRID_W;
                            h = 2.6 * GUI_GRID_H;
                            colorBackground[] = {0.3, 0.3, 0.3, 0};
                        };
                        class Name: RscStructuredText
                        {
                            idc = VGM_IDC_RSCSQUAD_MEMBER_NAME;
                            text = "Terra";
                            x = 0;
                            y = 6 * GUI_GRID_H;
                            w = 3 * GUI_GRID_W;
                            h = 1 * GUI_GRID_H;
                            class Attributes
                            {
                                font = "RobotoCondensed";
                                color = "#ffffff";
                                colorLink = "#D09B43";
                                align = "center";
                                shadow = 0;
                            };
                        };
                        class IconHealth: RscPicture
                        {
                            text = "assets\squad\circle_ca.paa";
                            colorText[] = {0,1,0,1};
                            x = 0;
                            y = 3 * GUI_GRID_H;
                            w = 3 * GUI_GRID_W;
                            h = 3 * GUI_GRID_H;
                        };
                    };
                };
            }
        };
    };
};
