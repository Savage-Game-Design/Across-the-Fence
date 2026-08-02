/*
    File: fn_skills_handle_skillUnlearnRequest.sqf
    Author: Atlas
    Date: 2026-03-04
    Public: No

    Description:
        Handle client skill unlearn request. Removes the specified skill,
        cascades to remove any skills in tiers that become locked, and
        refunds the effective cost for all removed skills.

    Parameter(s):
        _player    - Player requesting the unlearn [OBJECT]
        _skillPath - Path of the skill to unlearn [ARRAY]

    Returns:
        Nothing
*/

params ["_player", "_skillPath"];

if (owner _player isNotEqualTo remoteExecutedOwner) exitWith {
    (format ["Unlearn request for %1, owner not matching %2 != %3", name _player, owner _player, remoteExecutedOwner]) call vgm_g_fnc_logError;
};

// Validate the skill exists
private _skill = _skillPath call vgm_g_fnc_skills_getByPath;
if (isNil "_skill") exitWith {
    (format ["Unlearn request for %1 (%2), invalid skill path %3", name _player, getPlayerUID _player, _skillPath]) call vgm_g_fnc_logWarning;
    [false, _skillPath, []] remoteExecCall ["vgm_c_fnc_skills_receiveSkillUnlearn", _player];
};

// Validate the player actually knows this skill
if !([_skill, _player] call vgm_g_fnc_skills_isKnown) exitWith {
    (format ["Unlearn request for %1 (%2), skill not known %3", name _player, getPlayerUID _player, _skillPath]) call vgm_g_fnc_logWarning;
    [false, _skillPath, []] remoteExecCall ["vgm_c_fnc_skills_receiveSkillUnlearn", _player];
};

(format ["Handling unlearn request for %1 (%2), %3", name _player, getPlayerUID _player, _skillPath]) call vgm_g_fnc_logInfo;

// Get the skill tree this skill belongs to
private _skillTree = _skill call vgm_g_fnc_skills_getSkillTreeFromSkill;
private _tiers = _skillTree get "skills"; // array of arrays, index = tier

// Build list of all skills to remove: start with the requested skill
private _skillsToRemove = [_skillPath];
private _targetSkillTier = _skill get "tier";

// Simulate removing the skill and check tier thresholds from the target tier upward
// We need to iterate upward because removing skills from one tier can break the next
private _skillsData = _player call vgm_s_fnc_skills_dataGetCached;
private _knownPaths = +(_skillsData get "skillPaths"); // copy to simulate

// Remove the target skill from our simulated known paths
_knownPaths deleteAt (_knownPaths find _skillPath);

// Check each tier above the target skill's tier
// A tier requires X base-cost points spent in tiers BELOW it
for "_tierIdx" from (_targetSkillTier + 1) to (count _tiers - 1) do {
    // Calculate base cost of known skills below this tier (simulated)
    private _spentBelow = 0;
    for "_t" from 0 to (_tierIdx - 1) do {
        {
            if ((_x get "path") in _knownPaths) then {
                _spentBelow = _spentBelow + (_x get "cost");
            };
        } forEach (_tiers # _t);
    };

    private _requiredPoints = [_skillTree, _player, _tierIdx] call vgm_g_fnc_skills_getTierUnlockCost;

    // If threshold is broken, remove all known skills in this tier
    if (_spentBelow < _requiredPoints) then {
        {
            private _path = _x get "path";
            if (_path in _knownPaths) then {
                _skillsToRemove pushBackUnique _path;
                _knownPaths deleteAt (_knownPaths find _path);
            };
        } forEach (_tiers # _tierIdx);
    };
};

// Calculate total refund (effective cost for each removed skill)
private _totalRefund = 0;
{
    private _removedSkill = _x call vgm_g_fnc_skills_getByPath;
    private _effectiveCost = [_removedSkill, _player] call vgm_g_fnc_skills_getEffectiveCost;
    _totalRefund = _totalRefund + _effectiveCost;
} forEach _skillsToRemove;

// Apply refund
private _skillPoints = _skillsData get "skillPoints";
private _skillPointsSpent = _skillsData get "skillPointsSpent";

_skillsData set ["skillPoints", _skillPoints + _totalRefund];
_skillsData set ["skillPointsSpent", (_skillPointsSpent - _totalRefund) max 0];

// Remove all skills
[_player, +_skillsToRemove] call vgm_s_fnc_skills_forgetSkills;

// Inform the player
[true, _skillPath, _skillsToRemove] remoteExecCall ["vgm_c_fnc_skills_receiveSkillUnlearn", _player];
