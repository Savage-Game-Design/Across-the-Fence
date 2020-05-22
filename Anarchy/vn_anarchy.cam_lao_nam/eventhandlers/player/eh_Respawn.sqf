params ["_unit", "_corpse"];


// restart master loop
0 spawn vn_an_fnc_master_loop_init;

// update UI 
["vn_an_thirst",1] call vn_an_fnc_ui_update;
["vn_an_hunger",1] call vn_an_fnc_ui_update;
