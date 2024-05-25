/*
    File: fn_skill_passives_support_shepherd.sqf
    Author: Savage Game Design
    Date: 2023-10-08
    Last Update: 2024-02-10
    Public: No

    Description:
        Adds logic for Support Tier 1 Shepherd skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_support_shepherd
 */

#define FONT_SIZE 0.042
#define CTRL_MAP (findDisplay 12 displayCtrl 51)

params ["_known"];

if (!_known) exitWith {
    CTRL_MAP ctrlRemoveEventHandler ["Draw", vgm_c_skill_passives_support_shepherd_drawEh];
};

vgm_c_skill_passives_support_shepherd_drawColor = playerSide call BIS_fnc_sideColor;

[] spawn {
    waitUntil {!isNull CTRL_MAP};

    vgm_c_skill_passives_support_shepherd_drawEh = CTRL_MAP ctrlAddEventHandler ["Draw", {
        params ["_ctrlMap"];

        {
            _ctrlMap drawIcon [
                getText (configOf _x >> "icon"),
                vgm_c_skill_passives_support_shepherd_drawColor,
                getPosASLVisual _x,
                24,
                24,
                getDirVisual _x,
                name _x,
                1, // shadow
                [FONT_SIZE, 0] select (ctrlMapScale _ctrlMap > 0.01)
            ];
        } forEach units player;
    }];
};
