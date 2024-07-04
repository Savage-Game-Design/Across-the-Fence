/*
    File: fn_squad_ui_postInit.sqf
    Author: Savage Game Design
    Date: 2024-07-04
    Last Update: 2024-07-04
    Public: No

    Description:
        Squad UI component client post init.
 */

#define ICON_WOUND_MINOR "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r50_ca.paa"
#define ICON_WOUND_MAJOR "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r75_ca.paa"
#define ICON_BLEEDING "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\r100_ca.paa"
#define ICON_INCAPACITATED "\a3\ui_f\data\IGUI\Cfg\Revive\overlayIconsGroup\u100_ca.paa"

if (!hasInterface) exitWith {};

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
