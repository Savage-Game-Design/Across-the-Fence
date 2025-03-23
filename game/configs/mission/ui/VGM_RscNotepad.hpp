class VGM_RscNotepad
{
    onLoad = "['onLoad', _this] call vgm_c_fnc_displayNotepad";
    onUnload = "['onUnload', _this] call vgm_c_fnc_displayNotepad";

    idc = -1;
    type = 82; // https://community.bistudio.com/wiki/CT_OBJECT_CONTAINER

    model = __EVAL(getMissionPath "assets\notepad\notepad.p3d");
    scale = 1/VGM_NOTEPAD_SIZE_FACTOR;
    direction[] = {0, 0, 1};
    up[] = {0, 1, 0};

    x = safeZoneX + VGM_NOTEPAD_W/2;
    y = 0.55; z = 0.22;
    xBack = safeZoneX + VGM_NOTEPAD_W/8;
    yBack = 0.15; zBack = 1;

    inBack = 0;
    enableZoom = 1;
    zoomDuration = 0.00001;

    class Areas
    {
        class Main
        {
            selection = "main";
            class Controls
            {
                class Main: ctrlControlsGroup
                {
                    onLoad = "ctrlParent (_this#0) setVariable ['VGM_RscNotepad_Main', _this#0];";
                    idc = VGM_IDC_RSCNOTEPAD_MAIN;
                    x = 1.75 * VGM_NOTEPAD_GRID_W;
                    y = 10.5 * VGM_NOTEPAD_GRID_H;
                    w = VGM_NOTEPAD_W;
                    h = VGM_NOTEPAD_H;

                    class Controls
                    {
                        /*class bg: VGM_ctrlStatic
                        {
                            w = VGM_NOTEPAD_W;
                            h = VGM_NOTEPAD_H;
                            colorBackground[] = {0,1,0,0.25};
                            text = "Lorem ipsum... Lorem ipsum...";
                        };*/
                    };
                };
            };
        };
    };
};
