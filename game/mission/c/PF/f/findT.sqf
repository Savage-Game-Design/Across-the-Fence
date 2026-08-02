waitUntil
{
	sleep 5;
	private _ap = ( allPlayers select { ( alive _x && { speed _x < 88 } ) });
	
	if ( count _ap > 0 )then
	{
		private _TOs = [];
		{
			_TOs pushBackUnique ( ( nearestTerrainObjects [ _x , [ "HIDE" ] , PFT_Range , false , false ] ) select { ( ( getModelInfo _x ) # 0 ) in PF_ObjectMdl && { !( _x inArea "BL_Mkr1" ) } } );
		}forEach _ap;

		private _TOs = flatten _TOs;

		if ( count _TOs > 0 ) then
		{
			{
				private _o = _x;
				private _str = getModelInfo _o#0;
				private _id = getObjectID _o;
				private _scan = PF_MapObjs findIf { _id isEqualTo (_x#1) };
				if ( _scan == -1 ) then
				{
					PF_MapObjs pushBackUnique [ _o , _id , [] ];
					[ _o , _str , _id ] call PF_callT;
				};
			}forEach _TOs;
		};
	};
	false
};

diag_log"PF: FindT.sqf loop has been executed.";[]spawn compileFinal(loadFile"s\PF\f\findT.sqf");