/*
    File: fn_rto_flaresUntilDawn.sqf
    Author: Savage Game Design
    Date: 2026-03-01
    Last Update: 2026-03-29
    Public: No

    Description:
        Custom strike that puts flares at the designated area until dawn.

    Parameter(s):
        _aircraft - Aircraft performing the run [HASHMAP]
        _aircraftType - Type of the aircraft [HASHMAP]
        _strikeType - Strike info [HASHMAP]
        _startPos - Position player selected for the run to start [Pos2D]
        _endPos - Position player selected for the run to end [Pos2D]
        _playerId - Player calling the strike [NUMBER]

    Returns:
        Nothing

    Example(s):
        [
            _aircraft,
            _aircraftType,
            _strikeType,
            [_startPos # 0, _startPos # 1, 0],
            [_endPos # 0, _endPos # 1, 0],
            _playerId
        ] call vgm_s_fnc_rto_flaresUntilDawn;
 */

params ["_aircraft", "_aircraftType", "_strikeType", "_startPos", "_endPos", "_playerId"];

if (isNil "vgm_s_rto_dawnLoops") then
{
    vgm_s_rto_dawnLoops = createHashMap;
};

private _key = [_playerId, _aircraft get "id"];
private _existingLoop = vgm_s_rto_dawnLoops get _key;

if (!isNil "_existingLoop") then {
    terminate _existingLoop;
};

vgm_s_rto_dawnLoops set [_key, [_startPos] spawn {
	while {daytime >= 17 || daytime <= 6} do
	{
        // Spawn to ensure this script runs to completion and is never terminated accidentally mid-way.
        _this spawn {
            params ["_centerPos"];
            _centerPos params ["_xPos", "_yPos"];
            // Fire
            private _height = 250;
            private _velocity = random[-1, -1.5, -2];
            private _divergence = 50;

            private _position = [_xPos + random[-_divergence,0,_divergence], _yPos + random[-_divergence,0,_divergence], _height];
            private _bomb = createVehicle ["vn_flare_plane_med_w_ammo", _position, [], 0, "CAN_COLLIDE"];
            _bomb setPosATL _position;
            _bomb setVectorDirAndUp [[0,0,-1],[0,1,0]];
            _bomb setVelocity [0, 0, _velocity];
        };
		sleep 40;
	};
}];

