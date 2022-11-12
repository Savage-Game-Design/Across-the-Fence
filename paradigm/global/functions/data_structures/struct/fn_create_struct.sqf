/*
	File: fn_create_struct.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Creates a struct with a given name, which is an array where members are accessible by name.

		Declares several variables local to the current machine, that allow interaction with that struct.
		In all documentation below, "X" will be used a placeholder for the struct name.
			struct_X_fnc_create (e.g struct_orange_fnc_create)
			  - Constructs a new instance of that struct.
			  - Guarantees underlying array is the minimum size needed to suppor the struct.
			  - Runs the provider initializer if given, to set up initial values.

			struct_X_m_M (e.g struct_orange_m_segments)
				- Constant value for setting and getting a member.
				- Used with 'select', e.g `myThing select struct_orange_m_segments`.
				- **Do not persist this value** - Always access it by name, for the most robust + safe code.
				- May change if object struct definition is updated.

			struct_members_X (e.g struct_members_orange)
				- List of members in the struct.

			struct_any_m_name
				- Constant that, given an instance of the struct, can be used to retrieve its name
				- e.g `myThing select struct_any_m_name`

			struct_member_offset
				- Where the actual members of the struct begin, after the header.
			
			struct_null
				- 'Empty struct' - actually an empty array, but defined to fit in with the struct system's naming convention.

		A struct can also have an initializer, which is a function that runs to set up initial state for the struct.
		This adds hidden complexity, so if possible, *try to avoid using it*, and just use default values.
	
	Parameter(s):
		_name - Name of the struct to create. [STRING]
		_members - Array of member names, or members and default values. Default values must be single-statement scripts [STRING/ARRAY]
		_initializer - Code to perform any additional initialisation. MUST RETURN THE ARRAY. [CODE]
	
	Returns:
		Constructor [CODE]
	
	Example(s):
		//Creates a new 'orange' struct
		[
			"Orange",
			[["Segments", {6}]]
		] call para_g_fnc_create_struct;

		//Creates a new instance of 'orange'
		x = [] call struct_orange_fnc_create;
		
		//Sets the number of segments
		x set [struct_orange_m_segments, 3];

		//Retrieves number of segments
		x select struct_orange_m_segments;

		//Example of valid default values
		{6} //Valid - Default is 6
		{test select 0} - Default is 0 index of a global array 'test'
		{test select 1; test select 2;} - Not valid, as it's multiple statements.
		//If in doubt, if it has a semi-colon in, it isn't valid!

	*/


params ["_name", "_members", ["_initializer", {}, [{}]]];

private _namespace = missionNamespace;

private _constructorName = format ["struct_%1_fnc_create", _name];

//Abort! Struct already exists.
//TODO - Remove false
if !(true || isNil {_namespace getVariable _constructorName}) exitWith {
	diag_log format ["ERROR: Paradigm: Attempting to redefine struct %1", _name];
};

//Save the parameters passed to this function, so we can do inheritance later.
_namespace setVariable [format ["struct_definition_%1", _name], _this];

//Save the list of member names
_namespace setVariable [format ["struct_members_%1", _name], _members apply {_x param [0]}];

//We're going to make a hyper-efficient constructor, that uses an array literal. 
//This has the advantage that unlike using values, nothing is passed by reference.
//So we can pass in {[123]} as a default value, and everything will work as expected - data won't be shared
//Between instances of the struct.
private _fnc_scriptToString = {str _this select [1, count str _this - 2]};

private _defaults = _members apply {if (_x isEqualType []) then {_x # 1} else {{nil}}};
private _nameCode = format ['"%1"', _name];
private _compilableDefaults = [_nameCode] + (_defaults apply {"(" + (_x call _fnc_scriptToString) + ")"});
private _constructorStr = "[" + (_compilableDefaults joinString ",") + "]";

//Set the constant to allow access to the struct name.
_namespace setVariable ["struct_any_m_name", 0];
//The position at which struct-specific members start.
_namespace setVariable ["struct_member_offset", 1];
//Set constant for a null struct
_namespace setVariable ["struct_null", []];

//Only add the initializer code if needed. Minor performance improvement?
if !(_initializer isEqualTo {}) then {
	private _initializerName = format ["struct_%1_fnc_initialize", _name];
	//We recompile here to make sure it's completely safe. Can do it because "str" of a "code" object is compileable!
	private _initializerStr = _initializer call _fnc_scriptToString;
	//Compile final - so it's perfectly safe, no risk of publicVariable messing it up.
	_namespace setVariable [_initializerName, compileFinal _initializerStr];
 	private _initializerTemplate = "
		private _array = %1;
		[_array, _this] call %2;
		_array
	";
	_constructorStr = format [_initializerTemplate, _constructorStr, _initializerName];
};

//Create the constructor
private _constructor = compileFinal _constructorStr;
_namespace setVariable [_constructorName, _constructor];

//Lastly - we need to create the constants that allow access to members.
//Sadly, we can't compileFinal these, making them vulnerable to publicVariable shennanigans...
//Possible fix: Move these into the local namespace?
{
	//Works even if _x is a value.
	_memberName = _x param [0];
	//Add 1 to the forEachIndex, as the array begins with the struct name.
	_namespace setVariable [format ["struct_%1_m_%2", _name, _memberName], _forEachIndex + 1];
} forEach _members;

_constructor