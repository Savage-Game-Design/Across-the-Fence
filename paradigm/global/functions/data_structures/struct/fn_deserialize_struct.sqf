/*
    File: fn_deserialize_struct.sqf
    Author:  Savage Game Design
    Public: Yes
    
    Description:
		Loads serialized struct data into an existing struct.
    
    Parameter(s):
		_instance - Instance of the struct to load data into [ARRAY]
		_serializedData - Data for the struct to insert [ARRAY]
    
    Returns:
		_instance, with the data loaded [ARRAY]
    
    Example(s):
		[[] call struct_test_fnc_create, [["test"], ["mem"], "1"]] call para_g_fnc_deserialize_struct
*/

params ["_instance", "_serializedData"];

private _structName = _instance select struct_any_m_name;
private _memberList = missionNamespace getVariable format ["struct_members_%1", _structName];

_serializedData params ["_name", "_storedMemberList", "_data"];

{
	private _dataIndex = _storedMemberList find _x;
	if (_dataIndex > -1) then 
	{
		_instance set [struct_member_offset + _forEachIndex, _data select _dataIndex];
	};
} forEach _memberList;