#define _W 10
#define _H 14
#define _YTOP 7

class para_RscSurvivalCard: para_RscControlsGroupNoScrollbarHV
{
	idc = -1;
	w = UIW(_W);
	h = UIH(_H);
	class controls
	{
		class Background: para_RscPicture
		{
			idc = -1;
			text = "\vn\ui_f_vietnam\ui\backgrounds\survival_card.paa";
			colorText[] = {1,1,1,1};
			x = UIW(-2);
			y = 0;
			w = UIW(_H);
			h = UIH(_H);
		};
		class Content: para_RscStructuredText
		{
			idc = PARA_RSCSURVIVALHINTS_CONTENT_IDC;
			text = "<t size='1.3' align='center' font='RobotoCondensedBold'>TITLE<br/><t size='4' color='FFFFFF'><img image='\a3\ui_f\data\IGUI\RscTitles\HealthTextures\test_texture_2-1.paa'/></t></t><br/>Deserunt ullamco deserunt proident ex tempor cupidatat commodo labore duis officia voluptate officia. Consectetur laborum ex dolore adipisicing officia labore culpa elit in culpa dolore. Esse excepteur qui proident cillum officia velit anim aute incididunt ipsum est cillum nostrud ex. Dolor consectetur elit mollit ad enim nulla eiusmod. Amet est aute commodo amet dolor ut nulla officia velit. Non quis minim Lorem aliqua est. Excepteur eiusmod velit anim tempor occaecat dolore sint tempor cillum occaecat et magna Lorem esse.";
			x = UIW(0.1);
			y = UIH(0.1);
			w = UIW((_W - 0.2));
			h = UIH((_H - 2.6));
			class Attributes
			{
				font = "RobotoCondensed";
				color = "#000000";
				colorLink = "#D09B43";
				align = "left";
				shadow = 0;
			};
		};
		class BottomLabel: Content
		{
			idc = PARA_RSCSURVIVALHINTS_BOTTOMLABEL_IDC;
			text = "Press [8] to close.<br />Press 2x[8] to open in field manual.";
			y = UIH((_H - 2.3));
			h = UIH(2);
			class Attributes
			{
				font = "RobotoCondensed";
				color = "#000000";
				colorLink = "#D09B43";
				align = "center";
				shadow = 0;
			};
		};
	};
};