
// systemchat str ["ASC - INIT LOADED - CLIENT"];
diag_log str ["ASC - INIT LOADED - CLIENT"];

// set the Callback Eventhandler - Don't let a Dedicated Server load it
if(!isDedicated)then
{
	addMissionEventHandler ["ExtensionCallback", AN_C_fnc_ext_CE_callback_client];
};


//////////////// DEV STUFF ////////////////
if hasInterface then
{
	// player addAction ["ASC: itemAdd [0,0]",				{["itemAdd", 		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", getPlayerUID player, 0, [0,0]]] call AN_G_fnc_msg_send;}];
	// player addAction ["ASC: itemAdd [1,1]",				{["itemAdd", 		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", getPlayerUID player, 0, [1,1]]] call AN_G_fnc_msg_send;}];
	player addAction ["ASC: getGrid",					{["inv_get_grid",	[(cursorObject getVariable ["crateID","-1"])]] call AN_G_fnc_msg_send;}];
	player addAction ["ASC: getItems",					{["inv_get_items",	[(cursorObject getVariable ["crateID","-1"])]] call AN_G_fnc_msg_send;}];
	player addAction ["ASC: toInv [0,1] Flipped: 0",	{["itemMove",		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", (cursorObject getVariable ["crateID","-1"]),	getPlayerUID player,	0,		[0,1]	]] call AN_G_fnc_msg_send;}];
	player addAction ["ASC: toInv [0,1] Flipped: 1",	{["itemMove",		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", (cursorObject getVariable ["crateID","-1"]),	getPlayerUID player,	1,		[0,1]	]] call AN_G_fnc_msg_send;}];
	//																 		[ ITEM ID									   OLD INVENTORY ID,							NEW  INVENTORY ID,	flipped		NewInvPos]	
	player addAction ["ASC: toCrate [0,0] Flipped: 0",	{["itemMove",		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", getPlayerUID player,	(cursorObject getVariable ["crateID","-1"]),	0,		[0,0]	]] call AN_G_fnc_msg_send;}];
	player addAction ["ASC: toCrate [0,0] Flipped: 1",	{["itemMove",		["MjAyMC0wOC0xMFQyMDoxNTozMS45NTk5NTEtMQ==", getPlayerUID player,	(cursorObject getVariable ["crateID","-1"]),	1,		[0,0]	]] call AN_G_fnc_msg_send;}];
	//																 		[ ITEM ID									   OLD INVENTORY ID,	NEW  INVENTORY ID,							flipped		NewInvPos]	
	player addAction ["ASC: Create Crate",				{["IG_supplyCrate_F",(getPos player),(getDir player),[6,8]] remoteExecCall ["AN_S_fnc_crate_create", 2];}];
};


DEV_an_fnc_hintGrid =
{
	params["_grid"];
	
	_formated = "";
	{
		_formated = format["%1\n%2", _formated, _x];
	}foreach _grid;
	
	hintsilent _formated;
};



DEV_an_fnc_item_getCfgClass =
{
	params[
		["_itemClass",-1,[-1]]
	];
	systemchat str["_itemClass", _itemClass];
	
	if (_itemClass < 0)exitWith{""};
	
	private _ret = switch(_itemClass)do
	{
		case 0: {"CfgMagazines"};	// Inventory Items only
		
		case 2: {"CfgWeapons"};	// Primary Weapon
		case 3: {"CfgWeapons"};	// Handgun
		case 4: {"CfgWeapons"};	// Launcher
		case 5: {"CfgWeapons"};	// Tool (Pickaxe/Hammer)
		
		case 10: {"CfgWeapons"};	// Helmet
		case 11: {"CfgWeapons"};	// Glasses
		case 12: {"CfgWeapons"};	// Uniform
		case 13: {"CfgWeapons"};	// Vest
		case 15: {"CfgWeapons"};	// Backpack
		case 14: {"CfgWeapons"};	// Pouch (extra inventory, nothing else - atm not visible)
		default {"CfgMagazines"};
	};
	systemchat str["_ret", _ret];
	_ret
};

DEV_an_fnc_hintItemData =
{
	#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"
	
	params["_itemData"];
	
	private _imgPath = "";
	private _className = "";
	{
		_x params["_itemID","_itemData"];
		
		diag_log str _itemData;
		_className = ENTRY_GET("class_name", _itemData);
		_type = ENTRY_GET("type", _itemData);
		_cfgClass = [_type] call DEV_an_fnc_item_getCfgClass;
		// systemchat str[_type, _cfgClass];
		_imgPath = getText(configFile >> _cfgClass >> _className >> "picture");
	}foreach _itemData;
	
	_text = format["%1<br/><br/><t size='6.0'><img image='%2'/></t><br/>", _className, _imgPath];
	hintsilent parseText _text;
};
//////////////// DEV STUFF ////////////////