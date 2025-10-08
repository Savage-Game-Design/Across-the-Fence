
class para_Notification: para_RscControlsGroupNoScrollbarHV {
    idc = 121300;
    // x = (safeZoneX + (safeZoneW / 2)) - (0.09 * safeZoneW);
    x = QUOTE(PXSZ_X_CL(0,9));
    y = QUOTE(safeZoneY - UIH(1));
    // w = 0.18 * safeZoneW;
    w = QUOTE(PXSZ_W(18));
    h = QUOTE(UIH(1));
    class Controls {
        class Head: para_RscControlsGroupNoScrollbarHV {
            idc = 121301;
            x = 0;
            y = 0;
            w = QUOTE(0.18 * safeZoneW);
            h = QUOTE(UIH(1));
            class Controls {
                class Background: para_Overlay_Title_Background {
                    idc = 121302;
                    x = 0;
                    y = 0;
                    // w = 0.18 * safeZoneW;
                    w = QUOTE(PXSZ_W(18));
                    h = QUOTE(UIH(1));
                };
                class Icon: para_RscPicture {
                    idc = 121303;
                    x = 0;
                    y = 0;
                    w = QUOTE(UIW(1));
                    h = QUOTE(UIH(1));
                };
                class Title: para_Overlay_RscText {
                    idc = 121304;
                    x = QUOTE(UIW(1));
                    y = 0;
                    // w = 0.18 * safeZoneW;
                    w = QUOTE(PXSZ_W(18));
                    h = QUOTE(UIH(1));
                };
            };
        };
        class Body: para_Overlay_StructuredText_Background {
            idc = 121305;
            x = 0;
            y = QUOTE(UIH(1) - pixelH);
            // w = 0.18 * safeZoneW;
            w = QUOTE(PXSZ_W(18));
            h = 0;
        };
    };
};
