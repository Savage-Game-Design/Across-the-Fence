

class para_infopanel
{
	idd = PARA_IDD_INFOPANEL;
	duration = 10e10;
	movingEnable = 0;
	fadein = 0;
	fadeout = 0;
	name = "para_infopanel";

	onLoad = "uiNamespace setVariable ['para_infopanel', (_this#0)];";
	onUnload = "uiNamespace setVariable ['para_infopanel', displayNull]";

	class controls
	{
		class para_infopanel_main: para_RscControlsGroupNoScrollbarHV
		{
			idc = PARA_INFOPANEL_MAIN_IDC;

			x = QUOTE(UIX_CL(9.6));
			y = QUOTE(UIY_BU(16));
			w = QUOTE(UIW(19.2));
			h = QUOTE(UIH(14.32));

			// onLoad = "(_this#0) ctrlSetFade 1; (_this#0) ctrlCommit 0;";

			class controls
			{
				class txt_main: para_RscStructuredText_c
				{
					idc = PARA_INFOPANEL_MAIN_TXT_IDC;

					x = QUOTE(0);
					y = QUOTE(UIH(11.82));
					w = QUOTE(UIW(19.2));
					h = QUOTE(UIH(3));

					size = QUOTE(TXT_XL);
					text = "";
					tooltip = "";
					class Attributes
					{
						align = "center";
						color = "#FFFFFF";
						colorLink = "#D09B43";
						font = USEDFONT;
						size = 1;
						shadow = 0;
					};
				};

				class img_main: para_RscPictureKeepAspect
				{
					idc = PARA_INFOPANEL_MAIN_IMG_IDC;

					x = QUOTE(UIW(6.4));
					y = QUOTE(0);
					w = QUOTE(UIW(6.4));
					h = QUOTE(UIH(11.32));

					text = "";
				};
			};
		};
	};
};
