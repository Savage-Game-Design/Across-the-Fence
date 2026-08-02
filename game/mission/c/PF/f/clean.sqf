waitUntil
{
	sleep 15;
	if ( ( count allPlayers > 0 ) && { ( count PF_LB > 0 ) } ) then
	{
		{
			if ( !isNil{ _x getVariable "PF" } ) then
			{
				if ( ( _x nearEntities [ [ "Man" , "Car" , "Tank" , "Ship" ] , PFL_Range ] findIf { isPlayer _x } ) == -1 ) then
				{
					{ deleteVehicle _x } count ( _x getVariable "PF" );
					PF_LB = PF_LB - [_x];
					_x setVariable [ "PF" , nil ];
				};
			};
		}forEach PF_LB;
	};
false
};

sleep 15;

diag_log"PF: Clean.sqf loop has been executed.";[]spawn compileFinal(loadFile"c\PF\f\clean.sqf");