/*
    File: fn_remoteExec_isDirectPlayIdRemoteExecOwner.sqf
    Author: Savage Game Design
    Date: 2023-03-05
    Last Update: 2023-03-05
    Public: Yes

    Description:
        Checks if the provided Direct Play ID represents the player that triggered the remote exec.
        Note: Always returns true if the remoteExec was triggered by headless clients.

    Parameter(s):
        _directPlayId - Direct Player ID of the player to test [STRING]

    Returns:
        True if the direct play id is for the origin of the remote execution or a headless client, false otherwise [BOOL]

    Example(s):
        [getPlayerID _player] call para_s_fnc_remoteExec_isDirectPlayIdRemoteExecOwner;
 */

params ["_directPlayId"];

if (!isRemoteExecuted || !isMultiplayer) exitWith { true };

// Headless client or server, anything goes.
if (remoteExecutedOwner isEqualTo 0 || remoteExecutedOwner isEqualTo 2) exitWith { true };

private _userInfo = getUserInfo _directPlayId;

if (_userInfo isEqualTo []) exitWith {};

private _isOwnerValid = _userInfo # 1 isEqualTo remoteExecutedOwner;

if !(_isOwnerValid) then {
    private _users = allUsers apply {getUserInfo _x};
    private _originUserIndex = _users findIf {_x # 1 isEqualTo remoteExecutedOwner};
    if (_originUserIndex > -1) then {
        private _userInfo = _users # _originUserIndex;
        ["WARN", format ["User %1 (%2) provided a DirectPlayID which was not their own", _userInfo # 5, _userInfo # 2]] call para_g_fnc_log;
    } else {
        ["WARN", "DirectPlayID provided which did not match remoteExecutedOwner, user unknown"] call para_g_fnc_log;
    };
};

_isOwnerValid
