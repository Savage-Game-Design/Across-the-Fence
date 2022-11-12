/*
    File: fn_behaviour_get_unclaimed_statics.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Retrieves a list of all unmanned static weapons in an area.
    
    Parameter(s):
        _group - Group that's running this behaviour
		_pos - Position to retrieve static weapons around.
    
    Returns:
        Function reached the end [BOOL]
    
    Example(s):
        [_group, [0,0,0]] call para_g_fnc_get_unclaimed_statics
*/

params ["_group", "_pos"];

//Use hold radius, otherwise they might be given a new hold waypoint if the squad leaders runs out of the radius for any reason
private _staticSearchRadius = _group getVariable ["behaviourHoldRadius", 20];
//Look for statics that aren't claimed and don't have a gunner (in case another mod/script has mounted the gun)
_pos nearEntities ["StaticWeapon", _staticSearchRadius] 
    select {
        //Checks if the static is not attached to something nor hidden (to prevent AI getting in statics loaded in vehicles)
        if (isNull attachedTo _x && !isObjectHidden _x) then {
            ([_x, "claimedBy", [grpNull, 0]] call para_g_fnc_ai_public_var_get)
                params [["_claimingGroup", grpNull], ["_claimEndTime", 0]];
            !(alive gunner _x) && (isNull _claimingGroup || serverTime > _claimEndTime)
        };  
    }