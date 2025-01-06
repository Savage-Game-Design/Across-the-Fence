/*
    File: fn_squad_ui_postInit.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-12-06
    Public: No

    Description:
        Squad UI component client post init.
 */

if (!hasInterface) exitWith {};

// 3d indicators
call {
    #define ICON_WOUND_MINOR "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r50_ca.paa"
    #define ICON_WOUND_MAJOR "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r75_ca.paa"
    #define ICON_BLEEDING "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r100_ca.paa"
    #define ICON_INCAPACITATED "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\u100_ca.paa"

    vgm_squad_ui_defaultIcon = if (difficultyOption "groupIndicators" > 0) then {""} else {getMissionPath "assets\hex_ca.paa"};

    vgm_squad_ui_draw3dEH = addMissionEventHandler ["Draw3D", {
        private _player = player;
        {
            private _icon = _x getVariable ["vgm_squad_ui_icon", vgm_squad_ui_defaultIcon];
            if (_icon isNotEqualTo "") then {
                private _fade = linearConversion [15, 100, _player distance _x, 0.8, 0, true];

                drawIcon3D [
                    _icon,
                    [0.8,0.8,0.8,_fade],
                    unitAimPositionVisual _x,
                    1.5,
                    1.5,
                    0
                ];
            };
        } forEach (units _player - [_player]);
    }];

    ["vgm_medical_unconscious", {
        (_this#0) params ["_unit", "_state"];

        if (_state) then {
            _unit setVariable ["vgm_squad_ui_icon", ICON_INCAPACITATED, true];
        } else {
            _unit setVariable ["vgm_squad_ui_icon", nil, true];
        };
    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_medical_woundAdded", {
        (_this#0) params ["_unit"];
        if (lifeState _unit == "INCAPACITATED") exitWith {};

        if ([_unit, "bleeding"] call vgm_c_fnc_statusEffect_get) exitWith {
            _unit setVariable ["vgm_squad_ui_icon", ICON_BLEEDING, true];
        };

        private _wounds = [_unit, "total"] call vgm_c_fnc_medical_getWound;
        if (_wounds > 3) exitWith {
            _unit setVariable ["vgm_squad_ui_icon", ICON_WOUND_MAJOR, true];
        };
        if (_wounds > 1) exitWith {
            _unit setVariable ["vgm_squad_ui_icon", ICON_WOUND_MINOR, true];
        };

    }] call para_g_fnc_event_subscribeLocal;

    ["vgm_medical_woundRemoved", {
        (_this#0) params ["_unit"];
        if (lifeState _unit == "INCAPACITATED") exitWith {};

        if ([_unit, "bleeding"] call vgm_c_fnc_statusEffect_get) exitWith {};

        private _wounds = [_unit, "total"] call vgm_c_fnc_medical_getWound;
        if (_wounds > 3) exitWith {
            _unit setVariable ["vgm_squad_ui_icon", ICON_WOUND_MAJOR, true];
        };
        if (_wounds > 1) exitWith {
            _unit setVariable ["vgm_squad_ui_icon", ICON_WOUND_MINOR, true];
        };

        _unit setVariable ["vgm_squad_ui_icon", nil, true];

    }] call para_g_fnc_event_subscribeLocal;

    player addEventHandler ["Respawn", {
        player setVariable ["vgm_squad_ui_icon", nil, true];
    }];
};

// map indicators
call {
    #define CTRL_MAP (findDisplay 12 displayCtrl 51)

    vgm_squad_ui_playerColor = playerSide call BIS_fnc_sideColor;

    [] spawn {
        waitUntil {!isNull CTRL_MAP};

        vgm_squad_ui_drawMapEH = CTRL_MAP ctrlAddEventHandler ["Draw", vgm_c_fnc_squad_ui_drawPlayersOnMapEventHandler];
    };

    ["vgm_artillery_displayOpened", {
        params ["_eventParams"];
        _eventParams params ["_artilleryDisplay"];

        private _artilleryMap = _artilleryDisplay displayCtrl 7001;
        private _drawPlayersEH = _artilleryMap ctrlAddEventHandler ["Draw", vgm_c_fnc_squad_ui_drawPlayersOnMapEventHandler];
        _artilleryDisplay setVariable ["vgm_c_squad_ui_drawPlayersEH", _drawPlayersEH];
    }] call para_g_fnc_event_subscribeLocal;
};
