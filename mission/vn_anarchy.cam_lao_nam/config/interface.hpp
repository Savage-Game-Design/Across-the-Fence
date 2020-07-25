class RscProgress
{
	type = 8;
	x=0.34400001;
	y=0.61900002;
	w=0.3137255;
	h=0.0261438;
	shadow=2;
	texture="#(argb,8,8,3)color(1,1,1,1)";
	colorFrame[] = {0,0,0,1};
	colorBar[] = {1,1,1,1};
};
class RscStatProgress : RscProgress
{
	style = 1;
	colorFrame[] = {0,0,0,1};
	colorBar[] = {1,1,1,1};
	texture = "#(argb,8,8,3)color(1,1,1,1)";
	x = 0;
	y = 0;
	w = 1;
	h = 1;
};
// custom UI stuff for armor stats
class RscCustomProgress : RscProgress
{
	style = 0;
	texture = "";
	textureExt = "";
	colorBar[] = { 0.9, 0.9, 0.9, 0.9 };
	colorExtBar[] = { 1, 1, 1, 1 };
	colorFrame[] = { 1, 1, 1, 1 };
	x = "0 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
	y = "16 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	w = "26 * 			(			((safezoneW / safezoneH) min 1.2) / 40)";
	h = "1 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
	colorBackground[] = { 1, 1, 1, 0.75 };
};
class RscTotalArmorProgress : RscProgress
{
	style = 0;
	texture = "";
	textureExt = "";
	colorBar[] = { 0.9, 0.9, 0.9, 0.9 };
	colorExtBar[] = { 1, 1, 1, 1 };
	colorFrame[] = { 1, 1, 1, 1 };
	x = "1.5 * 					(			((safezoneW / safezoneH) min 1.2) / 40) + 		(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)";
	y = "22.5 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + 		(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)";
	w = "11 * 					(			((safezoneW / safezoneH) min 1.2) / 40)";
	h = "1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
};
class ScrollBar
{
	color[]={1,1,1,0.60000002};
	colorActive[]={1,1,1,1};
	colorDisabled[]={1,1,1,0.30000001};
	thumb="\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
	arrowEmpty="\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
	arrowFull="\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
	border="\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	shadow=0;
	scrollSpeed=0.059999999;
	width=0;
	height=0;
	autoScrollEnabled=0;
	autoScrollSpeed=-1;
	autoScrollDelay=5;
	autoScrollRewind=0;
};
class RscListBox
{
	x=0;
	y=0;
	w=0.30000001;
	h=0.30000001;
	style=16;
	font="VeteranTypewriter";
	sizeEx="(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow=0;
	colorShadow[]={0,0,0,0.5};
	colorText[]={1,1,1,1};
	colorDisabled[]={1,1,1,0.25};
	colorScrollbar[]={1,0,0,0};
	colorSelect[]={0,0,0,1};
	colorSelect2[]={0,0,0,1};
	colorSelectBackground[]={0.94999999,0.94999999,0.94999999,1};
	colorSelectBackground2[]={1,1,1,0.5};
	period=1.2;
	colorBackground[]={0,0,0,0.30000001};
	maxHistoryDelay=1;
	colorPicture[]={1,1,1,1};
	colorPictureSelected[]={1,1,1,1};
	colorPictureDisabled[]={1,1,1,0.25};
	colorPictureRight[]={1,1,1,1};
	colorPictureRightSelected[]={1,1,1,1};
	colorPictureRightDisabled[]={1,1,1,0.25};
	colorTextRight[]={1,1,1,1};
	colorSelectRight[]={0,0,0,1};
	colorSelect2Right[]={0,0,0,1};
	tooltipColorText[]={1,1,1,1};
	tooltipColorBox[]={1,1,1,1};
	tooltipColorShade[]={0,0,0,0.64999998};
	soundSelect[]=
	{
		"\A3\ui_f\data\sound\RscListbox\soundSelect",
		0.090000004,
		1
	};
	class ListScrollBar: ScrollBar
	{
		color[]={1,1,1,1};
		autoScrollEnabled=1;
	};
};
class RscButton
{
	idc=-1;
	style=2;
	x=0;
	y=0;
	w=0.095588997;
	h=0.039216001;
	shadow=2;
	font="VeteranTypewriter";
	sizeEx="(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	url="";
	colorText[]={1,1,1,1};
	colorDisabled[]={1,1,1,0.25};
	colorBackground[]={0,0,0,0.5};
	colorBackgroundActive[]={0,0,0,1};
	colorBackgroundDisabled[]={0,0,0,0.5};
	colorFocused[]={0,0,0,1};
	colorShadow[]={0,0,0,0};
	offsetX=0;
	offsetY=0;
	offsetPressedX=0;
	offsetPressedY=0;
	colorBorder[]={0,0,0,1};
	borderSize=0;
	soundEnter[]=
	{
		"\A3\ui_f\data\sound\RscButton\soundEnter",
		0.090000004,
		1
	};
	soundPush[]=
	{
		"\A3\ui_f\data\sound\RscButton\soundPush",
		0.090000004,
		1
	};
	soundClick[]=
	{
		"\A3\ui_f\data\sound\RscButton\soundClick",
		0.090000004,
		1
	};
	soundEscape[]=
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.090000004,
		1
	};
};
class RscText
{
	type = 0;
	x=0;
	y=0;
	h=0.037;
	w=0.30000001;
	style=0;
	shadow=1;
	colorShadow[]={0,0,0,0.5};
	font="VeteranTypewriter";
	SizeEx="(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	colorText[]={1,1,1,1};
	colorBackground[]={0,0,0,0};
	linespacing=1;
	tooltipColorText[]={1,1,1,1};
	tooltipColorBox[]={1,1,1,1};
	tooltipColorShade[]={0,0,0,0.64999998};
};
class RscPicture
{
	type = 0;
	access=0;
	idc=-1;
	style=48;
	colorBackground[]={0,0,0,0};
	colorText[]={1,1,1,1};
	font="VeteranTypewriter";
	sizeEx=0;
	lineSpacing=0;
	text="";
};
class RscVignette: RscPicture
{
	x="safezoneXAbs";
	y="safezoneY";
	w="safezoneWAbs";
	h="safezoneH";
	text="\A3\ui_f\data\gui\rsccommon\rscvignette\vignette_gs.paa";
	colortext[]={0,0,0,0.30000001};
};
class RscStructuredText
{
	x=0;
	y=0;
	h=0.035;
	w=0.1;
	text="";
	size="(			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	colorText[]={1,1,1,1};
	shadow=1;
	font="VeteranTypewriter";
	type = 13;  // defined constant
	style = 2;            // defined constant
	colorBackground[] = { 0, 0, 0, 0 };
	class Attributes
	{
		font="VeteranTypewriter";
		color="#ffffff";
		colorLink="#D09B43";
		align="left";
		shadow=1;
	};
};
class RscProgressNotFreeze
{
	idc = -1;
	type = 45;
	style = 0;
	x = 0.022059;
	y = 0.911772;
	w = 0.029412;
	h = 0.039216;
	texture = "#(argb,8,8,3)color(0,0,0,0)";
};





