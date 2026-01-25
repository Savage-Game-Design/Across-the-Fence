// Largely copied from vn_displayartillery in the main CDLC, then adapted for VGM.
class VGM_DisplayRadioOperator
{
	idd = -1;
	enablesimulation = 1;
	enabledisplay = 1;
	onLoad = VGM_UIEH(onLoad,RadioOperator);
	onUnload = VGM_UIEH(onUnload,RadioOperator);
	class controlsBackground
	{
		class Radio_CA: ctrlStaticPicture
		{
			text = "\vn\modules_f_vietnam\data\Radio\radio_ca.paa";
			x = CENTER_X - 70 * VGM_GRID_W;
			y = CENTER_Y - 75 * VGM_GRID_H;
			w = 200 * VGM_GRID_W;
			h = 100 * VGM_GRID_H;
		};
	};
	class controls
	{
		class RadioGroup: ctrlControlsGroupNoScrollbars
		{
			idc = -1;
			x = CENTER_X - 70 * VGM_GRID_W;
			y = CENTER_Y - 75 * VGM_GRID_H;
			w = 200 * VGM_GRID_W;
			h = 60 * VGM_GRID_H;
			class controls
			{
				class BandDial: ctrlStaticPicture
				{
					text = "\vn\modules_f_vietnam\data\Radio\dial_3_ca.paa";
					angle = 90;
					color[] = {0.8,0.8,0.8,1};
					colorActive[] = {1,1,1,1};
					colorDisabled[] = {1,1,1,1};
					x = 33 * VGM_GRID_W;
					y = 40 * VGM_GRID_H;
					w = 16 * VGM_GRID_W;
					h = 16 * VGM_GRID_H;
				};
				#define INVISIBLE {0,0,0,0}
				class BandDialButton: ctrlButton
				{
					idc = -1;
					x = 33 * VGM_GRID_W;
					y = 40 * VGM_GRID_H;
					w = 16 * VGM_GRID_W;
					h = 16 * VGM_GRID_H;
					colorBackground[] = INVISIBLE;
					colorBackgroundDisabled[] = INVISIBLE;
					colorBackgroundActive[] = INVISIBLE;
					colorFocused[] = INVISIBLE;
					colorDisabled[] = INVISIBLE;
					colorText[] = INVISIBLE;
				};
				#undef INVISIBLE
				class PresetLDial: BandDial
				{
					text = "\vn\modules_f_vietnam\data\Radio\dial_1_ca.paa";
					onload = "uiNamespace setVariable ['VGM_DisplayRadioOperator_modeDial',(_this#0)]";
					x = 53.5 * VGM_GRID_W;
					y = 31 * VGM_GRID_H;
					w = 14 * VGM_GRID_W;
					h = 14 * VGM_GRID_H;
				};
				class PresetLDialButton: BandDialButton
				{
					idc = -1;
					x = 53.5 * VGM_GRID_W;
					y = 31 * VGM_GRID_H;
					w = 14 * VGM_GRID_W;
					h = 14 * VGM_GRID_H;
					onButtonClick = VGM_UIEH(radio:type,RadioOperator);
				};
				class PresetRDial: PresetLDial
				{
					onload = "";
					x = 90 * VGM_GRID_W;
				};
				class PresetRDialButton: PresetLDialButton
				{
					x = 90 * VGM_GRID_W;
					onButtonClick = "";
				};
				class VolumeDial: BandDial
				{
					text = "\vn\modules_f_vietnam\data\Radio\dial_2_ca.paa";
					x = 120 * VGM_GRID_W;
					y = 26.5 * VGM_GRID_H;
					w = 13 * VGM_GRID_W;
					h = 13 * VGM_GRID_H;
				};
				class VolumeDialButton: BandDialButton
				{
					x = 120 * VGM_GRID_W;
					y = 26.5 * VGM_GRID_H;
					w = 13 * VGM_GRID_W;
					h = 13 * VGM_GRID_H;
				};
				class SettingDial: BandDial
				{
					x = 118 * VGM_GRID_W;
					y = 43.5 * VGM_GRID_H;
					w = 16 * VGM_GRID_W;
					h = 16 * VGM_GRID_H;
				};
				class SettingDialButton: BandDialButton
				{
					x = 118 * VGM_GRID_W;
					y = 43.5 * VGM_GRID_H;
					w = 16 * VGM_GRID_W;
					h = 16 * VGM_GRID_H;
				};
			};
		};
		#define _W 200
		class MapFolder: ctrlStaticPictureKeepAspect
		{
			text = "\vn\modules_f_vietnam\data\vn_displayartillery\mapfolder.paa";
			x = CENTER_X - 0.5 * _W * VGM_GRID_W;
			y = CENTER_Y - 10 * VGM_GRID_H;
			w = _W * VGM_GRID_W;
			h = 0.5 * _W * VGM_GRID_H;
		};
		#undef _W
		class map_selection: ctrlMap
		{
			idc = 7001;
			x = CENTER_X + 13 * VGM_GRID_W;
			y = CENTER_Y + 1 * VGM_GRID_H;
			w = 73 * VGM_GRID_W;
			h = 75 * VGM_GRID_H;
			showCountourInterval = 0;
			class task
			{
				icon = "#(argb,8,8,3)color(0,0,0,0)";
				iconCreated = "#(argb,8,8,3)color(0,0,0,0)";
				iconCanceled = "#(argb,8,8,3)color(0,0,0,0)";
				iconDone = "#(argb,8,8,3)color(0,0,0,0)";
				iconFailed = "#(argb,8,8,3)color(0,0,0,0)";
				color[] = {0, 0, 0, 0};
				colorCreated[] = {0, 0, 0, 0};
				colorCanceled[] = {0, 0, 0, 0};
				colorDone[] = {0, 0, 0, 0};
				colorFailed[] = {0, 0, 0, 0};
				size = 0;
			};
			class custommark
			{
				icon = "#(argb,8,8,3)color(0,0,0,0)";
				color[] = {0, 0, 0, 0};
				size = 0;
				coefMax = 4;
				coefMin = 0.25;
				importance = 0;
			};
			class hospital: custommark {};
			class church: custommark {};
			class lighthouse: custommark {};
			class power: custommark {};
			class powersolar: custommark {};
			class powerwave: custommark {};
			class powerwind: custommark {};
			class transmitter: custommark {};
			class watertower: custommark {};
			class Cross: custommark {};
			class Chapel: custommark {};
			class tourism: custommark {};
			class biewtower: custommark {};
			class busstop: custommark {};
			class fuelstation: custommark {};
			class rock: custommark {};
			class smalltree: custommark {};
			class bush: custommark {};
			class fortress: custommark {};
			class fountain: custommark {};
			class quay: custommark {};
			class ruin: custommark {};
			class shipwreck: custommark {};
			class bunker: custommark {};
			class stack: custommark {};
		};
		class NotepadContent: VGM_ctrlControlsGroupNoScrollbars
		{
			x = CENTER_X - 84 * VGM_GRID_W;
			y = CENTER_Y + 2.5 * VGM_GRID_H;
			w = 74 * VGM_GRID_W;
			h = 75 * VGM_GRID_H;
			class controls
			{
				class Title: ctrlStructuredText
				{
					idc = 350;
					text = $STR_VGM_RTO_NO_AIRCRAFT_ON_STATION;
					x = 0;
					y = 0;
					w = 75 * VGM_GRID_W;
					h = 5 * VGM_GRID_H;
					size = 5 * VGM_GRID_H;
					shadow = 0;
					class Attributes
					{
						align = "center";
						color = "#000000";
						colorLink = "#D09B43";
						size = 0.75;
						font = USEDFONT;
					};
				};
				class Assets: ctrlListbox
				{
					idc = 103;
					x = 0 * VGM_GRID_W;
					y = 7.5 * VGM_GRID_H;
					w = 36.5 * VGM_GRID_W;
					h = 38.5 * VGM_GRID_H;
					sizeEx = 3 * VGM_GRID_H;
					font = USEDFONT;
					colorBackground[] = {0,0,0,0};
					colorText[] = {0,0,0,1};
					shadow = 0;
				};
				class Commands: Assets
				{
					idc = 102;
					x = 36 * VGM_GRID_W;
					w = 38 * VGM_GRID_W;
					h = 34.5 * VGM_GRID_H;
					sizeEx = 3 * VGM_GRID_H;
				};
				class UsesRemaining: ctrlStructuredText
				{
					idc = 104;
                    text = "";
					x = 0.5 * VGM_GRID_W;
					y = 50.25 * VGM_GRID_H;
					w = 35 * VGM_GRID_W;
					h = 5 * VGM_GRID_H;
					font = USEDFONT;
					size = 5 * VGM_GRID_H;
					class Attributes
					{
						align = "center";
						color = "#000000";
						colorLink = "#D09B43";
						size = 0.75;
						font = USEDFONT;
					};
				};
				class Request: ctrlButton
				{
					idc = 105;
					text = $STR_ARTILLERY_CONFIRM;
					font = USEDFONT;
					sizeEx = 5 * VGM_GRID_H;
					x = 36.5 * VGM_GRID_W;
					y = 49 * VGM_GRID_H;
					w = 37 * VGM_GRID_W;
					h = 5 * VGM_GRID_H;
				};
				class Summary: ctrlStructuredText
				{
					text = "This is a \n summary <br/> Of things";
					idc = 203;
					x = 0;
					y = 59.5 * VGM_GRID_H;
					w = 75 * VGM_GRID_W;
					h = 15 * VGM_GRID_H;
					size = 3 * VGM_GRID_H;
					shadow = 0;
					class Attributes
					{
						align = "left";
						color = "#000000";
						colorLink = "#D09B43";
						size = 1;
						font = USEDFONT;
					};
				};
			};
		};
	};
};
