/*
    File: fn_skill_passives_playingPossum.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-05
    Public: No

    Description:
        When the whole team is downed, automatically revive this player
        after a short delay. Once per mission.
        Adapted for SOG Advanced Revive Ã¢â‚¬â€ uses SOG variables to bring
        the player back up, while still healing VGM wounds.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_playingPossum
 */

params ["_apply"];

if (!_apply) exitWith {
    if (!isNil "vgm_c_skill_passives_playingPossum_unconsciousEH") then {
        [vgm_c_skill_passives_playingPossum_unconsciousEH] call para_g_fnc_event_unsubscribe;
    };
};

vgm_c_skill_passives_playingPossum_used = player getVariable ["vgm_c_skill_playingPossum_used", false];

vgm_c_skill_passives_playingPossum_unconsciousEH = ["vgm_medical_unconscious", {
    (_this#0) params ["_unit", "_state"];

    // Only trigger when someone goes down, not when they get up
    if (!_state) exitWith {};

    // Already used this mission
    if (vgm_c_skill_passives_playingPossum_used) exitWith {};

    // Only trigger for the player who has the skill
    if (_unit != player) exitWith {};

    // Check if ALL group members are down
    private _groupUnits = units group player select {alive _x && isPlayer _x};
    private _allDown = _groupUnits findIf {!(_x call vgm_g_fnc_medical_isUnconscious)} == -1;

    if (!_allDown) exitWith {};

    // Mark as used
    vgm_c_skill_passives_playingPossum_used = true;
    player setVariable ["vgm_c_skill_playingPossum_used", true, true];

    // Auto-revive after short delay
    ["skill_playingPossum", {
        "Playing possum: auto-reviving via SOG revive" call vgm_g_fnc_logInfo;

        // Heal 1 VGM wound per body part
        {
            [player, _x, 1] call vgm_c_fnc_medical_removeWound;
        } forEach ["head", "arms", "torso", "legs"];

        // Stop VGM bleeding status
        [player, "bleeding", "medical"] call vgm_c_fnc_statusEffect_remove;

        // Revive via SOG Ã¢â‚¬â€ reset incapacitated state
        player setVariable ["vn_revive_incapacitated", false, true];
        player setVariable ["vn_revive_bleeding", false, true];
        player setVariable ["vn_revive_downed", false, true];
        player setVariable ["vn_revive_respawn_action", false, true];
        player setVariable ["vn_revive_withstand_action", false, true];
        player setVariable ["vn_revive_carried", false, true];
        player setVariable ["vn_revive_dragged", false, true];
        player setVariable ["vn_revive_incapacitated_mobile", false];
        player setUnconscious false;

        // Remove SOG revive actions from this unit for all players
        [player, true, false] remoteExec ["vn_fnc_revive_actions_local", 0, true];

        // Delayed captive reset and movement fix (matches SOG's coreinit behavior)
        [player] spawn {
            params ["_unit"];
            sleep 1;
            [_unit] call vn_fnc_revive_fix_movement;
            sleep 9;
            _unit setCaptive false;
        };

        [localize "STR_VGM_SKILLS_SKILL_PLAYING_POSSUM_ACTIVATED"] call para_c_fnc_hint;
    }, 0.5, "seconds"] call BIS_fnc_runLater;
}] call para_g_fnc_event_subscribe;
