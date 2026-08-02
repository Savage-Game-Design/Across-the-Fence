/*
    File: fn_skill_actives_pathfinder.sqf
    Author: AtlasActual
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Pathfinder active ability.
        For 30s, enemies within 50m are highlighted with dim ground-level icons.
        Also applies -0.3 camouflage coefficient (harder to detect visually).

    Parameter(s):
        _isActive - If skill should be activated or deactivated [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        [true] call vgm_c_fnc_skill_actives_pathfinder
 */

params ["_isActive"];

if (!_isActive) exitWith {
    // Remove camouflage bonus
    [player, "camouflage", "skill_pathfinder"] call vgm_c_fnc_coefficient_remove;

    // Remove Draw3D EH
    private _ehId = player getVariable ["vgm_c_skill_pathfinder_ehId", -1];
    if (_ehId != -1) then {
        removeMissionEventHandler ["Draw3D", _ehId];
        player setVariable ["vgm_c_skill_pathfinder_ehId", nil];
    };
};

// Apply camouflage bonus
[player, "camouflage", "skill_pathfinder", -0.3, true] call vgm_c_fnc_coefficient_set;

// Start Draw3D EH to highlight nearby enemies
private _ehId = addMissionEventHandler ["Draw3D", {
    private _playerPos = getPosATL player;
    private _enemies = _playerPos nearEntities ["CAManBase", 50];
    {
        if (side _x != side player && {alive _x}) then {
            private _pos = getPosATL _x;
            _pos set [2, 0.2];
            drawIcon3D [
                "\a3\ui_f\data\IGUI\Cfg\Cursors\select_ca.paa",
                [1, 0.3, 0.3, 0.4],
                _pos,
                0.5,
                0.5,
                0,
                "",
                0,
                0.03
            ];
        };
    } forEach _enemies;
}];

player setVariable ["vgm_c_skill_pathfinder_ehId", _ehId];
