#define para_WelcomeScreen_WIDTH (UIW(30))
#define para_WelcomeScreen_X (UIW(40) - para_WelcomeScreen_WIDTH) / 2

class para_WelcomeScreen {
    idd = 12021;
    onLoad = "[_this#0, 'welcome'] call para_c_fnc_welcomeScreenLoad;";
    class ControlsBackground {
        class Background: para_Overlay_StructuredText_Background {
            x = para_WelcomeScreen_X;
            w = para_WelcomeScreen_WIDTH;
            y = UIH(1) + UIH((30 / 4));
            h = UIH(24) - UIH((30 / 4));
            colorBackground[] = {0,0,0,00.85};
        };
    };
    class Controls {
        class Title: para_Overlay_Title_Background {
            idc = 10;
            text = "";
            x = para_WelcomeScreen_X;
            y = 0;
            h = UIH(1);
            w = para_WelcomeScreen_WIDTH;
        };
        class Banner: para_RscPicture {
            x = para_WelcomeScreen_X;
            y = UIH(1);
            h = UIH((30 / 4));
            w = para_WelcomeScreen_WIDTH;
            text = "\vn\missions_f_vietnam\data\img\mikeforce\mission_banner.jpg";
            colorText[] = {1,1,1,1};
            onLoad = "";
        };
        class Version: Title {
            idc = 20;
            style = ST_RIGHT;
            text = "";
            colorBackground[] = {0,0,0,0};
            colorText[] = {0,0,0,0.8};
        };

        class Scrollable: para_RscControlsGroupNoScrollbarH {
            x = para_WelcomeScreen_X + UIW(0.5);
            w = para_WelcomeScreen_WIDTH - UIW(1);
            y = UIH(1) + UIH((30 / 4)) + UIH(0.5);
            h = UIH(25) - UIH(1) - UIH((30 / 4)) - UIH(1);
            class Controls {
                class Text: para_Overlay_StructuredText_Background {
                    idc = 30;
                    x = 0;
                    w = para_WelcomeScreen_WIDTH - UIW(1);
                    y = 0;
                    h = UIH(25) - UIH(1) - UIH((30 / 4)) - UIH(1);
                    text = "";
                    colorBackground[] = {0,0,0,0};
                };
            };
        }
        class BtnLeft: RscButton {
            x = para_WelcomeScreen_X;
            w = para_WelcomeScreen_WIDTH / 2.0075;
            y = UIH(2) + UIH((30 / 4)) + UIH(25) - UIH(1) - UIH((30 / 4)) - UIH(1) + UIH(0.1);
            h = UIH(1);
            text = "Changelog"; // TODO: Localize
            shadow = 0;
            colorBackground[] = {0,0,0,0.8};
            action = "closeDialog 0; createDialog 'para_ChangelogScreen';";
        };
        class BtnRight: BtnLeft {
            x = para_WelcomeScreen_X + para_WelcomeScreen_WIDTH - (para_WelcomeScreen_WIDTH / 2.0075);
            text = "Play"; // TODO: Localize
            action = "closeDialog 0";
        };
    };
};

class para_ChangelogScreen {
    idd = 12022;
    onLoad = "[_this#0, 'changelog', [] call para_c_fnc_loadChangelogContent] call para_c_fnc_welcomeScreenLoad;";
    class ControlsBackground {
        class Background: para_Overlay_StructuredText_Background {
            x = para_WelcomeScreen_X;
            w = para_WelcomeScreen_WIDTH;
            y = UIH(1);
            h = UIH(24);
            colorBackground[] = {0,0,0,00.85};
        };
    };
    class Controls {
        class Title: para_Overlay_Title_Background {
            idc = 10;
            text = "";
            x = para_WelcomeScreen_X;
            y = 0;
            h = UIH(1);
            w = para_WelcomeScreen_WIDTH;
        };
        class Version: Title {
            idc = 20;
            style = ST_RIGHT;
            text = "";
            colorBackground[] = {0,0,0,0};
            colorText[] = {0,0,0,0.8};
        };

        class Scrollable: para_RscControlsGroupNoScrollbarH {
            x = para_WelcomeScreen_X + UIW(0.5);
            w = para_WelcomeScreen_WIDTH - UIW(1);
            y = UIH(1) + UIH(0.5);
            h = UIH(25) - UIH(1) - UIH(1);
            class Controls {
                class Text: para_Overlay_StructuredText_Background {
                    idc = 30;
                    x = 0;
                    w = para_WelcomeScreen_WIDTH - UIW(1);
                    y = 0;
                    h = UIH(25) - UIH(1) - UIH(1);
                    text = "";
                    colorBackground[] = {0,0,0,0};
                };
            };
        }
        class BtnLeft: RscButton {
            x = para_WelcomeScreen_X;
            w = para_WelcomeScreen_WIDTH / 2.0075;
            y = UIH(25.1);
            h = UIH(1);
            text = "Welcome Screen"; // TODO: Localize
            shadow = 0;
            colorBackground[] = {0,0,0,0.8};
            action = "closeDialog 0; createDialog 'para_WelcomeScreen';";
        };
        class BtnRight: BtnLeft {
            x = para_WelcomeScreen_X + para_WelcomeScreen_WIDTH - (para_WelcomeScreen_WIDTH / 2.0075);
            text = "Play"; // TODO: Localize
            action = "closeDialog 0";
        };
    };
};
