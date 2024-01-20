/*
    File: fn_skill_investigate_postInit.sqf
    Author: Savage Game Design
    Date: 2024-01-17
    Last Update: 2024-01-20
    Public: No

    Description:
        Post init for Skill Investigate component.
 */

// setup desaturation
call {
    private _effect = -1;
    private _layer = 1500; // ColorCorrections base priority/layer is 1500
    while {_effect < 0} do {
        _effect = ppEffectCreate ["ColorCorrections", _layer];
        _layer = _layer + 1;
    };

    _effect ppEffectForceInNVG true;
    // create effect with default values
    // https://community.bistudio.com/wiki/Post_Process_Effects#ColorCorrections
    _effect ppEffectAdjust [
        1,
        1,
        0,
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0.299, 0.587, 0.114, 0],
        [-1, -1, 0, 0, 0, 0, 0]
    ];
    _effect ppEffectCommit 0;
    _effect ppEffectEnable false;

    vgm_c_skill_investigate_ppDesaturate = _effect;
};

// add hold action
call {
    [
        player,
        localize "STR_VGM_SKILL_INVESTIGATE_ACTION",
        "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\listen_ca.paa",
        "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\listen_ca.paa",
        "true",
        "speed _this < 1",
        {
            [true] call vgm_c_fnc_skill_investigate_setDesaturation;
            // TODO start the listening loop
        },
        {
            // this uses outer scope variables to prevent the ticker from having one "bar" in it.
            private _frame = 3;
            [_target,_actionID,_title,_iconProgress,bis_fnc_holdAction_texturesIn,_frame,"",_orig_iconProgress] call vn_fnc_holdAction_showIcon;
        },
        {},
        {
            params ["_target"];
            if (speed _target >= 1) then {
                hint localize "STR_VGM_SKILL_INVESTIGATE_NOTIFICATION_STATIONARY";
                playSoundUI ["\a3\ui_f_curator\Data\Sound\CfgSound\error02.wss", 0.1];
            };
            [false] call vgm_c_fnc_skill_investigate_setDesaturation;
        },
        [],
        1e38,
        -50,
        false,
        false,
        true
    ] call VN_fnc_holdActionAdd;
};
