/*
    File: fn_tool_controller_init.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Initalises the tool system
    
    Parameter(s):
        None
    
    Returns:
        None
    
    Example(s):
        [] call para_c_fnc_tool_controller_init
*/


[missionNamespace, "vn_melee_attack", {
    params ["_unit", "_hitPos", "_hitObject"];

    if(isNull _hitObject) exitWith {};

    private _tool = currentWeapon _unit;
    switch(_tool) do
    {
        case "vn_m_shovel_01";
        case "vn_m_m51_etool_01":
        {
            [_hitObject] call para_c_fnc_operate_shovel;
        };

        case "vn_m_axe_01";
        case "vn_m_axe_fire";
        case "vn_m_machete_01";
        case "vn_m_machete_02";
        case "vn_m_typeivaxe_01":
        {
            [_hitObject] call para_c_fnc_operate_axe;
        };

        case "vn_m_hammer":
        {
            [_hitObject] call para_c_fnc_operate_hammer;
        };
        
        case "vn_m_wrench_01":
        {
        	[_hitObject] call para_c_fnc_operate_wrench;
        };
    };

// }] remoteExec ["BIS_fnc_addScriptedEventHandler", 0, true];
}] call BIS_fnc_addScriptedEventHandler;
