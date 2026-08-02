waitUntil { !isNil "PF_Houses" };
waitUntil
{
	sleep 8;
	private _ap = ( allPlayers select { ( alive _x && { speed _x < 88 } ) } );

	if ( count _ap > 0 ) then
	{
		private _Bs=[];

		{
			_Bs pushBackUnique ( nearestObjects [ _x , PF_HBC , PFC_Range ] )
		}forEach _ap;
		
		private _Bs = flatten _Bs;

		private _bC=count _Bs;
		if ( _bC > 0 ) then
		{
			_bN=0;_rC=0;
			switch(true)do
			{
				case(_bC>=0&&_bC<50):{_bN=2;_rC=4};
				case(_bC>=50&&_bC<100):{_bN=1;_rC=6};
				case(_bC>=100&&_bC<150):{_bN=1;_rC=4};
				case(_bC>=150&&_bC<200):{_bN=0;_rC=6};
				case(_bC>=200&&_bC<250):{_bN=0;_rC=4};
				case(_bC>=250&&_bC<300):{_bN=0;_rC=6};
				case(_bC>=300):{_bN=0;_rC=9};
				default{_bN=1;_rC=10};
			};

			{
				if !( _x in ( server getVariable"civB" ) ) then
				{
					if ( toLowerANSI typeOf _x in PF_Civ_Houses ) then
					{
						[ _x , _bC , _bN , _rC ] call civCall;
					};
				};
			}forEach _Bs;
		};
	};
false
};

diag_log"PF_Civ: Restarting find.sqf";[]spawn compileFinal(preprocessFile"s\civ\f\find.sqf");