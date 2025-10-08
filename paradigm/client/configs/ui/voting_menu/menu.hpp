class para_VotingMenu
{
	idd = 16224;
	onLoad = "uiNamespace setVariable ['#para_c_VoteMenu', (_this#0)]; call para_c_fnc_loadVotingMenu;";
	class Controls
	{
		class Paper: para_RscPicture
		{
			idc = -1;
			text = "\vn\ui_f_vietnam\ui\taskroster\img\Exports_Paper_1.paa";
			x = QUOTE(UIX_CL((17.5 / 2)));
			y = QUOTE(UIY_CU((22 / 2)));
			w = QUOTE(UIW(17.5));
			h = QUOTE(UIH(22));
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			colorActive[] = {1,1,1,1};
		};
		class Title: para_RscText
		{
			idc = -1;
			x = QUOTE(UIX(14));
			y = QUOTE(UIY(4));
			w = QUOTE(UIW(15));
			h = QUOTE(UIH(2));
			style = 0;
			colorText[] = { 0,0,0,1 };
			onLoad = "uiNamespace setVariable ['#para_c_VoteMenu_TitleControl', (_this#0)]";
			sizeEx = QUOTE(TXT_M);
			text = "Title";
		};
		class Body: para_RscStructuredText
		{
			idc = -1;
			x = QUOTE(UIX(14));
			y = QUOTE(UIY(5.5));
			w = QUOTE(UIW(13));
			h = QUOTE(UIH(3));
			style = 0;
			onLoad = "uiNamespace setVariable ['#para_c_VoteMenu_Body', (_this#0)]";
			size = QUOTE(TXT_S);
			class Attributes
			{
				color = "#404040";
				shadow = 0;
			};
		};
		class OptionText: Title
		{
			y = QUOTE(UIY(8.6));
			text = "$STR_vn_mf_voteMenu_selectOption";
			sizeEx = QUOTE(TXT_S);
			onLoad = "";
		};
		class OptionsTable: para_RscListBox
		{
			idc = -1;
			x = QUOTE(UIX(14));
			y = QUOTE(UIY(10.3));
			w = QUOTE(UIW(13));
			h = QUOTE(UIH(6));
			onLoad = "uiNamespace setVariable ['#para_c_VoteMenu_Options', (_this#0)]";
			colorBackground[] = { 0,0,0,0 };
			colorSelectBackground[] = { 0,0,0,0 };
			colorSelectBackground2[] = { 0,0,0,0 };
			colorText[] = { 0,0,0,1 };
			colorSelect[] = { 0,0,0,1 };
			colorSelect2[] = { 0,0,0,1 };
		};
		class Vote: para_RscButton
		{
			onLoad = "uiNamespace setVariable ['#para_c_VoteMenu_Vote', (_this#0)]";
			x = QUOTE(UIX(14));
			y = QUOTE(UIY(16.4));
			w = QUOTE(UIW(13));
			h = QUOTE(UIH(1));
			text = "$STR_vn_mf_voteMenu_submitVote";
			colorText[] = { 1,0,0,1 };
		};
	};
};
