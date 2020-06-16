#define TILES_X 6	//fixed width of 6
#define TILES_Y 11
#define WIDTH 8		//width of complete inventory slots
#define HEIGHT ((WIDTH / 6) * TILES_Y)
#define TILE_W (WIDTH/TILES_X)
#define TILE_H (HEIGHT/TILES_Y)


		// class tile_##POSX##_##POSY## tile_base
#define tile(POSX,POSY)\
		class tile_##POSY##_##POSX##: tile_base \
		{ \
			idc = POSY##POSX; \
			x = UIW((TILE_W*POSX)); \
			y = UIH((TILE_H*POSY)); \
		};

#define addRow(Y)\
		tile(0,Y) \
		tile(1,Y) \
		tile(2,Y) \
		tile(3,Y) \
		tile(4,Y) \
		tile(5,Y) \

class tile_base: RscPicture
{
	idc = -1;
	type = 0;
	style = 0x30;
	x = 0;
	y = 0;
	w = UIW(TILE_W);
	h = UIH(TILE_H);
	
	colorText[] = {0,0,0,0.3};
	colorBackground[] = {1,1,1,1};
	
	sizeEx = TXT_M;
	font = USEDFONT;
	
	text = "vn\ui_f_vietnam\ui\taskroster\img\box_unchecked.paa";
};

class vn_an_inventory
{
	idd = 1074;
	name = "vn_an_inventory";
	movingEnabled = 0;
	enableSimulation = 1;
	onLoad = "[""onLoad"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay'); vn_an_fnc_inventory_init = compile preprocessFileLineNumbers ""fnc\inventory.sqf""; _this call vn_an_fnc_inventory_init;";
	onUnload = "[""onUnload"",_this,""vn_an_inventory"",''] call 	(uinamespace getvariable 'BIS_fnc_initDisplay');";
	
	// onMouseZChanged		= "_this call vn_an_fnc_list_move;";
	onMouseButtonDown	= "_this call vn_an_fnc_mpos;";
	onMouseButtonUp		= "";
	
	class controlsBackground
	{
	};
	
	class Controls
	{
		class test: RscPicture
		{
			idc = 100;
			type = 0;
			style = 0x30;
			
			x = UIX_RL(10.0);
			y = UIY_TD(5.0);
			w = UIW(4);
			h = UIH(4);
			
			onMouseEnter = "systemChat str ['mouse Entered: ', _this];"
			onMouseExit = "systemChat str ['mouse Exited: ', _this];"
			
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
			text = "vn\ui_f_vietnam\ui\taskroster\img\missionTarget_prev.paa";
			sizeEx = TXT_M;
			font = USEDFONT;
		};
		class testb: test
		{
			idc = 101;
			y = UIY_TD(9.0);
		};
		
		class grid_personal: vn_RscControlsGroupNoScrollbarHV
		{
			idc = 1000;
			
			x = UIX_RL(30);
			y = UIY_TD(10);
			w = UIW(WIDTH);
			h = UIH(HEIGHT);
			// onLoad = "uiNamespace setVariable ['grid_personal', (_this#0)];";
			
			
			onMouseZChanged = "_this call vn_an_fnc_list_move;";
			// onMouseMoving = "systemchat str [_this];";
	
			class controls
			{
				
				//Icon Rows
				addRow(0)
				addRow(1)
				addRow(2)
				addRow(3)
				addRow(4)
				addRow(5)
				addRow(6)
				addRow(7)
				addRow(8)
				addRow(9)
				addRow(10)
				
				// class bg: vn_RscText
				class bg: vn_RscStructuredText
				{
					idc = -1;
					
					x = 0;
					y = 0;
					w = UIW(WIDTH);
					h = UIH(HEIGHT);
					
					colorText[] = {0.1,0.1,0.1,0.9};
					colorBackground[] = {0,0,0.5,0.4};
					text = "";
					sizeEx = TXT_M;
					
					// onMouseEnter = "systemChat str [diag_tickTime, ""mouse Entered: "", _this];"
					// onMouseExit = "systemChat str [diag_tickTime, ""mouse Exited: "", _this];"
				};
				
			};
		};
		
	};
};