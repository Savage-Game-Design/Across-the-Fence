private _lastDebugMonitor = diag_tickTime;
private _lastCursorTarget = diag_tickTime;

private _lastBuildState = 0;

private _decay_time = ["difficulty", "building_decay_time", 259200] call vn_mf_fnc_get_gamemode_value;

private _action_id = -1;
private _action_id_pt = -1;

vn_mf_cursor_object_pt = objNull;
vn_mf_cursor_object = objNull;
