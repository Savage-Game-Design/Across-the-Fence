private _isBL =
{
	if ( ( PF_BL findIf { _this inArea _x } ) == -1 ) then { TRUE } else { FALSE };
};

waitUntil
{
	sleep 5;
	private _ap = ( allPlayers select { ( alive _x && { speed _x < PF_SL } ) } );
	
	if ( count _ap > 0 )then
	{
		private _Bs = [];
		{
			_Bs pushBackUnique ( ( nearestObjects [ _x , PF_HBC , PF_Range , true ] ) select { _x call _isBL })
		}forEach _ap;

		private _Bs = flatten _Bs;



		if ( count _Bs > 0 ) then
		{
			{
				if ( !( _x in PF_B ) && { isNil{ _x getVariable"PF" } } )then
				{
					if ( toLowerANSI typeOf _x in PF_Houses ) then
					{
						[ _x , toLowerANSI typeOf _x ] call PF_call;
					};
				};
			}forEach _Bs;
		};
	};
	false
};
diag_log"PF: Find.sqf loop has been executed.";[]spawn compileFinal(loadFile"s\PF\f\find.sqf");