#define COLUMN_W 80
#define DISPLAY_W (3 * COLUMN_W + 12)
#define DISPLAY_H VGM_GRID_MAX_H
#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)
#define COLUMN3_X DISPLAY_X + (2 * COLUMN_W + 11) * VGM_GRID_W
#define PICTURE_H (COLUMN_W - 35)
class VGM_DisplayAbilities
{
    idd = VGM_IDD_DISPLAYABILITIES;
    onLoad = VGM_UIEH(onLoad,Abilities);
    class ControlsBackground
    {
        class Background: VGM_ctrlBackground
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
        class BackgroundAvailable: VGM_ctrlBackground
        {
            x = DISPLAY_X + (COLUMN_W + 6) * VGM_GRID_W;
            y = DISPLAY_Y + 12 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 13) * VGM_GRID_H;
            colorBackground[] = {0.85,0.85,0.85,1};
        };
        class BackgroundSkill: VGM_ctrlBackground
        {
            x = COLUMN3_X;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
            colorBackground[] = {0.85,0.85,0.85,1};
        };
    };
    class Controls
    {
        class StdInfo: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDINFO;
            text = "Standard Ability (i)";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
        class StdName: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDNAME;
            text = "No ability equipped.";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 11 * VGM_GRID_H;
            w = 80 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            size = VGM_FONT_L * VGM_GRID_H;
        };
        class Std: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_STD;
            text = "Suffer no stamina drain for 30 seconds.";
            /* text = ""; */
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 17 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 20 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
            size = VGM_FONT_L * VGM_GRID_H;
        };
        class StdCooldownTime: Std
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDCOOLDOWNTIME;
            text = "XX seconds cooldown time.";
            y = DISPLAY_Y + 37 * VGM_GRID_H;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class StdSelect: VGM_ctrlButtonInvisible
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDSELECT;
            onButtonClick = VGM_UIEH(stdselect,Abilities);
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 17 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 25 * VGM_GRID_H;
        };
        class StdCooldown: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDCOOLDOWN;
            text = "Cooldown:";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 43 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };

        class UltInfo: StdInfo
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTINFO;
            text = "Ultimate Ability (i)";
            y = DISPLAY_Y + 56 * VGM_GRID_H;
        };
        class UltName: StdName
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTNAME;
            y = DISPLAY_Y + 62 * VGM_GRID_H;
        };
        class Ult: Std
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULT;
            y = DISPLAY_Y + 68 * VGM_GRID_H;
        };
        class UltCooldownTime: StdCooldownTime
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTCOOLDOWNTIME;
            y = DISPLAY_Y + 88 * VGM_GRID_H;
        };
        class UltSelect: StdSelect
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTSELECT;
            onButtonClick = VGM_UIEH(ultselect,Abilities);
            y = DISPLAY_Y + 68 * VGM_GRID_H;
        };
        class UltCooldown: StdCooldown
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTCOOLDOWN;
            y = DISPLAY_Y + 94 * VGM_GRID_H;
        };

        class AvailableText: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_AVAILABLETEXT;
            text = "Select an ability to the left to start.";
            x = DISPLAY_X + (COLUMN_W + 6) * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
        class Available: VGM_ctrlControlsTable
        {
            idc = VGM_IDC_DISPLAYABILITIES_AVAILABLE;
            rowHeight = 15 * VGM_GRID_H;
            lineSpacing = 1 * VGM_GRID_H;
            x = DISPLAY_X + (COLUMN_W + 6) * VGM_GRID_W;
            y = DISPLAY_Y + 13 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 14) * VGM_GRID_H;
            class RowTemplate
            {
                class RowBackground
                {
                    controlBaseClassPath[] = {"VGM_ctrlBackground"};
                    columnX = 1 * VGM_GRID_W;
                    controlOffsetY = 0;
                    columnW = (COLUMN_W - 2) * VGM_GRID_W;
                    controlH = 15 * VGM_GRID_H;
                };
                class Title: RowBackground
                {
                    controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                    columnW = (COLUMN_W - 17) * VGM_GRID_W;
                };
                class Category: Title
                {
                    controlOffsetY = 5 * VGM_GRID_H;
                };
                class Icon: Title
                {
                    controlBaseClassPath[] = {"VGM_ctrlStaticPicture"};
                    columnX = (COLUMN_W - 16) * VGM_GRID_W;
                    columnW = 15 * VGM_GRID_W;
                    controlH = 15 * VGM_GRID_H;
                };
                class Equip: Title
                {
                    controlBaseClassPath[] = {"VGM_ctrlButton"};
                    controlOffsetY = 10 * VGM_GRID_H;
                };
            };
        };

        class DetailsFrame: VGM_ctrlStaticFrame
        {
            x = COLUMN3_X;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
        };
        class AbilityTitleFrame: DetailsFrame
        {
            h = 6 * VGM_GRID_H;
        };
        class AbilityTitle: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYTITLE;
            text = "//Ability Name";
            size = VGM_FONT_XL * VGM_GRID_H;
            x = COLUMN3_X;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 6 * VGM_GRID_H;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYDESCRIPTION;
            text = "// Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
            x = COLUMN3_X;
            y = DISPLAY_Y + 13 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 40 * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
        class Category: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYCATEGORY;
            text = "// Rifleman Ability";
            x = COLUMN3_X;
            y = DISPLAY_Y + 64 * VGM_GRID_H;
            w = (COLUMN_W - 22) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
        class Cooldown: Category
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYCOOLDOWN;
            text = "// X Seconds Cooldown";
            y = DISPLAY_Y + 69 * VGM_GRID_H;
        };
        class Icon: VGM_ctrlStaticPicture
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYICON;
            text = "#(argb,1,1,1)color(0,1,0,1)";
            x = COLUMN3_X + (COLUMN_W - 21) * VGM_GRID_W;
            y = DISPLAY_Y + 54 * VGM_GRID_H;
            w = 20 * VGM_GRID_W;
            h = 20 * VGM_GRID_H;
        };
        class Picture: VGM_ctrlStaticPicture
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYPICTURE;
            text = "#(argb,1,1,1)color(0,1,0,1)";
            x = COLUMN3_X + 20 * VGM_GRID_W;
            y = DISPLAY_Y + 75 * VGM_GRID_H;
            w = PICTURE_H * VGM_GRID_W;
            h = PICTURE_H * VGM_GRID_H;
        };
        class Equip: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYEQUIP;
            text = "Equip";
            x = COLUMN3_X + 5 * VGM_GRID_W;
            y = DISPLAY_Y + (DISPLAY_H - 12) * VGM_GRID_H;
            w = (COLUMN_W - 10) * VGM_GRID_W;
            h = 10 * VGM_GRID_H;
        };
    };
};

