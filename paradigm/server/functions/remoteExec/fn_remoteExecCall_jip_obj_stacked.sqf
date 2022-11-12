/*
    File: fn_remoteExecCall_jip_obj_stacked.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Wrapper for remote execution, that allows stacking multiple JIP calls onto a single object.
		Uses remoteExecCall
    
    Parameter(s):
		_arguments - Arguments to pass to the remote execution call [ARRAY]
		_function - Function or scripting command to remote execute [STRING]
		_targets - Targets to send remoteExec to [NUMBER/OBJECT/STRING/SIDE/GROUP/ARRAY]
		_JIP - Whether or not to JIP. Doesn't overwrite previous JIP remoteExecs if an object is passed. [BOOLEAN/STRING/OBJECT]
    
    Returns:
		Result from underlying remoteExec (see BIS wiki)
    
    Example(s):
		[["Hello"], "diag_log", 2, "Jip ID"] call para_s_fnc_remoteExecCall_jib_obj_stacked
*/

params ["_params", "_function", ["_targets", 0], ["_jipId", false]];

//Okay, so we've got an object. 
//The approach is to generate a new JIP id, then add a `Deleted` handler to clean it up later.
//This is 100% reliant on `Deleted` being reliable. According to Dedmen, it should be.
if (_jipId isEqualType objNull) then 
{
	private _obj = _jipId;
	//time + random number + netId
	//According to birthday paradox, to get a collision with a random 10,000,000 integer
	//we'd need about 8.4 million tries for a 50% chance of collision.
	//In other words: per object, each second, we've need to make 8.4 million calls to be 50% likely to overwrite our JIP ID
	//This should be unique enough for our needs...
	//jip prefix makes sure it isn't parsed as a netId due to the colon being present.
	_jipId = "jip" + (serverTime toFixed 0) + (random 10000000 toFixed 0) + netId _obj;
	//Add a deleted event handler that clears the JIP entry.
	_obj addEventHandler ["Deleted", compile format ['remoteExec ["", "%1"]', _jipId]];
};

_params remoteExecCall [_function, _targets, _jipId]


