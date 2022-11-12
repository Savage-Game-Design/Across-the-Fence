/*
    File: fn_interactionOverlay_add.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Sets the object's Interaction data.
    
    Parameter(s):
		_object - Interactible object [OBJECT, defaults to objNull]
		_name - Name of the object [String, defaults to "" (empty string)]
		_picture - Path to the object's icon [String, defaults to "" (empty string)]
		_description - Description of the object [String, defaults to "" (empty string)]
		_variables - [_variable(n)] Code that will be cal compiled, like format. Special variables "_object" represents the targeted object [Array, defaults to []]
			_variable - Code that will be call compiled and replaced in the format [String]
		_interactive - Is the object interactive [BOOLEAN, defaults to true]
    
    Returns: nothing
    
    Example(s):
		// Changes: NAME, DESCRIPTION, VARIABLES, "INTERACTIVITY"
		// Icon will be fetched from the missionConfigFile or the configFile
		[
	 		this, 
			"Developper",
			"",
			"The developper %1 meters away from you is a rare specimen that is found near computers.",
			[
	 			"(_object distance player)"
			],
			false
		] call para_c_fnc_interactionOverlay_add;
*/

params [
	["_object", objNull, [objNull]]
];
private _config = configFile >> "CfgVehicles" >> (typeOf _object);
params [
	["_object", objNull, [objNull]],
	["_name", "", [""]],
	["_picture", "", [""]],
	["_description", "", [""]],
	["_variables", {[]}, [{}]],
	["_interactive", true, [true]]
];

//Localize the name and description
_name = _name call BIS_fnc_localize;
_description = _description call BIS_fnc_localize;

_object setVariable ["#para_InteractionOverlay_Data", [_name, _picture, _description, _variables, _interactive]];
