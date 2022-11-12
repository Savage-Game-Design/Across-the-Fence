
class para_infopanel_quick_base: para_RscControlsGroupNoScrollbarHV
{
	idc = -1;
	
	x = UIX_CR(10.5);
	y = UIY_CD(0);
	w = UIW(19.2);
	h = UIH(3);
	
	// onLoad = "(_this#0) ctrlSetFade 1; (_this#0) ctrlCommit 0;";
	
	class controls
	{
		class txt_main: para_RscStructuredText_r
		{
			idc = PARA_INFOPANEL_QUICK_TXT_IDC;
			
			x = 0;
			y = 0;
			w = UIW(19.2);
			h = UIH(3);
			
			size = TXT_XL;
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
	};
};