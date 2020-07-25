
class cfgAn_items
{
	class items_base
	{
	// rarity = 0;
		slot = 0;
		/*
			Assignable to a slot?
			0 = inventory Items only
			1 = ??? (placeholder)
			//"Weapons"
			2 = Primary Weapon
			3 = Handgun
			4 = Launcher
			5 = Tool (Pickaxe/Hammer)
			//Gear:
			10 = Helmet
			11 = Glasses
			12 = Uniform
			13 = Vest
			14 = Backpack
			15 = Pouch	(extra inventory, nothing else - atm not visible)
		*/
		
		//Grid Size
		size[] = {1,1};
		
		//IF Slot between 2 and 5
		//Classname of Item (configFiles entry)
		classname = "";
		
		configBase = "CfgMagazines";	//Standard Value
		
		//set custom item picture - !! Optional !! for Slot 2-5 = otherwise use the "picture" value of the CfgWeapon entry.
		picture = "";
		/*
			picture size examples (128 just used as an example number, can be higher BUT must be 1:1 or 1:2 AspecRatio!):
			x to y ratio * 128.
			Examples:
			!!!!!! ATTENTION: [Y,X] !!!!!! (i might change that to [x,y] /shrug)
			[1,1] = 128x128	- square img
			[2,1] = 256x128 - horizontal img
			[1,2] = 128x256 - vertical img
			[2,2] = 256x256	- square img
			[4,8] = 512x1024 - horizontal img (used weapon_base)
			[4,4] = 512x512 - square img (used gear_base)
			
			For CUSTOM Icons, the 1:1 or 1:2 AspecRatio is not needed.
		*/
		
		
		inventory = 0;
		//Can be turned by 90° (doesn't make sense on square parts and would look like shit, so don't add this entry to the class, if the Size is a square)
		name = "ITEM BASE";
		
		canFlip = false;
		//Rarity 0 = Bad | 1 = | 2 = | 3 = | .... tbd
		rarity = 0;
	};
	
	
	//////////////////////////////////////////////////////
	//WEAPONS/TOOLS:
	class weapon_primary_base: items_base
	{
		slot = 2;
		size[] = {4,8};	//Standard Size
		inventory = 0;
		name = "WEAPON PRIM BASE";
		configBase = "CfgWeapons";
		classname = "arifle_MXC_F";
		picture = "";
		canFlip = true;
		
		/*
			TODO: 
			More entrys to come
		*/
	};
	
	class weapon_hand_base: items_base
	{
		slot = 3;
		size[] = {3,6};	//Standard Size
		inventory = 0;
		name = "WEAPON HAND BASE";
		configBase = "CfgWeapons";
		classname = "hgun_P07_F";
		picture = "";
		canFlip = true;
		
		/*
			TODO: 
			More entrys to come
		*/
	};
	
	class weapon_launcher_base: items_base
	{
		slot = 4;
		size[] = {4,8};	//Standard Size
		inventory = 0;
		name = "WEAPON LAUNCHER BASE";
		configBase = "CfgWeapons";
		classname = "launch_RPG32_F";
		picture = "";
		canFlip = true;
		
		/*
			TODO: 
			More entrys to come
		*/
	};
	
	class weapon_tool_base: items_base
	{
		slot = 4;
		size[] = {4,8};	//Standard Size
		inventory = 0;
		name = "TOOL BASE";
		configBase = "CfgTools";
		classname = "an_pickaxe";
		picture = "";
		canFlip = true;
		
		/*
			TODO: 
			More entrys to come
		*/
	};
	
	
	
	
	//////////////////////////////////////////////////////
	////////////////// GEAR:
	class helmet_base:  items_base
	{
		slot = 10;
		size[] = {4,4};	//Standard Size
		inventory = 0;
		name = "GEAR HELM BASE";
		configBase = "CfgWeapons";
		classname = "H_HelmetB";
		picture = "";
		canFlip = false;
	};
	
	class goggles_base:  items_base
	{
		slot = 11;
		size[] = {3,3};	//Standard Size
		inventory = 0;
		name = "GEAR GOGGLES BASE";
		configBase = "CfgGlasses";
		classname = "G_Shades_Black";
		picture = "";
		canFlip = false;
	};
	
	class uniform_base:  items_base
	{
		slot = 12;
		size[] = {5,5};	//Standard Size
		inventory = 8;
		name = "GEAR UNIFORM BASE";
		configBase = "CfgWeapons";
		classname = "U_B_CombatUniform_mcam";
		picture = "";
		canFlip = false;
	};
	
	class vest_base:  items_base
	{
		slot = 13;
		size[] = {5,5};	//Standard Size
		inventory = 8;
		name = "GEAR VEST BASE";
		configBase = "CfgWeapons";
		classname = "V_PlateCarrier1_rgr";
		picture = "";
		canFlip = false;
	};
	
	class backpack_base:  items_base
	{
		slot = 14;
		size[] = {6,6};	//Standard Size
		inventory = 12;
		name = "GEAR BACKPACK BASE";
		configBase = "CfgVehicles";
		classname = "B_AssaultPack_blk";
		picture = "";
		canFlip = false;
	};
	
	class pouch_base:  items_base	//!! ANARCHY CONFIG !!
	{
		slot = 15;
		size[] = {5,5};	//Standard Size
		inventory = 8;
		name = "GEAR POUCH BASE";
		configBase = "CfgAn_Items";
		classname = "an_pouch";
		picture = "";
		canFlip = false;
	};
	
	#include "items.hpp"
};