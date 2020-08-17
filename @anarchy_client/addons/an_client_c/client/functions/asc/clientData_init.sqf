#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

/*

	WIP (in case it isn't obvious)

*/

params["_data"];

diag_log ":::::::::::::::::::: CLIENT DATA INIT ::::::::::::::::::::";
// diag_log str _this;
diag_log "------------------";


//Current Gear:
an_cData_gear = ENTRY_GET("gear", _data);
diag_log format["CLD_INIT: Gear		: %1", an_cData_gear];
{
	_x params["_slot","_itemData"];
	diag_log format["CLD_INIT: Entry		: Slot: %1 | ItemData: %2", _slot, _itemData];
}forEach an_cData_gear;
diag_log "------------------";


//Health
an_cData_health = ENTRY_GET("health", _data);
diag_log format["CLD_INIT: Health FULL	: %1", an_cData_health];
{
	diag_log format["CLD_INIT: Entry		: %1", _x];
}forEach an_cData_health;
diag_log "------------------";


//Inventory Grid
an_cData_inv_grid = ENTRY_GET("inv_grid", _data);
{
	diag_log format["CLD_INIT: Inv_grid		: %1", _x];
}forEach an_cData_inv_grid;
diag_log "------------------";


//Item data for each Item in the Inventory
an_cData_item_data = ENTRY_GET("itemData", _data);
diag_log format["CLD_INIT: Item Data	: %1", an_cData_item_data];
{
	diag_log format["CLD_INIT: Entry		: %1", _x];
}forEach an_cData_item_data;
diag_log "------------------";


// Current Position + Direction
an_cData_pos = ENTRY_GET("pos", _data);
diag_log format["CLD_INIT: Pos			: %1", an_cData_pos];
diag_log "------------------";


//Skillpoints
an_cData_skills = ENTRY_GET("skills", _data);
diag_log format["CLD_INIT: Skills FULL	: %1", an_cData_skills];
{
	diag_log format["CLD_INIT: Entry		: %1", _x];
}forEach an_cData_skills;
diag_log "------------------";