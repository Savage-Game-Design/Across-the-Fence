#include "macros.inc"
/*
    File: game/functions/core/client/displays/fn_displayEndOfMission.sqf
    Author: Savage Game Design
    Date: 2023-09-25
    Last Update: 2023-10-15
    Public: No

    Description:
            UI script for the End Of Mission UI.

    Parameter(s):
            _mode - One of the switch cases [STRING]
            _this - Arguments for the passed case [ARRAY]

    Returns:
            Nothing [NIL]

    Example(s):
            ["onLoad", [_display]] call vgm_c_fnc_displayEndOfMission;
*/

#define SELF vgm_c_fnc_displayEndOfMission

#define LEVEL_NEXT(LEVEL) ((LEVEL) + 1 min vgm_g_leveling_maxLvl)

params ["_mode", "_this"];

switch _mode do {
    case "onLoad": {
        params ["_display"];

        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE) ctrlShow false;
        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN) ctrlSetText "";
    };

    case "onUnload": {
        params ["_display", "_exitCode"];
    };

    case "renderProgress": {
        params ["_display", "_args"];
        _args params ["_levelingData", "_milestones"];

        ["updateLevelsHeader", [_display, _levelingData]] call SELF;

        [_display, [_levelingData, _milestones]] spawn {
            params ["_display", "_args"];
            _args params ["_levelingData", "_milestones"];

            private _ctrlBreakdown = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN;

            private _currentExperience = _levelingData get "experience";

            private _text = [];
            {
                uiSleep 0.5;
                _x params ["_milestoneName", "_milestoneXp"];

                _text pushBack format ["%1 - %2", localize format ["STR_VGM_MISSION_END_UI_MILESTONE_%1", _milestoneName], _milestoneXp];
                _ctrlBreakdown ctrlSetStructuredText parseText (_text joinString "<br/>");
                playSoundUI ["\a3\sounds_f\sfx\blip1.wss", 0.2];

                private _animDuration = 1 + (_milestoneXp / 500);
                private _animTime = time + _animDuration;
                private _newExperience = _currentExperience;

                while {time < _animTime} do {
                    uiSleep 0.05;

                    _newExperience = linearConversion [_animDuration, 0, _animTime - time, _currentExperience, _currentExperience + _milestoneXp, true];
                    ["updateXpProgress", [_display, _newExperience]] call SELF;
                };

                _currentExperience = _newExperience;

                uiSleep 0.2;
            } forEach _milestones;

        };
    };

    case "updateLevelsHeader": {
        params ["_display", "_levelingData"];

        private _currentLevelData = vgm_g_leveling_levelsHashMap get (_levelingData get "level");
        private _nextLevelData = vgm_g_leveling_levelsHashMap get LEVEL_NEXT(_levelingData get "level");

        private _ctrlCurrentLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELCURRENT;
        _ctrlCurrentLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _currentLevelData get "displayName"];

        private _ctrlNextLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELNEXT;
        _ctrlNextLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _nextLevelData get "displayName"];

        ["updateXpProgress", [_display, _levelingData get "experience", _currentLevelData get "experienceThreshold"]] call SELF;
    };

    case "updateXpProgress": {
        params ["_display", "_leftXp", "_rightXp"];

        private _ctrlProgressBarText = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPPROGRESS;
        if (isNil "_rightXp") then {
            _rightXp = _ctrlProgressBarText getVariable "vgm_rightXp";
        } else {
            _ctrlProgressBarText setVariable ["vgm_rightXp", _rightXp];
        };

        _ctrlProgressBarText ctrlSetText format ["%1 / %2", _leftXp toFixed 0, _rightXp];

        private _ctrlProgress = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELPROGRESS;
        _ctrlProgress progressSetPosition (_leftXp / _rightXp);
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
