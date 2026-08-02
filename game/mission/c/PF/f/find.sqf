private _isBL =
{
	if ( ( PFL_BLMkr findIf { _this inArea _x } ) == -1 ) then { FALSE } else { TRUE };
};

waitUntil
{
	sleep 5;
	private _ap = if ( isServer ) then
	{
		( allPlayers - entities "HeadlessClient_F" ) select { ( alive _x && { speed _x < PFL_SL } ) }
	} else {
		[ player ]
	};
	
	if ( count _ap > 0 )then
	{
		private _Bs = [];
		{
			_Bs pushBackUnique ( ( nearestObjects [ _x , PF_HBC , PFL_Range , true ] ) select { _x call _isBL })
		}forEach _ap;

		private _Bs = flatten _Bs;



		if ( count _Bs > 0 ) then
		{
			{
				if ( !( _x in PF_LB ) && { isNil{ _x getVariable"PF" } } )then
				{
					if ( toLowerANSI typeOf _x in PFL_Houses ) then
					{
						[ _x , toLowerANSI typeOf _x ] call PF_callL;
					};
				};
			}forEach _Bs;
		};
	};
	false
};
diag_log"PF: Find.sqf loop has been executed.";[]spawn compileFinal(loadFile"c\PF\f\find.sqf");