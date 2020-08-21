/*
	"fill" lootcrates localy on the Client
*/
#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

params["_data"];

diag_log [":::: LOOT_INV_GET: DATA:"];
private _crate_inv_grid	= ENTRY_GET("inv_grid",_data);
private _crate_itemData	= ENTRY_GET("itemData",_data);


diag_log [":::: LOOT_INV_GET: InvGrid:"];
{
	diag_log format["%1 %2", _forEachIndex, _x];
}forEach _crate_inv_grid;

diag_log [":::: LOOT_INV_GET: ItemData:"];
{
	diag_log _x;
}forEach _crate_itemData;

 // ToDo: Fill the UI




///////////////////////////////////////////// DEV
/*
// Create the simple object 2m in front of the player:

_crate_model = "Land_Suitcase_F";
_pos =  AGLtoASL (player getRelPos [2, 0]);
_dir = getDir player;
_crate_model_simple = "a3\weapons_f\ammoboxes\supplydrop.p3d";

systemchat str[_crate_model_simple];

_crate = createSimpleObject [_crate_model_simple, [0,0,0], true];
systemchat str[_crate];
_crate setPosASL _pos;
_crate setDir _dir;


// Get the object type (works with simpleObjects too):
typeOf cursorObject

// get SimpleObject-modelpath for cursorObject (works with simpleObjects too):
(getModelInfo cursorObject)#1


 */
/////////////////////////////////////////////