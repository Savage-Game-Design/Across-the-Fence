
params
	[
		["_fnc","",[""]],
		["_data",[],[[],""]]
	];

if(_data isEqualType "")then
{
	_data = [_data];
};
_msg = [_fnc, _data];
"asc_extension" callExtension ["call_function",_msg];