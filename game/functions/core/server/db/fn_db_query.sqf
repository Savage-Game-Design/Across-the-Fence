/*
    File: fn_db_query.sqf
    Author: Cerebral
    Date: 2022-07-15
    Last Update: 2022-07-15
    Public: No

    Description:
		This function is used to query the database for information.

    Parameter(s):
		_statement  - Statement to be executed. [STRING]

    Returns:
		ARRAY
    
    Example(s):
		_query call vgm_s_fnc_db_query;
*/


params ["_statement"];

private _key = "extDB3" callExtension format ["%1:%2:%3", _mode, call mf_sql_id, _statement];
private _mode = if (_statement select [0, 6] isEqualTo "DELETE" || {_statement select [0, 6] isEqualTo "SELECT"}) then {1} else {2};
if (_mode isEqualTo 1) exitWith {true};

_key = call compile format ["%1",_key];
_key = (_key select 1);

private _result = "extDB3" callExtension format ["4:%1", _key];
switch (_result) do 
{
    case "[3]": {
        while {true} do 
        {
            if !(_result == "[3]") exitWith {};

            _result = "extDB3" callExtension format ["4:%1", _key];
        };
    };

    case "[5]": {
        private _loop = true;
        while {_loop} do 
        {
            _result = "";
            while {true} do
            {
                _buffer = "extDB3" callExtension format ["5:%1", _key];
                if (_buffer isEqualTo "") exitWith {_loop = false};
                _result = _result + _buffer;
            };
        };
    };
};

_result = call compile _result;
if ((_result select 0) isEqualTo 0) exitWith {
    diag_log format ["Paradigm: DB Error: %1", _result]; 
    []
};

_return;