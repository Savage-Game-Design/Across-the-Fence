

params
[
	  ["_pos_crate",[0,0,0],[]]	// getPosWorld coords
];

// diag_log ["_pos_crate: ", _pos_crate];
private _sender = remoteExecutedOwner;
private _allPlayers = allPlayers - entities "HeadlessClient_F";
// diag_log ["_allPlayers:", _allPlayers];
private _owner_index = _allPlayers findIf { (owner _x) isEqualTo _sender};
// diag_log ["_owner_index: ", _owner_index];
if(_owner_index >= 0)then
{
	private _owner_obj = _allPlayers#_owner_index;
	private _owner_ID = getPlayerUID _owner_obj;
	private _dist = _pos_crate distance (getPosWorld _owner_obj);
	if(_dist > 3)exitWith{diag_log [":::: CRATE_LOOT_REQUEST: TOO FAR AWAY: ", _pos_crate, (getPosWorld _owner_obj), " = ", _dist];};
	diag_log [_owner_obj, _owner_ID, _dist];
	// ToDo: set crate_ID properly

	diag_log [":::: CRATE_LOOT_REQUEST: DATA:", ["call_function", ["crate_data_get",[_owner_ID, _pos_crate] ] ]];
	["crate_data_get", [_owner_ID, _pos_crate]] call AN_G_fnc_msg_send;
}else{
	diag_log ["!! SENDER NOT FOUND !!"];
};
