/*
    File: fn_custom_scope.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Ddetermine type of client or server.
    
    Parameter(s): none
    
    Returns:
        0 HC , 512 client , 768 player host , 384 dedicated server [Number]
    
    Example(s):
        _target_scope = call para_g_fnc_custom_scope;
*/

private _num = 0;
if (isDedicated) then
{
	_num = _num + 128;
};
if (isServer) then
{
	_num = _num + 256;
};
if (hasInterface) then
{
	_num = _num + 512;
};
_num
