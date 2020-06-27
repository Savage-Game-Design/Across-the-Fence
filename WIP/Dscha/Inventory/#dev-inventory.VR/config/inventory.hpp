#define TILES_X 8	//fixed width of 8
#define TILES_Y 16
#define WIDTH 8		//width of complete inventory slots
#define HEIGHT ((WIDTH / 8) * TILES_Y)
#define TILE_W (WIDTH/TILES_X)
#define TILE_H (HEIGHT/TILES_Y)


class tile_base: RscPicture
{
	idc = -1;
	type = 0;

	style = 48;	//normal Picture (stretching)
	// style = 48 + 2048;	//keepAspectRatio	-	NOT USED! Big wobble wobble
	
	x = 0;
	y = 0;
	w = UIW(TILE_W);
	h = UIH(TILE_H);
	
	colorText[] = {0,0,0,0.3};
	colorBackground[] = {1,1,1,1};
	
	sizeEx = TXT_M;
	font = USEDFONT;
	
	text = "data\box.paa";
};

class inv_icon: vn_RscControlsGroupNoScrollbarHV
{
	idc = 1000;
	
	x = 0;
	y = 0;
	w = UIW((WIDTH*8));
	h = UIH((HEIGHT*3));
	
	// onMouseButtonDown	= "";
	onMouseButtonUp		= "_this call vn_an_fnc_ui_inv_item_grab;";
	// onMouseButtonClick = "";	//Delay, not rly usable - Triggers while holding MB
	// onMouseButtonDblClick	= "";	//triggers immediately after 2nd MB-Down (before UP)
	
	class controls
	{
		class bg: vn_RscText	//ToDo: Exchange with Picture + frame + color frame depending on rarity
		{
			idc = 100;
			
			x = 0;
			y = 0;
			w = UIW(TILE_W);	//final size will be defined in function
			h = UIH(TILE_H);	//final size will be defined in function
			
			colorText[] = {0.1,0.1,0.1,0.9};
			colorBackground[] = {0,0,0.5,0.2};
			text = "";
			sizeEx = TXT_M;
		};
		
 		class icon: RscPicture
		{
			idc = 200;
			type = 0;
			style = 48;	//normal Picture (stretching)
			
			x = 0;
			y = 0;
			w = UIW(TILE_W);	//final size will be defined in function
			h = UIH(TILE_H);	//final size will be defined in function
			
			text = "";	//Will be defined in function
			
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,0};
			
			
			sizeEx = TXT_M;
			font = USEDFONT;
		};
	};
};


class vn_an_inventory
{
	idd = 1074;
	name = "vn_an_inventory";
	
	movingEnable = 0;
	enableSimulation = 1;
	
	onLoad = "[""onLoad"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay'); vn_an_fnc_ui_inv_init = compile preprocessFileLineNumbers ""fnc\fn_ui_inv_init.sqf""; _this call vn_an_fnc_ui_inv_init;";
	onUnload = "[""onUnload"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay');";
	
	onMouseButtonDown	= "";
	onMouseButtonUp		= "";
	// onMouseMoving = "";		//"USELESS" ON A DISPLAY! Doesn't return X and Y Pos, just "distance from xy to xy during specific time/FPS (??)"
	// onMouseZChanged = "";
	
	class controlsBackground
	{
		class bg: vn_RscText	//ToDo: Exchange with Picture + frame + color frame depending on rarity
		{
			idc = -1;
			
			x = safezoneX;
			y = safezoneY;
			w = safeZoneW;
			h = safeZoneH;
			
			colorText[] = {0.0,0.0,0.0,0.0};
			colorBackground[] = {0,0,0,0.1};
			text = "";
			sizeEx = TXT_M;
		};
	};
	
	class Controls
	{
		//scrollable
		class grid_area: vn_RscControlsGroupNoScrollbarH
		{
			idc = 1100;
			
			x = UIX_RL(30);
			y = UIY_TD(10);
			w = UIW(8.65);
			h = UIH(20);
			
			onLoad = "uinamespace setvariable [""vn_an_inv_player_area"", (_this#0)];";
			onUnload = "uinamespace setvariable [""vn_an_inv_player_area"", controlNull];";
			
			
			onMouseButtonDown	= "";
			onMouseButtonUp		= "";
			// onMouseMoving = "";
			// onMouseZChanged = "";
			
			class controls
			{
				//not "scrollable"
				class grid_personal: vn_RscControlsGroupNoScrollbarHV
				{
					idc = 1000;
					
					x = UIW(0);
					y = UIH(0);
					w = UIW(WIDTH);
					h = UIH(HEIGHT);
					
					onLoad = "uinamespace setvariable [""vn_an_inv_player"", (_this#0)];";
					onUnload = "uinamespace setvariable [""vn_an_inv_player"", controlNull];";
					
					onMouseButtonDown	= "";
					onMouseButtonUp		= "";
					// onMouseMoving = "systemchat str [""movement"",diag_tickTime, ctrlPosition (_this#0)]";		//BUGGED!
					// onMouseZChanged = "";	//not needed
					
					class controls
					{
						
						class bg: vn_RscText
						{
							idc = 99999;
							
							x = 0;
							y = 0;
							w = UIW(WIDTH);
							h = UIH(HEIGHT);
							
							colorText[] = {0.1,0.1,0.1,0.9};
							colorBackground[] = {0,0,0.5,0.4};
							text = "";
							sizeEx = TXT_M;
						};
					};
				};
			};
		};
		
		class grid_area_b: vn_RscControlsGroupNoScrollbarH
		{
			idc = 1101;
			
			x = UIX_LR(20);
			y = UIY_TD(10);
			w = UIW(8.65);
			h = UIH(20);
			
			
			onLoad = "uinamespace setvariable [""vn_an_inv_player_b_area"", (_this#0)];";
			onUnload = "uinamespace setvariable [""vn_an_inv_player_b_area"", controlNull];";
			
			
			onMouseButtonDown	= "";
			onMouseButtonUp		= "";
			// onMouseMoving = "";
			// onMouseZChanged = "";
			
			class controls
			{
				//not "scrollable"
				class grid_personal: vn_RscControlsGroupNoScrollbarHV
				{
					idc = 1001;
					
					x = UIW(0);
					y = UIH(0);
					w = UIW(WIDTH);
					h = UIH(HEIGHT);
					
					onLoad = "uinamespace setvariable [""vn_an_inv_player_b"", (_this#0)];";
					onUnload = "uinamespace setvariable [""vn_an_inv_player_b"", controlNull];";
					
					// onMouseButtonDown	= "_this call vn_an_fnc_ui_inv_mPos;";	//RESERVED: "grab" Item
					// onMouseButtonUp		= "";
					
					// onMouseMoving = "systemchat str [""movement"",diag_tickTime, ctrlPosition (_this#0)]";		//BUGGED!
					// onMouseZChanged = "";	//not needed
					
					class controls
					{
						
						class bg: vn_RscText
						{
							idc = 99999;
							
							x = 0;
							y = 0;
							w = UIW(WIDTH);
							h = UIH(HEIGHT);
							
							colorText[] = {0.1,0.1,0.1,0.9};
							colorBackground[] = {0,0,0.5,0.4};
							text = "";
							sizeEx = TXT_M;
						};
					};
				};
			};
		};
	};
};