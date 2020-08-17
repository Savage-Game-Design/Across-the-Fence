
params["_toCheck","_data"];

private _index = _data findIf {_x#0 isEqualTo _toCheck};
private _ret = "";
if(_index >= 0 )then
{
	_ret = _data#_index#1;
};
_ret