/*
	File: fn_ai_request_defend.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Requests the AI subsystem send units to defend a location
	
	Parameter(s):
		_position - Location to defend, as a position AGL [ARRAY]
		_scalingFactor - How hard this objective should be, used to multiply unit quantities [NUMBER]
		_reinforcementsFactor - How many reinforcements should be available [NUMBER]
	
	Returns:
		Objective Created
	
	Example(s):
		[parameter] call vn_fnc_myFunction
*/

params ["_vehicle"];

/*
	Set up the objective
*/
private _objective = ["crew", getPos _vehicle] call para_s_fnc_ai_obj_create_objective;
_objective setVariable ["fixed_unit_count", 1];
_objective setVariable ["squad_size", 1];
_objective setVariable ["squad_type", "STANDARD"];

_objective setVariable ["vehicle", _vehicle];

_objective setVariable ["onAssignScript", {
	params ["_objective", "_group"];

	private _vehicle = _objective getVariable "vehicle";
	if (isNull gunner _vehicle) then 
	{
		private _unit = leader _group;
		_group addVehicle _vehicle;
		_unit assignAsGunner _vehicle;
		[_unit] orderGetIn true;
		//If we're close, move in as gunner, as we've spawned next to the gun.
		if (_unit distance2D _vehicle < 20) then
		{
			_vehicle moveInGunner _unit;
		} 
		else 
		{
			//Too far away - just give a defend objective, to get them to move closer.
			//TODO - Make a "crew" order.
			_group setVariable ["orders", ["defend", getPos _objective], true];
		};
	};

}];

_objective setVariable ["onTick", {
	params ["_objective"];
	_objective setPos getPos (_objective getVariable "vehicle");
}];

_objective