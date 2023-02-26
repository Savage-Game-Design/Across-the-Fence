/*
    File: fn_log.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
	    Writes a log entry.

    Parameter(s):
		- _logLevel - Log level - One of: ERROR, WARNING, INFO, VERBOSE, DEBUG [STRING]
		- _message - Log message [STRING]
		- _file - File that's being logged from [STRING]
		- _callingFile - File that called the file being logged from [STRING] (Optional)

    Returns:
		Nothing

    Example(s):
        ["ERROR", "Something bad happened"] call para_g_fnc_log;
*/
params ["_logLevel", "_message", "_file", "_callingFile", ["_identifier", "PARADIGM"]];

if (is3DENPreview) exitWith {
    diag_log text format ["[%1] %2: %3", _identifier, _logLevel, _message];
};

private _timestamp = format (["%1-%2-%3 %4:%5:%6:%7"] + systemTimeUTC);

if (isNil "_file") then {
	_file = if (!isNil "_fnc_scriptName") then {
			_fnc_scriptName
		} else {
			""
		};
};

if (isNil "_callingFile" && !isNil "_fnc_scriptNameParent") then {
	_callingFile = _fnc_scriptNameParent;
};

private _callingFileText = if (!isNil "_callingFile") then { format ["Called By: %1 |", _callingFile] } else { "" };

diag_log text format [
	"%1 | %2 | %3 | File: %4 | %5 | %6",
	_timestamp,
	_identifier,
	_logLevel,
	_file,
	_callingFileText,
	_message
];
