class para_InteractionOverlay_RscText: para_RscText
{
	font = "RobotoCondensed";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
};

class para_InteractionOverlay_RscStructuredText: para_RscStructuredText
{
	class Attributes
	{
		font = "RobotoCondensed";
		color = "#ffffff";
		colorLink = "#D09B43";
		align = "left";
		shadow = 0;
	};
	size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	shadow = 0;
};

class para_InteractionOverlay
{
	idd = 1200;
	fadein = 0;
	fadeout = 10000;
	duration = 10000;
	class Controls
	{
		class Holder: para_RscControlsGroupNoScrollbarHV
		{
			idc = -1;
			x = 0;
			y = 0;
			w = UIW(21);
			h = UIH(10);
			onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_Main', (_this#0)];";
			class Controls
			{
				class Title: para_RscControlsGroupNoScrollbarHV
				{
					idc = -1;
					x = 0;
					y = 0;
					w = 0;
					h = UIH(1);
					onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_Title', (_this#0)];";
					class Controls
					{
						class Background: para_InteractionOverlay_RscText
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(1);
							colorBackground[] = OVERLAY_TITLE_BACKGROUND_COLOR;
							text = "";
						};
						class Icon: para_RscPicture
						{
							idc = -1;
							x = UIH(0.1);
							y = UIH(0.1);
							w = UIH(0.8) * (3 / 4);
							h = UIH(0.8);
							colorText[] = OVERLAY_TITLE_TEXT_COLOR;
							text = "";
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_TitleIcon', (_this#0)];";
						};
						class Text: para_InteractionOverlay_RscText
						{
							idc = -1;
							x = UIH(1) * (3 / 4);
							y = 0;
							w = UIW(13);
							h = UIH(1);
							colorText[] = OVERLAY_TITLE_TEXT_COLOR;
							text = "";
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_TitleText', (_this#0)];";
						};
						class Threshold: para_InteractionOverlay_RscText
						{
							idc = -1;
							style = 2;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(1);
							colorText[] = OVERLAY_ACTION_BACKGROUND_COLOR;
							text = "";
							sizeEx = TXT_CST(0.8);
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_TitleThreshold', (_this#0)];";
						};
					};
				};
				class Action: para_RscControlsGroupNoScrollbarHV
				{
					idc = -1;
					x = UIW(14);
					y = 0;
					w = UIW(7);
					h = 0;
					onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_Action', (_this#0)];";
					class Controls
					{
						class Background: para_InteractionOverlay_RscText
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(1);
							colorBackground[] = OVERLAY_ACTION_BACKGROUND_COLOR;
							text = "";
						};
						#define MODIFIER_OFFSET (UIH(0.8) * (3 / 4) * 3 + UIH(0.1))
						class InteractionKey: para_RscControlsGroupNoScrollbarHV
						{
							idc = -1;
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_InteractionKey', (_this#0)];";
							x = 0;
							y = 0;
							w = UIH(1) * (3 / 4);
							h = UIH(1);
							class Controls
							{
								class Modifier: para_RscControlsGroupNoScrollbarHV
								{
									idc = -1;
									x = UIH(0.1) - MODIFIER_OFFSET;
									y = UIH(0.15) * (3 / 4);
									w = UIH(0.8) * (3 / 4) * 3;
									h = UIH(0.8);
									onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_InteractionKeyModifierGroup', (_this#0)];";
									class Controls
									{
										class Icon: para_RscPicture
										{
											idc = -1;
											x = 0;
											y = 0;
											w = UIH(0.8) * (3 / 4) * 3;
											h = UIH(0.8);
											text = "\vn\ui_f_vietnam\ui\interactionOverlay\vn_ico_mf_hud_key_long_ca.paa";
										};
										class Key: para_InteractionOverlay_RscText
										{
											idc = -1;
											style = 2;
											x = 0;
											y = 0;
											w = UIH(0.8) * (3 / 4) * 3;
											h = UIH(0.8);
											colorText[] = {0,0,0,1};
											onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_InteractionModifierName', (_this#0)];";
											text = "";
										};
									};
								};
								class Key: para_RscControlsGroupNoScrollbarHV
								{
									idc = -1;
									x = UIH(0.1);
									y = UIH(0.15) * (3 / 4);
									w = UIH(0.8) * (3 / 4);
									h = UIH(0.8);
									onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_InteractionKeyKeyGroup', (_this#0)];";
									class Controls
									{
										class Icon: para_RscPicture
										{
											idc = -1;
											x = 0;
											y = 0;
											w = UIH(0.8) * (3 / 4);
											h = UIH(0.8);
											text = "\vn\ui_f_vietnam\ui\interactionOverlay\vn_ico_mf_hud_key_ca.paa";
										};
										class Key: para_InteractionOverlay_RscText
										{
											idc = -1;
											style = 2;
											x = 0;
											y = 0;
											w = UIH(0.8) * (3 / 4);
											h = UIH(0.8);
											colorText[] = {0,0,0,1};
											onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_InteractionKeyName', (_this#0)];";
											text = "";
										};
									};
								};
							};
						};
						class Text: para_InteractionOverlay_RscText
						{
							idc = -1;
							style = 0;
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_ActionText', (_this#0)];";
							x = UIH(1) * (3 / 4) + UIH(0.1);
							y = 0;
							w = UIW(20.7);
							h = UIH(1);
							text = $STR_vn_mf_hud_interact;
							colorText[] = OVERLAY_ACTION_TEXT_COLOR;
						};
					};
				};
				class Progress: para_RscControlsGroupNoScrollbarHV
				{
					idc = -1;
					x = 0;
					y = UIH(1);
					w = 0;
					h = UIH(0.2);
					onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_Progress', (_this#0)];";
					class Controls
					{
						class Background: para_InteractionOverlay_RscText
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(0.2);
							colorBackground[] = {0,0,0,0.5};
							// colorBackground[] = { 1, 1, 1, 0.5};
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_ProgressBackground', (_this#0)];";
							text = "";
						};
						class Threshold: para_RscStatProgressHUD
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(0.2);
							colorBar[] = { 1, 1, 1, 0.5 };
							onLoad = "(_this#0) progressSetPosition 0.75; uiNamespace setVariable ['#para_InteractionOverlay_ProgressThreshold', (_this#0)];";
						};
						class Bar: para_RscStatProgressHUD
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = UIH(0.2);
							colorBar[] = OVERLAY_ACTION_BACKGROUND_COLOR;
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_ProgressBar', (_this#0)];";
						};
					};
				};
				class Body: para_RscControlsGroupNoScrollbarHV
				{
					idc = -1;
					x = 0;
					y = UIH(1);
					w = 0;
					h = 0;
					onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_Body', (_this#0)];";
					class Controls
					{
						class Background: para_InteractionOverlay_RscText
						{
							idc = -1;
							x = 0;
							y = 0;
							w = UIW(21);
							h = 0;
							colorBackground[] = {0,0,0,0.5};
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_BodyBackground', (_this#0)];";
							text = "";
						};
						class Text: para_InteractionOverlay_RscStructuredText
						{
							idc = -1;
							x = 0;
							y = UIH(0.3);
							w = UIW(21);
							h = 0;
							colorText[] = {1,1,1,1};
							colorBackground[] = {0,0,0,0};
							onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_BodyText', (_this#0)];";
							text = "";
							size = TXT_CST(0.8);
						};
					};
				};
			};
		};
	};
};

class para_InteractionOverlay_state
{
	idd = 23793;
	fadein = 0;
	fadeout = 10000;
	duration = 10000;
	class Controls
	{
		#define PARA_IO_STATE_ICON_SIZE 1.5
		class Icon: para_RscPicture
		{
			idc = -1;
			x = safeZoneX + safeZoneW - (UIH(PARA_IO_STATE_ICON_SIZE) * (3 / 4)) - UIW(0.5);
			y = ((safeZoneY + safeZoneH) / 2) * 1.15; // Yeah I don't know why I chose to do a multiplication here but whatever
			w = UIH(PARA_IO_STATE_ICON_SIZE) * (3 / 4);
			h = UIH(PARA_IO_STATE_ICON_SIZE);
			colorText[] = { 1, 1, 1, 0.5 };
			text = "\vn\ui_f_vietnam\ui\interactionOverlay\hud-on.paa";
			onLoad = "uiNamespace setVariable ['#para_InteractionOverlay_state_Icon', (_this#0)];";
		};
	};
};
