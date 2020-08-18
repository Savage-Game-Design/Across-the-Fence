
#include "\sgd\anarchy\an_client_c\global\asc_macros.inc"

params["_data"];

private _tmpKey = ENTRY_GET("tmpKey", _data);
private _newID = ENTRY_GET("newID", _data);
private _crate_data = ENTRY_GET(_tmpKey, AN_S_crate_tmpStorage);

_crate_data params["_model", "_posData"];
_posData params["_pos","_dir"];

diag_log [":::: CRATE_ADD: DATA:", [_tmpKey, _newID, _model, _pos, _dir]];

private _crate = createVehicle [_model, _pos, [], 0, "NONE"];
_crate setDir _dir;
_crate setVariable ["crateID", _newID, true];
