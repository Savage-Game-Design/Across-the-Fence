params["_dict"];
diag_log _dict;
{
	_x params["_tag","_fnc"];
	diag_log ["_tag: ", _tag, " - _fnc: ", _fnc];
	private _test = missionNameSpace getVariable _tag;
	
	if(isNil "_test")then
	{
		//ToDo: add "isFinal"-SecurityCheck after next Arma Patch.
		//							  Tag	 function
		private _fnc = format["_this call %1", _fnc];
		missionNameSpace setVariable[_tag, (compileFinal _fnc)];
	};
}forEach _dict;