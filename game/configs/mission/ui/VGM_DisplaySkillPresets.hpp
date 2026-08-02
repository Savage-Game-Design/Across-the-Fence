// Layout constants local to this dialog
#define _DISPLAY_X VGM_MENU_X
#define _DISPLAY_Y VGM_MENU_Y
#define _DISPLAY_W VGM_MENU_W
#define _DISPLAY_H VGM_MENU_H

// Left panel (preset list) width
#define _LIST_W 80
// Right panel (summary) starts after list + gap
#define _SUMMARY_X (_LIST_W + 2)
#define _SUMMARY_W (_DISPLAY_W - _LIST_W - 3)
// Bottom button bar height
#define _BTN_H 7
// Name input height
#define _INPUT_H 6

class VGM_DisplaySkillPresets: VGM_DisplayMenuBase
{
    idd = VGM_IDD_DISPLAYSKILLPRESETS;
    onLoad = VGM_UIEH(onLoad,SkillPresets);
    onUnload = VGM_UIEH(onUnload,SkillPresets);

    class ControlsBackground: ControlsBackground
    {
        class Background: Background
        {
        };
    };

    class Controls: Controls
    {
        class HeaderBar: HeaderBar
        {
        };

        // Title label at top
        class Title: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_TITLE;
            text = "$STR_VGM_SKILL_PRESETS_TITLE";
            size = VGM_FONT_L;
            x = _DISPLAY_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + 1 * VGM_GRID_H;
            w = (_DISPLAY_W - 2) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };

        // Preset list (left panel)
        class PresetList: VGM_ctrlListBox
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_PRESETLIST;
            onLBSelChanged = VGM_UIEH(selectPreset,SkillPresets);
            x = _DISPLAY_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + 7 * VGM_GRID_H;
            w = _LIST_W * VGM_GRID_W;
            h = (_DISPLAY_H - 8 - _BTN_H - _INPUT_H - 2) * VGM_GRID_H;
            rowHeight = 8 * VGM_GRID_H;
        };

        // Skill summary (right panel)
        class PresetSummary: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_SUMMARY;
            x = _DISPLAY_X + _SUMMARY_X * VGM_GRID_W;
            y = _DISPLAY_Y + 7 * VGM_GRID_H;
            w = _SUMMARY_W * VGM_GRID_W;
            h = (_DISPLAY_H - 8 - _BTN_H - 1) * VGM_GRID_H;
        };

        // Name input field
        class PresetName: VGM_ctrlDefault
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_NAMEINPUT;
            type = 2; // CT_EDIT
            style = 0;
            font = VGM_FONT;
            sizeEx = VGM_FONT_M;
            text = "";
            autocomplete = "";
            colorBackground[] = {0.1,0.1,0.1,1};
            colorText[] = {VGM_UI_COLOR_TEXT};
            colorSelection[] = {VGM_UI_COLOR_ACTIVE};
            colorDisabled[] = {0.5,0.5,0.5,1};
            x = _DISPLAY_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + (_DISPLAY_H - _BTN_H - _INPUT_H - 1) * VGM_GRID_H;
            w = _LIST_W * VGM_GRID_W;
            h = _INPUT_H * VGM_GRID_H;
        };

        // Save button
        class SaveButton: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_SAVEBTN;
            text = "$STR_VGM_SKILL_PRESETS_SAVE";
            tooltip = "$STR_VGM_SKILL_PRESETS_SAVE_TOOLTIP";
            onButtonClick = VGM_UIEH(save,SkillPresets);
            x = _DISPLAY_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + (_DISPLAY_H - _BTN_H) * VGM_GRID_H;
            w = ((_LIST_W - 2) / 3) * VGM_GRID_W;
            h = _BTN_H * VGM_GRID_H;
        };

        // Load button
        class LoadButton: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_LOADBTN;
            text = "$STR_VGM_SKILL_PRESETS_LOAD";
            tooltip = "$STR_VGM_SKILL_PRESETS_LOAD_TOOLTIP";
            onButtonClick = VGM_UIEH(load,SkillPresets);
            x = _DISPLAY_X + (1 + ((_LIST_W - 2) / 3) + 1) * VGM_GRID_W;
            y = _DISPLAY_Y + (_DISPLAY_H - _BTN_H) * VGM_GRID_H;
            w = ((_LIST_W - 2) / 3) * VGM_GRID_W;
            h = _BTN_H * VGM_GRID_H;
        };

        // Delete button
        class DeleteButton: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYSKILLPRESETS_DELETEBTN;
            text = "$STR_VGM_SKILL_PRESETS_DELETE";
            tooltip = "$STR_VGM_SKILL_PRESETS_DELETE_TOOLTIP";
            onButtonClick = VGM_UIEH(delete,SkillPresets);
            x = _DISPLAY_X + (1 + 2 * (((_LIST_W - 2) / 3) + 1)) * VGM_GRID_W;
            y = _DISPLAY_Y + (_DISPLAY_H - _BTN_H) * VGM_GRID_H;
            w = ((_LIST_W - 2) / 3) * VGM_GRID_W;
            h = _BTN_H * VGM_GRID_H;
        };
    };
};

#undef _DISPLAY_X
#undef _DISPLAY_Y
#undef _DISPLAY_W
#undef _DISPLAY_H
#undef _LIST_W
#undef _SUMMARY_X
#undef _SUMMARY_W
#undef _BTN_H
#undef _INPUT_H
