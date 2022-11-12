/*
    File: fn_serialize_struct.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
        Serializes an instance of a struct.
    
    Parameter(s):
		_instance - Instance of the struct to serialize [ARRAY]
    
    Returns:
		Serialized instance of the struct [STRING]
    
    Example(s):
		[myThing] call para_g_fnc_serialize_struct
*/

params ["_instance"];

private _namespace = missionNamespace;

private _structName = _instance select struct_any_m_name;
private _memberList = _namespace getVariable format ["struct_members_%1", _structName];
//Data starts after the type header, so we need to use the offset.
private _data = _instance select [struct_member_offset, count _instance - 1];

[_structName, _memberList, _data]

