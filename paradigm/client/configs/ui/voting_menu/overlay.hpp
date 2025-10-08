// (safezoneX + safezoneW - UIW(14.3)) - (safeZoneX + ((safeZoneW / 2) - UIW(7)) - UIW(14)

// "para_VoteOverlay" cutRsc ["para_VoteOverlay", "PLAIN", -1, false];

#define WEAPON_X (safezoneX + safezoneW - UIW(14.3))
#define NOTIFICATION_X (safeZoneX + ((safeZoneW / 2) - UIW(7)))
#define AVAILABLE_WIDTH (abs (WEAPON_X - (NOTIFICATION_X + UIW(14))))
#define AVAILABLE_FROM NOTIFICATION_X + UIW(14)

#define ITEM_W 16
#define ITEM_X AVAILABLE_FROM + (AVAILABLE_WIDTH / 2) - UIW(ITEM_W / 2)
#define ITEM_TEXT_HEIGHT 2.2

class para_VoteOverlay
{
    idd = 1202;
    fadein = 0;
    fadeout = 10000;
    duration = 10000;
    class Controls
    {
        class Holder: para_RscControlsGroupNoScrollbarHV
        {
            onLoad = "uiNamespace setVariable ['#para_c_VoteoOverlay_Holder', (_this#0)];";
            x = QUOTE(ITEM_X);
            y = QUOTE(safeZoneY + UIH(0.5));
            w = QUOTE(UIW(ITEM_W));
            h = 0;
            class Controls
            {
                class Header: para_RscControlsGroupNoScrollbarHV
                {
                    x = 0;
                    y = 0;
                    w = QUOTE(UIW(ITEM_W));
                    h = QUOTE(UIH(1));
                    class Controls
                    {
                        class Title: para_Overlay_Title_Background
                        {
                            x = 0;
                            y = 0;
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(1));
                            text = "Vote kick initiated";
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Title', (_this#0)];";
                        };
                        // class Votes: para_Overlay_RscText
                        // {
                        //     style = 2;
                        //     x = QUOTE(UIW(ITEM_W))  - QUOTE(UIW(4));
                        //     y = 0;
                        //     w = QUOTE(UIW(4));
                        //     h = QUOTE(UIH(1));
                        //     colorBackground[] = OVERLAY_ACTION_BACKGROUND_COLOR;
                        //     onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Votes', (_this#0)];";
                        //     text = "3 / 11 Votes";
                        // };
                    };
                };
                class Progress: para_RscControlsGroupNoScrollbarHV
                {
                    idc = -1;
                    x = 0;
                    y = QUOTE(UIH(1));
                    w = QUOTE(UIW(ITEM_W));
                    h = QUOTE(UIH(0.2));
                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Progress', (_this#0)];";
                    class Controls
                    {
                        class Background: para_Overlay_RscText
                        {

