
params[
		 ["_model","IG_supplyCrate_F",[""]]
		,["_isPersistent",false,[false]]
		,["_pos",[0,0,0],[]]
		,["_dir",0,[0]]
		,["_gridSize",[4,8],[[]]]
	];

///////////////////////////////
// WIP / TODO / TEMP SOLUTION!
private _tmpKey = call AN_S_fnc_key_create;

if(isNil "AN_S_crate_tmpStorage")then{ AN_S_crate_tmpStorage = [];};
AN_S_crate_tmpStorage pushback [_tmpKey, [_model, [_pos,_dir]]];
///////////////////////////////

diag_log [":::: CREATE_CRATE: DATA:", ["call_function", ["crate_add",[_isPersistent, _tmpKey, _model, [_pos,_dir] , _gridSize]]]];

"asc_extension" callExtension ["call_function", ["crate_add",[_isPersistent, _tmpKey, _model, [_pos,_dir] , _gridSize]]];
