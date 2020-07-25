class CfgItemInteractions
{
	class AllAmmoSettings // this is a fake class that holds the settings for the ammo repack feature.
	{
		interactActions[] =
		{
			{"STR_vn_an_repack", "call vn_an_fnc_ammo_repack;" } // To disable set this to an empty array here or in description.ext. interactActions[] = {};
		};
	};
	class vn_prop_drink_01 // canteen 0.75l
	{
		disallowRepack = 1;
		interactActions[] =
		{
			{
				"STR_vn_an_drink",
				"[player,'drinkwater',[1],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];"
			}
		};
	};
	class vn_prop_drink_02 : vn_prop_drink_01 {}; // canteen 1.00l
	class vn_prop_drink_03 : vn_prop_drink_01 {}; // canteen 0.75l
	class vn_prop_drink_04 : vn_prop_drink_01 {}; // canteen 1.00l
	class vn_prop_drink_05 : vn_prop_drink_01 {}; // bottle 0.50l
	class vn_prop_drink_06 : vn_prop_drink_01 {}; // bottles 2.00l (canteen)
	class vn_prop_food_01 //
	{
		disallowRepack = 1;
		interactActions[] =
		{
			{
				"STR_vn_an_eat",
				"[player,'eatfood',[1],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];"
			}
		};
	};
	class vn_prop_food_02 : vn_prop_food_01 // Orange
	{
		interactActions[] =
		{
			{
				"STR_vn_an_eat",
				"[player,'eatfood',[0.1],player getVariable 'vn_an_token'] remoteExecCall ['vn_an_fnc_rehandler',2];"
			}
		};
	};
	class vn_prop_food_03 : vn_prop_food_01 {}; // Rice 1kg
	class vn_prop_food_04 : vn_prop_food_01 {}; // Pumpkin
	class vn_prop_food_05 : vn_prop_food_01 {}; // Rice 4kg

	class FirstAidKit
	{
		interactActions[] =
		{
			// Test actions - requires the player to have a watch equipped for "Check Pulse" action to show on double click of the First Aid Kit.
			{"STR_vn_an_check_pulse", "private _target = player; if (cursorTarget isKindof 'Man') then {_target = cursorTarget}; if ((damage _target) > 0.1) then { hintSilent format['%1 Needs Medical Attention!',name _target];} else {hintSilent format['%1, Does Not Need Medical Attention.',name _target];};", "!('ItemWatch' in (assignedItems player))", 1 , "hintSilent 'Watch Needed';" }
			// {"Debug 1", "hintSilent str[_thisItem,_thisItemType];" },
		};
	};
};
