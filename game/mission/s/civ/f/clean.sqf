private["_d","_b","_v"];
waitUntil
{
	sleep 15;
	if ( count allPlayers > 0 && { count ( server getVariable "civB" ) > 0 } ) then
	{
		_d = [];
		for "_x" from 0 to ( count ( server getVariable "civB" ) - 1 ) do
		{
			_b = ( server getVariable "civB" ) # _x;
			if ( ( _b nearEntities [ [ "Man" , "Car" , "Tank" , "Ship" ] , PFC_Range+99 ] select { isPlayer _x } ) isEqualTo [] ) then
			{
				if ( !isNil{ _b getVariable "civB" } ) then
				{
					_v = _b getVariable "civB";
					if ( toLowerANSI typeOf _b in ["land_vn_market_stalls_01_ep1","land_vn_market_stalls_02_ep1"] ) then
					{
						{ deleteVehicle _x }forEach ( _b getVariable "civB" );
						_b setVariable [ "civB" , nil ];
					};
					if ( count _v > 0 ) then
					{
						_dead = { isNull _x || { !alive _x } }count _v;	
						{ deleteVehicle _x }forEach _v;
						_b setVariable [ "anim" , nil ];
						if ( _dead > 0 ) then
						{
							_b setVariable [ "civB" , ( _v deleteRange [ 0 , _dead ] ) ]
						};
					};
				};
				_d pushBack _x;
			};
		};

		if ( count _d > 0 ) then
		{
			{
				private _cb = _x;
				_i = ( server getVariable "civB" ) findIf { _cb isEqualTo _x };
				(server getVariable "civB") deleteAt _i
			}forEach _d
		};
		_civs = server getVariable "civs";
		{
			_civs deleteAt ( _civs find _x );
		}forEach ( _civs select { isNull _x } );
	};
	false
};
diag_log"Civ: Restarting clean.sqf";
[]spawn compileFinal(preprocessFile"s\civ\f\clean.sqf");