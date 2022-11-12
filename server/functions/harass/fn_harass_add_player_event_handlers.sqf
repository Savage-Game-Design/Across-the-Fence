/*
    File: fn_harass_add_player_event_handlers.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Adds required event handlers to a player, in order to dynamically increase the harassment level.
    
    Parameter(s):
        _player - Player to add event handlers to [OBJECT]
    
    Returns:
        True if handlers haven't been added, false otherwise.
    
    Example(s):
*/

params ["_player"];

_player setVariable ["harassDifficultyEvents", []];

if !(_player getVariable ["hasHarassEventHandlers", false]) then {
	_player addEventHandler ["FiredMan", {
		params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
		if (serverTime > _unit getVariable ["harassFiredCanTrigger", 0]) then {
			_unit setVariable ["harassFiredCanTrigger", serverTime + para_s_harassFiredDelay];
			private _increaseEvents = _unit getVariable "harassDifficultyEvents";
			_increaseEvents pushBack [
				para_s_harassFiredChallengeValue, 
				para_s_harassFiredFrequencyMultiplier, 
				servertime + para_s_harassFiredChallengeCooldown
			];
		};
	}];

	_player setVariable ["hasHarassEventHandlers", true];
};