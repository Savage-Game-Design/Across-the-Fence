/*
	File: fn_arraydict_create.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Create a array-backed dictionary (key-value store).
		Garbage-collected alternative to para_g_fnc_create_namespace. 

		Not suitable for large quantities of data, but provides a generic key-value store.
		It's advised to only use these with < 100 keys (or non-string keys) to avoid terrible performance.
		(Note: These run by default about 10x slower than namespaces (0.02ms for set/get), so be confident this is what you want!)

		As namespaces need to be explicitly destroyed, they're very easy to leak (accidentally not destroy)
		As these are normal arrays, they'll be cleaned up when there's no longer any references to them.
	
	Parameter(s):
		None

	Returns:
		New arraydict [ARRAY]
	
	Example(s):
		[] call para_g_fnc_arraydict_create
*/

//If we're not initialized, then we need to create the "dict" type to use.
if (isNil "arraydict_initialized") then {
	[
		"arraydict",
		[["keys", {[]}], ["values", {[]}]]
	] call para_g_fnc_create_struct;

	arraydict_initialized = true;
};

//Call the constructor for the "dict" type.
[] call struct_arraydict_fnc_create;