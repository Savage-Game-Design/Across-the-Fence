/*
    File: fn_coefficient_create.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-08-21
    Public: Yes

    Description:
        Create coefficient.
        The effect callback will be applied every time coefficient reason/value is set or removed.

    Parameter(s):
        _name - Name of the coefficient [STRING]
        _fnc_onChange - Function to be called coefficient reason is set/removed [CODE]
        _baseValue - Base value of the coefficient, all reason values will summed with it (∑) [NUMBER, defaults to 1]

    Returns:
        Nothing

    Example(s):
        ["aim", {
            _unit setCustomAimCoef (_value max 0.1 min 4);
        }] call vgm_c_fnc_coefficient_create;

        ["stamina"] call vgm_c_fnc_coefficient_create;
 */

params [
    ["_name", nil, [""]],
    ["_fnc_onChange", nil, [{}]],
    ["_baseValue", 1, [0]]
];

if (isNil "vgm_c_coefficient_allCoefficients") then {
    vgm_c_coefficient_allCoefficients = createHashMap;
};

vgm_c_coefficient_allCoefficients set [_name, createHashMapFromArray [
    ["onChange", _fnc_onChange],
    ["baseValue", _baseValue]
]];

nil
