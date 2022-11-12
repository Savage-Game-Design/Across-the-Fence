/*
	File: fn_loadChangelogContent.sqf
	Author:  Savage Game Design
	Public: Yes
	
	Description:
		Loads and formats the contents of the changelog from the mission config.

	Parameter(s):
		None
	
	Returns: 
		Changelog as a string containing structured text 
	
	Example(s): 
		[] call para_c_fnc_loadChangelogContent
*/

private _changelogConfig = missionConfigFile >> "Changelog";
private _releases = "true" configClasses _changelogConfig;

private _versionsInOrder = _releases apply {configName _x};
_versionsInOrder sort false;

private _changelogContent = [
	"<t align='center' size='1.5' font='RobotoCondensedBold'>Changelog</t>",
	"<br/><br/>"
];


{
	private _versionConfig = _changelogConfig >> _x;
	private _version = getText (_versionConfig >> "version");
	private _date = getText (_versionConfig >> "date");
	_changelogContent pushBack (
		format ["<t align='center' size='1.2'>%1 - %2</t><br/>", _date, _version]
	);
	{
		_changelogContent pushBack (
			format ["<t align='center' font='RobotoCondensedLight'>%1</t><br/>", _x]
		);
	} forEach (getArray (_versionConfig >> "changes"));
	_changelogContent pushBack "<br/>";
} forEach _versionsInOrder;

_changelogContent joinString ""