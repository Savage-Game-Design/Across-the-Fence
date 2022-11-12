/*
    File: fn_net_action_varname.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Retrieves the variable name associated with a piece of net action data.
    
    Parameter(s):
        _netActionId - ID of the hold action [ANY]
        _key - Name of the item of data
    
    Returns:
        Name of global variable data is stored in [STRING]
    
    Example(s):
        ["1234", "codeStart"] call para_g_fnc_net_action_varname
*/

params ["_netActionId", "_key"];

format ["para_l_netAction_%1_%2", _netActionId, _key]