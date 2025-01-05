/*
    File: fn_enableHub.sqf
    Author: veteran29
    Date: 2022-12-03
    Last Update: 2025-01-06
    Public: Yes

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_sharedHub_enableHub
 */

#define STATE_IN_AREA "in_hub"
#define STATE_OUTSIDE_AREA "outside_hub"
#define TELEPORT_DELAY 5
#define PLAYER_IN_HUB (player inArea "vgm_shared_hub")

if (!isNull (missionNamespace getVariable ["vgm_sharedHub_areaLimiterScript", scriptNull])) exitWith {};

vgm_sharedHub_areaLimiterScript = [] spawn {
    scriptName "vgm_sharedHub_areaLimiterScript";

    private _state = STATE_IN_AREA;
    private _leftHubTime = -1;
    while {true} do {
        call {
            if (_state == STATE_IN_AREA) exitWith {
                if (!PLAYER_IN_HUB) then {
                    _state = STATE_OUTSIDE_AREA;
                    _leftHubTime = time;
                };
            };

            if (_state == STATE_OUTSIDE_AREA) exitWith {
                if (PLAYER_IN_HUB) exitWith {
                    _state = STATE_IN_AREA;
                    _leftHubTime = -1;
                };

                if (time > (_leftHubTime + TELEPORT_DELAY)) exitWith {
                    [] call vgm_c_fnc_sharedHub_teleportPlayerToHub;
                    _state = STATE_IN_AREA;
                    _leftHubTime = -1;
                };
            };
        };
        sleep 0.5;
    };
};

vgm_sharedHub_iconsDraw3D = addMissionEventHandler ["Draw3D", {
    private _currentArea = vgm_sharedHub_hqAreas findIf {player inArea _x};
    // draw plaques of nearby HQs
    if (_currentArea == -1) exitWith {
        {
            _x params ["_hq"];

            private _drawPos = getPosATL _hq;
            _drawPos set [2, _drawPos # 2 + linearConversion [20, 50, player distance _hq, 5, 10, true]];

            [_drawPos, [localize "STR_VGM_SHARED_HUB_ICON_HQ", localize "STR_VGM_SHARED_HUB_ICON_HQ_SUB"]] call vgm_c_fnc_sharedHub_drawPlaque3d;
        } forEach vgm_sharedHub_hqAreas;
    };

    // draw plaques of interactive objects
    {
        private _drawPos = _x modelToWorld [0, 0, 1.3];
        [_drawPos, [localize "STR_VGM_SHARED_HUB_ICON_MISSIONS", localize "STR_VGM_SHARED_HUB_ICON_MISSIONS_SUB"]] call vgm_c_fnc_sharedHub_drawPlaque3d;
    } forEach (vgm_mission_givers select {player distance _x < 5});

    {
        private _drawPos = _x modelToWorld [0, 0, 1];
        [_drawPos, [localize "STR_VGM_SHARED_HUB_ICON_ARSENAL", localize "STR_VGM_SHARED_HUB_ICON_ARSENAL_SUB"]] call vgm_c_fnc_sharedHub_drawPlaque3d;
    } forEach (vgm_equipment_arsenals select {player distance _x < 5});

    {
        private _drawPos = _x modelToWorld [0, 0, 0.5];
        [_drawPos, [localize "STR_VGM_SHARED_HUB_ICON_SKILLS", localize "STR_VGM_SHARED_HUB_ICON_SKILLS_SUB"]] call vgm_c_fnc_sharedHub_drawPlaque3d;
    } forEach (vgm_skills_managers select {player distance _x < 5});
}];

["vgm_shared_hub_enabled", []] call para_g_fnc_event_triggerLocal;
