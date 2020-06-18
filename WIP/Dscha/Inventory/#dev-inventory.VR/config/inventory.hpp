#define TILES_X 6	//fixed width of 6
#define TILES_Y 16
#define WIDTH 8		//width of complete inventory slots
#define HEIGHT ((WIDTH / 6) * TILES_Y)
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
	w = UIW((WIDTH*6));
	h = UIH((HEIGHT*3));
	
	onMouseZChanged = "_this call vn_an_fnc_list_move;";

	class controls
	{
		class bg: vn_RscText	//ToDo: Exchange with Picture + frame + color frame depending on rarity
		{
			idc = 100;
			
			x = 0;
			y = 0;
			w = 0;	//Will be defined in function
			h = 0;	//Will be defined in function
			
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
			w = 0;	//Will be defined in function
			h = 0;	//Will be defined in function
			
			text = "data\gun.paa";
			// text = "data\box_ratio_2x1.paa";
			
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
	movingEnabled = 0;
	enableSimulation = 1;
	
	onLoad = "[""onLoad"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay'); vn_an_fnc_inventory_init = compile preprocessFileLineNumbers ""fnc\inventory.sqf""; _this call vn_an_fnc_inventory_init;";
	onUnload = "[""onUnload"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay');";
	
	onMouseButtonDown	= "_this call vn_an_fnc_mpos;";
	onMouseButtonUp		= "";
	
	
	class controlsBackground
	{
	};
	
	class Controls
	{
		class grid_personal: vn_RscControlsGroupNoScrollbarHV
		{
			idc = 1000;
			
			x = UIX_RL(30);
			y = UIY_TD(10);
			w = UIW(WIDTH);
			h = UIH(HEIGHT);
			
			onMouseZChanged = "_this call vn_an_fnc_list_move;";
	
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