/*
    File: fn_medical_postInit.sqf
    Author: Savage Game Design
    Date: 2023-06-11
    Last Update: 2023-07-23
    Public: No

    Description:
        Client postInit for medical component.
 */

if (!hasInterface) exitWith {};

if (entities "vn_module_advanced_revive" isNotEqualTo []) then {
    "S.O.G. Advanced Revive module detected in the mission. VGM Medical will NOT function corectly!" call vgm_g_fnc_logError;
};

vgm_c_medical_eh = player addEventHandler ["HandleDamage", {call vgm_c_fnc_medical_handleDamage}];

// tell other clients to add actions on our player unit
["vgm_medical_addAction", player] call para_g_fnc_event_triggerGlobal;

// add the actions on players that were present before we joined and ourselves
{
    ["vgm_medical_addAction", _x] call para_g_fnc_event_triggerLocal;
} forEach (allPlayers select {!(_x isKindOf "VirtualMan_F")});

// bleeding status effect
["bleeding", {
    params ["_unit", "_inEffect"];

    if (!_inEffect) exitWith {
        format ["Stopping bleed out loop: %1", _unit] call vgm_g_fnc_logInfo;

        removeMissionEventHandler ["EachFrame", _unit getVariable ["vgm_c_medical_bleedingEachFrameEH", -1]];
        _unit setVariable ["vgm_c_medical_bleedingEachFrameEH", nil];
    };

    format ["Starting bleed out loop: %1", _unit] call vgm_g_fnc_logInfo;

    #define TICK_TIME 1
    #define BLEED_OUT_TIME 30
    private _eh = addMissionEventHandler ["EachFrame", {
        _thisArgs params ["_deltaT", "_unit", "_bleedOutAt"];

        if (lifeState _unit in ["INCAPACITATED", "DEAD-RESPAWN"]) exitWith {
            if (isPlayer _unit) then {"vgm_medical_bleeding" cutText ["", "PLAIN"]};
            [_unit, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;
        };

        _deltaT = _deltaT + diag_deltaTime;

        if (_deltaT >= TICK_TIME) then {
            _deltaT = _deltaT mod TICK_TIME;

            private _remainingTime = _bleedOutAt - time;
            if (_remainingTime <= 0) exitWith {
                if (isPlayer _unit) then {"vgm_medical_bleeding" cutText ["", "PLAIN"]};
                _unit setUnconscious true;
            };

            if (isPlayer _unit) then {
                "vgm_medical_bleeding" cutText [format ["<t size='1.5'>Bleeding out - %1</t>", _remainingTime toFixed 0], "PLAIN DOWN", -1, true, true];
            };
        };

        _thisArgs set [0, _deltaT];
    }, [0, _unit, time + BLEED_OUT_TIME]];

    _unit setVariable ["vgm_c_medical_bleedingEachFrameEH", _eh];

}] call vgm_c_fnc_statusEffect_create;
