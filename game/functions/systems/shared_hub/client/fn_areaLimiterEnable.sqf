/*
    File: fn_areaLimiterEnable.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2022-12-04
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_shared_hub_areaLimiterEnable
 */

#define STATE_IN_AREA "in_hub"
#define STATE_OUTSIDE_AREA "outside_hub"
#define TELEPORT_DELAY 5
#define PLAYER_IN_HUB (player inArea "vgm_shared_hub")

if (!isNull (missionNamespace getVariable ["vgm_shared_hub_areaLimiterScript", scriptNull])) exitWith {};

vgm_shared_hub_areaLimiterScript = [] spawn {
    scopeName "vgm_shared_hub_areaLimiterScript";

    private _state = STATE_IN_AREA;
    private _leftHubTime = -1;
    while {true} do {
        call {
            if (_state == STATE_IN_AREA) exitWith {;
                if (!PLAYER_IN_HUB) then {
                    _state = STATE_OUTSIDE_AREA;
                    _leftHubTime = time;
                };
            };

            if (_state == STATE_OUTSIDE_AREA) exitWith {
                if (PLAYER_IN_HUB) exitWith {
                    _state = STATE_IN_AREA;
                };

                if (time > (_leftHubTime + TELEPORT_DELAY)) exitWith {
                    [] call vgm_c_fnc_teleportPlayerToHub;
                    _state = STATE_IN_AREA;
                    _leftHubTime = -1;
                };
            };
        };
        sleep 0.5;
    };
};