                            idc = -1;
                            x = 0;
                            y = 0;
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(0.2));
                            colorBackground[] = {0,0,0,0.5};
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_ProgressBackground', (_this#0)];";
                            text = "";
                        };
                        class Threshold: para_RscStatProgressHUD
                        {
                            idc = -1;
                            x = 0;
                            y = 0;
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(0.2));
                            colorBar[] = { 1, 1, 1, 0.5 };
                            onLoad = "(_this#0) progressSetPosition 1; uiNamespace setVariable ['#para_c_VoteOverlay_ProgressThreshold', (_this#0)];";
                        };
                        class Bar: para_Overlay_RscText
                        {
                            idc = -1;
                            x = 0;
                            y = 0;
                            w = QUOTE(UIW(16));
                            h = QUOTE(UIH(0.2));
                            colorBackground[] = { 0.2, 0.5, 0.05, 1 };
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_ProgressBar', (_this#0)];";
                        };
                    };
                };
                class Body: para_RscControlsGroupNoScrollbarHV
                {
                    x = 0;
                    y = QUOTE(UIH(1.2));
                    w = QUOTE(UIW(ITEM_W));
                    h = QUOTE(UIH(ITEM_TEXT_HEIGHT + 3.2));
                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Body', (_this#0)];";
                    class Controls
                    {
                        class Background: para_Overlay_Text_Background
                        {
                            x = 0;
                            y = 0;
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(ITEM_TEXT_HEIGHT + 3.2));
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Background', (_this#0)];";
                        };
                        class Text: para_Overlay_RscStructuredText
                        {
                            x = 0;
                            y = QUOTE(UIH(0.2));
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(ITEM_TEXT_HEIGHT));
                            size = QUOTE(TXT_CST(0.8));
                            text = "<t color='#0000FF'>Heyoxe</t> has initalized a vote to kick <t color='#0000FF'>Lou Montana</t> from it's role<br/>Do you want to kick him?";
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Text', (_this#0)];";
                        };
                        class Primary: para_RscControlsGroupNoScrollbarHV
                        {
                            idc = -1;
                            x = 0;
                            y = QUOTE(UIH(0.2 + ITEM_TEXT_HEIGHT));
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(1));
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Primary', (_this#0)];";
                            class Controls
                            {
                                class InteractionKey: para_RscControlsGroupNoScrollbarHV
                                {
                                    idc = -1;
                                    x = 0;
                                    y = 0;
                                    w = QUOTE(UIH(1) * (3 / 4));
                                    h = QUOTE(UIH(1));
                                    class Controls
                                    {
                                        class Key: para_RscControlsGroupNoScrollbarHV
                                        {
                                            idc = -1;
                                            x = QUOTE(UIH(0.1));
                                            y = QUOTE(UIH(0.15) * (3 / 4));
                                            w = QUOTE(UIH(0.8) * (3 / 4));
                                            h = QUOTE(UIH(0.8));
                                            class Controls
                                            {
                                                class Icon: para_RscPicture
                                                {
                                                    idc = -1;
                                                    x = 0;
                                                    y = 0;
                                                    w = QUOTE(UIH(0.8) * (3 / 4));
                                                    h = QUOTE(UIH(0.8));
                                                    text = "\vn\ui_f_vietnam\ui\interactionOverlay\vn_ico_mf_hud_key_ca.paa";
                                                };
                                                class Key: para_InteractionOverlay_RscText
                                                {
                                                    idc = -1;
                                                    style = 2;
                                                    x = 0;
                                                    y = 0;
                                                    w = QUOTE(UIH(0.8) * (3 / 4));
                                                    h = QUOTE(UIH(0.8));
                                                    colorText[] = {0,0,0,1};
                                                    text = "F1";
                                                    sizeEx = QUOTE(TXT_CST(0.7));
                                                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Primary_Key', (_this#0)];";
                                                };
                                            };
                                        };
                                    };
                                };
                                class Text: para_InteractionOverlay_RscText
                                {
                                    idc = -1;
                                    style = 0;
                                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Primary_Text', (_this#0)];";
                                    x = QUOTE(UIH(1) * (3 / 4) + UIH(0.1));
                                    y = 0;
                                    w = QUOTE(UIW(3));
                                    h = QUOTE(UIH(1));
                                    text = "Yes";
                                    colorText[] = OVERLAY_ACTION_TEXT_COLOR;
                                };
                            };
                        };
                        class No: para_RscControlsGroupNoScrollbarHV
                        {
                            idc = -1;
                            x = 0;
                            y = QUOTE(UIH(0.2 + ITEM_TEXT_HEIGHT + 1.2));
                            w = QUOTE(UIW(ITEM_W));
                            h = QUOTE(UIH(1));
                            onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Secondary', (_this#0)];";
                            class Controls
                            {
                                class InteractionKey: para_RscControlsGroupNoScrollbarHV
                                {
                                    idc = -1;
                                    x = 0;
                                    y = 0;
                                    w = QUOTE(UIH(1) * (3 / 4));
                                    h = QUOTE(UIH(1));
                                    class Controls
                                    {
                                        class Key: para_RscControlsGroupNoScrollbarHV
                                        {
                                            idc = -1;
                                            x = QUOTE(UIH(0.1));
                                            y = QUOTE(UIH(0.15) * (3 / 4));
                                            w = QUOTE(UIH(0.8) * (3 / 4));
                                            h = QUOTE(UIH(0.8));
                                            class Controls
                                            {
                                                class Icon: para_RscPicture
                                                {
                                                    idc = -1;
                                                    x = 0;
                                                    y = 0;
                                                    w = QUOTE(UIH(0.8) * (3 / 4));
                                                    h = QUOTE(UIH(0.8));
                                                    text = "\vn\ui_f_vietnam\ui\interactionOverlay\vn_ico_mf_hud_key_ca.paa";
                                                };
                                                class Key: para_InteractionOverlay_RscText
                                                {
                                                    idc = -1;
                                                    style = 2;
                                                    x = 0;
                                                    y = 0;
                                                    w = QUOTE(UIH(0.8) * (3 / 4));
                                                    h = QUOTE(UIH(0.8));
                                                    colorText[] = {0,0,0,1};
                                                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Secondary_Key', (_this#0)];";
                                                    text = "F2";
                                                    sizeEx = QUOTE(TXT_CST(0.7));
                                                };
                                            };
                                        };
                                    };
                                };
                                class Text: para_InteractionOverlay_RscText
                                {
                                    idc = -1;
                                    style = 0;
                                    onLoad = "uiNamespace setVariable ['#para_c_VoteOverlay_Secondary_Text', (_this#0)];";
                                    x = QUOTE(UIH(1) * (3 / 4) + UIH(0.1));
                                    y = 0;
                                    w = QUOTE(UIW(3));
                                    h = QUOTE(UIH(1));
                                    text = "No";
                                    colorText[] = OVERLAY_ACTION_TEXT_COLOR;
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};
