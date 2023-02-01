/*
    File: fn_skills_active_openSkillWheel.sqf
    Author: veteran29
    Date: 2023-02-01
    Last Update: 2023-02-01
    Public: Yes

    Description:
        Open skills activation wheel.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_skills_active_openSkillWheel
 */

private _iconsArray = [];
{
    private _slot = vgm_c_skills_active_slots get _x;
    private _skill = _slot get "skill";

    _iconsArray pushBack [
        _skill getOrDefault ["icon", ""], // icon
        "", // icon highlighted
        [

            [
                _skill, // function additional arg
                _skill getOrDefault ["displayName", format ["Empty (%1)", _x]] // label
            ],
            "vgm_c_fnc_skills_active_skillWheelActivate" // function
        ]
    ];
} forEach [
    "ultimate",
    "ability1",
    "ability2"
];

[_iconsArray] call vn_fnc_wm_init;
