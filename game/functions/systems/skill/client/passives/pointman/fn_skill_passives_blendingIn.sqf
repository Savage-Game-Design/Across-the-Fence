/*
    File: fn_skill_passives_blendingIn.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        When moving by yourself (no teammates within 100m), trackers are less
        likely to search for you. Increases stealthSpotTimeMultiplier by +1
        when the player is alone.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_blendingIn
 */

#define ALONE_RADIUS 100
#define SPOT_TIME_BONUS 1

params ["_known"];

if (!_known) exitWith {
    removeMissionEventHandler ["EachFrame", vgm_c_skill_passives_blendingIn_eh];
    [player, "stealthSpotTimeMultiplier", "skill_passives_blendingIn"] call vgm_c_fnc_coefficient_remove;
};

vgm_c_skill_passives_blendingIn_lastAlone = -1;
vgm_c_skill_passives_blendingIn_checkTimer = 0;

vgm_c_skill_passives_blendingIn_eh = addMissionEventHandler ["EachFrame", {
    // Only check every 2 seconds for performance
    if (time < vgm_c_skill_passives_blendingIn_checkTimer) exitWith {};
    vgm_c_skill_passives_blendingIn_checkTimer = time + 2;

    // Count friendly players nearby (exclude self)
    private _nearbyFriendlies = (player nearEntities ["CAManBase", ALONE_RADIUS]) select {
        isPlayer _x && _x != player && alive _x
    };

    private _isAlone = count _nearbyFriendlies == 0;

    // Only update coefficient on state change
    if (_isAlone isEqualTo vgm_c_skill_passives_blendingIn_lastAlone) exitWith {};
    vgm_c_skill_passives_blendingIn_lastAlone = _isAlone;

    if (_isAlone) then {
        [player, "stealthSpotTimeMultiplier", "skill_passives_blendingIn", SPOT_TIME_BONUS, true] call vgm_c_fnc_coefficient_set;
    } else {
        [player, "stealthSpotTimeMultiplier", "skill_passives_blendingIn"] call vgm_c_fnc_coefficient_remove;
    };
}];
