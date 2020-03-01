/*
 * File: fn_playerInTeam.sqf
 * Author: Spoffy
 * Description:
 *    Checks if a player is on a given team
 * Params:
 *    _player - Player to check
 * 	  _team - Id of team
 * Returns:
 *    True if player on the given team, false otherwise.
 * Example Usage:
 *    [player, "MikeForce"] call vn_an_fnc_playerInTeam
 */

params ["_player", "_team"];

(groupId group _player == _team)