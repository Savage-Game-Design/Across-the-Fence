/*
  Author: Aaron Clark

  Description:
	determine type of client or server

  Example Usage:
	_target_scope = call vn_mf_fnc_custom_scope;

  Returns:
	0 : NUMBER - 0 HC , 512 client , 768 player host , 384 dedicated server

  Parameter(s):
	NA
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
