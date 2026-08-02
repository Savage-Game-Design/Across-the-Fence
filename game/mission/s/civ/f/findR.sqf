waitUntil
{
	sleep 60;
	private _ap = ( allPlayers select { ( alive _x && { speed _x < 88 } ) } );

	if ( count _ap > 0 ) then
	{
		private _Rs=[];

		{
			private _p = _x;
			private _r = ( _p nearRoads PFC_Range ) select { _x distance _p > ( PFC_Range / 2 ) };
			_r sort false;
			if ( _r isNotEqualTo [] ) then
			{
				_Rs pushBackUnique _r;
			};
		}forEach _ap;
		
		private _Rs = flatten _Rs;

		private _rC = count _Rs;
		if ( _rC > 0 ) then
		{
			{
				private _r = _x;
				if !( _r in ( server getVariable"civR" ) && { ( count( server getVariable "civR" ) ) < 9 } ) then
				{
					if ( ( ( ( getPosWorld _r ) nearEntities [ "SoldierWB" , PFC_Range ] ) select { isPlayer _x } ) > 0 ) then
					{
						[ _r , getPosWorld _r ] call civRoad;
					};
				};
			}forEach _Rs;
		};
	};
false
};

diag_log"PF_Civ: Restarting find.sqf";[]spawn compileFinal(preprocessFile"s\civ\f\find.sqf");