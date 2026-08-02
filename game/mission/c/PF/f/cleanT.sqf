private [ "_ap" , "_TOs" ];

waitUntil{
	sleep 15;
	
	if ( count allPlayers > 0 && { count PF_MapObjs > 0 } ) then
	{
		{
			private _o = (_x#0);
			private _id = (_x#1);
			if ( ( ( getPosATL _o ) nearEntities [ [ "Man" , "Car" , "Tank" , "Ship" ] , PFT_Range+50 ] findIf { isPlayer _x } ) == -1 ) then
			{
				{
					deleteVehicle _x;
				}forEach (_x#2);
				_o hideObjectGlobal false;
				PF_MapObjs = PF_MapObjs - [ _x ];
				
				private _i = PF_Ambient findIf { _id isEqualTo (_x#1)  };
				if ( _i > -1 ) then
				{
					PF_Ambient = PF_Ambient - [ _i ];
				};
				
			};
		}forEach PF_MapObjs;
	};
	false
};

sleep 15;

diag_log"PF: CleanT.sqf loop has been executed.";[]spawn compileFinal(loadFile"s\PF\f\cleanT.sqf");