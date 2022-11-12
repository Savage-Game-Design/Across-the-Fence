#define _W 10
#define _H 14
#define _YTOP 7
class para_RscSurvivalHints
{
	idd = -1;
	duration = 1e+6;
	fadeIn = 0;
	fadeOut = 0;
	onLoad = "[""onLoad"", _this, ""para_RscSurvivalHints""] call para_c_fnc_ui_initMissionDisplay";
	onUnload = "[""onUnload"", _this, ""para_RscSurvivalHints""] call para_c_fnc_ui_initMissionDisplay";
	class Controls
	{
		class SurvivalCardTop: para_RscSurvivalCard
		{
			// Hide this by default, we manually create cards
			show = 0;
			idc = PARA_RSCSURVIVALHINTS_CARD1_IDC;
			x = UIX_RL((_W + 0.1));
			y = UIY_TD((_YTOP + 2));
		};
		//--- This is for some reason the right order...
		class SurvivalCardBottom: SurvivalCardTop
		{
			idc = PARA_RSCSURVIVALHINTS_CARD3_IDC;
			y = UIY_TD(_YTOP);
		};
		class SurvivalCardMiddle: SurvivalCardTop
		{
			idc = PARA_RSCSURVIVALHINTS_CARD2_IDC;
			y = UIY_TD((_YTOP + 1));
		};
	};
};
#undef _W
#undef _H
#undef _YTOP
