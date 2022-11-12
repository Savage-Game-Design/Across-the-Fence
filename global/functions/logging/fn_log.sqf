/*
    File: fn_log.sqf
    Author: Savage Game Design
    Public: Yes

    Description:
	    Writes a log entry.

    Parameter(s):
		- _logLevel - Log level [STRING]
		- _message - Log message [STRING]
		- _file - File that's being logged from [STRING]
		- _callingFile - File that called the file being logged from [STRING] (Optional)

    Returns: 
		Nothing

    Example(s):
*/
params ["_logLevel", "_message", "_file", "_callingFile"];

private _timestamp = format (["%1-%2-%3 %4:%5:%6:%7"] + systemTimeUTC);
private _identifier = missionNamespace getVariable ["para_g_log_identifier", "PARADIGM"];

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

diag_log format [
	"%1 | %2 | %3 | File: %4 | %5 | %6",
	_timestamp,
	_identifier,
	_logLevel,
	_file,
	_callingFileText,
	_message
];