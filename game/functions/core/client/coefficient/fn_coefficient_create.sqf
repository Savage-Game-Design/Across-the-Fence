/*
    File: fn_coefficient_create.sqf
    Author: Savage Game Design
    Date: 2023-08-21
    Last Update: 2023-08-21
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
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