// loading screen
class MikeForce_loadingScreen
{
	idd = -1;
	onLoad = "uiNamespace setVariable ['vn_an_loadingScreen',_this select 0]";
	onUnload = "uiNamespace setVariable ['vn_an_loadingScreen',displayNull]";
	duration = 10e10;
	fadein = 0;
	fadeout = 0;
	name = "loading screen";
	class controls
	{
		class LoadingProgress: RscProgress
		{
			style = 0;
			idc = 104; // progress bar, has to have idc 104
			colorBar[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])","(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"};
			texture = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.295761 * safezoneW + safezoneX;
			y = 0.9 * safezoneH + safezoneY;
			w = 0.408477 * safezoneW;
			h = 0.0066 * safezoneH;
		};
		class LoadingText: RscStructuredText
		{
			idc = 5050;
			text = "";
			class Attributes
			{
				size = "0.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
				align = "center";
			};
			x = 0.314328 * safezoneW + safezoneX;
			y = 0.80 * safezoneH + safezoneY;
			w = 0.350767 * safezoneW;
			h = 0.0396 * safezoneH;
			sizeEx = "0.8 *((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
		};
	};
	class controlsBackground
	{
		class Black: RscText
		{
			idc = 5001;
			text = "";
			colorBackground[] = {0,0,0,1};
			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";
		};

		class Overlay: RscPicture
		{
			idc = 5002;
			style = 48 + 0x800;
			text="\vn\objects_f_vietnam\civ\signs\data\billboards\vn_ui_billboard_01_ca.paa";
			colorText[] = {1,1,1,0.8};
			x = "safezoneX";
			y = "safezoneY";
			w = "safezoneW";
			h = "safezoneH";
		};
	};

};
