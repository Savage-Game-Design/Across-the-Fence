#define COLOR_RGBA255(RED,GREEN,BLUE,ALPHA) {RED/255,GREEN/255,BLUE/255,ALPHA/255}
#define COLOR_RGBA100(RED,GREEN,BLUE,ALPHA) {RED/255,GREEN/255,BLUE/255,ALPHA/100}

#define OVERLAY_TITLE_BACKGROUND_COLOR COLOR_RGBA100(255,255,255,50)
#define OVERLAY_TITLE_TEXT_COLOR COLOR_RGBA100(0,0,0,100)

#define USER_BACKGROUND_COLOR {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.77])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.51])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.08])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"}
#define USER_TEXT_COLOR {"(profilenamespace getvariable ['GUI_TitleText_RGB_R',1])","(profilenamespace getvariable ['GUI_TitleText_RGB_G',1])","(profilenamespace getvariable ['GUI_TitleText_RGB_B',1])","(profilenamespace getvariable ['GUI_TitleText_RGB_A',1])"}

// #define OVERLAY_ACTION_BACKGROUND_COLOR COLOR_RGBA100(36,183,56,75)
// #define OVERLAY_ACTION_TEXT_COLOR COLOR_RGBA100(255,255,255,100)
#define OVERLAY_ACTION_BACKGROUND_COLOR USER_BACKGROUND_COLOR
#define OVERLAY_ACTION_TEXT_COLOR USER_TEXT_COLOR

class para_Overlay_RscText: para_RscText
{
    idc = -1;
	font = "RobotoCondensed";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
    text = "";
};

class para_Overlay_RscStructuredText: para_RscStructuredText
{
    idc = -1;
	class Attributes
	{
		font = "RobotoCondensed";
		color = "#ffffff";
		colorLink = "#D09B43";
		align = "left";
		shadow = 0;
	};
    text = "";
	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
};

class para_Overlay_Title_Background: para_Overlay_RscText
{
    colorBackground[] = OVERLAY_TITLE_BACKGROUND_COLOR;
	colorText[] = OVERLAY_TITLE_TEXT_COLOR;
};

class para_Overlay_Text_Background: para_Overlay_RscText
{
    colorBackground[] = {0,0,0,0.5};
	colorText[] = OVERLAY_ACTION_TEXT_COLOR;
};

class para_Overlay_StructuredText_Background: para_Overlay_RscStructuredText
{
    colorBackground[] = {0,0,0,0.5};
	colorText[] = OVERLAY_ACTION_TEXT_COLOR;
};