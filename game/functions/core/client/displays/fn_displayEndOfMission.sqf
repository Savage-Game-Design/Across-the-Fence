#include "macros.inc"
/*
    File: game/functions/core/client/displays/fn_displayEndOfMission.sqf
    Author: Savage Game Design
    Date: 2023-09-25
    Last Update: 2025-03-05
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

            _milestones = [
                createHashMapFromArray [
                    ["simple",[ ["mission_success",50] ]],
                    ["scouting", [
                        [createHashMapFromArray [["index",1],["position",["not_complete",0]]], 0],
                        [createHashMapFromArray [["index",2],["type", ["correct",0]], ["photo",["detailed",25]],["position",["close",100]]], 125],
                        [createHashMapFromArray [["index",3],["position",["not_usable",0]]], 0]
                    ]]
                ],
                175
            ];
            _dialog = createDialog ["VGM_DisplayEndOfMission", true];
            _levelingDataCopy = +(player getVariable "vgm_g_levelingData");
            ["renderProgress", [_dialog, [_levelingDataCopy, _milestones]]] call vgm_c_fnc_displayEndOfMission;

*/

#define SELF vgm_c_fnc_displayEndOfMission

#define LEVEL_NEXT(LEVEL) ((LEVEL) + 1 min vgm_g_leveling_maxLvl)

params ["_mode", "_this"];

switch _mode do {
    case "onLoad": {
        params ["_display"];

        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE) ctrlSetFade 1;
        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE) ctrlCommit 0;
        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN) ctrlSetText "";
    };

    case "onUnload": {
        params ["_display"];

        terminate (_display getVariable ["vgm_progressScript", scriptNull]);
    };

    case "renderProgress": {
        params ["_display", "_args"];
        _args params ["_levelingData", "_milestonesData"];

        private _currentLevel = _levelingData get "level";
        private _experienceOffset = vgm_g_leveling_levelsHashMap get (_currentLevel - 1) get "experienceThreshold";

        ["updateLevelsHeader", [_display, _levelingData, _experienceOffset]] call SELF;

        private _script = [_display, [_levelingData, _milestonesData select 0]] spawn {
            params ["_display", "_args"];
            _args params ["_levelingData", "_milestones"];

            private _ctrlCurrentLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELCURRENT;
            private _ctrlNextLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELNEXT;

            private _ctrlBreakdown = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN;
            private _ctrlLevelUp = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE;

            private _currentExperience = _levelingData get "experience";
            private _currentLevel = _levelingData get "level";
            private _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;
            private _experienceThreshold = _currentLevelData get "experienceThreshold";
            private _experienceOffset = vgm_g_leveling_levelsHashMap get (_currentLevel - 1) get "experienceThreshold";

            private _isFailure = (_milestones get "simple") findIf {_x param [0, ""] == "mission_failure"} > -1;

            private _text = [];
            // Update XP every Milestone
            {
                #define LINE_SEPARATOR '<t size="0.1"></t>'

                private _milestoneType = _x;
                private _milestoneValues = _y;
                private _milestoneValuesCount = count _milestoneValues;
                {
                    uiSleep 0.5;

                    private _milestoneAnimXp = 0;
                    if (_milestoneType == "simple") then {
                        if (_forEachIndex == 0) then {
                            _text pushBack '<t size="1.2">General</t>';
                        };

                        _x params ["_milestoneName", "_milestoneXp", ["_formatData", []]];
                        _milestoneAnimXp = _milestoneXp;

                        _formatData = if (_formatData isEqualType []) then {_formatData} else {[_formatData]};
                        private _milestoneText = localize format ["STR_VGM_MISSION_END_UI_MILESTONE_%1", _milestoneName];
                        _milestoneText = format ([_milestoneText] + _formatData);

                        _text pushBack format ["%1: %2XP", _milestoneText, _milestoneXp];
                    };

                    if (_milestoneType == "scouting") then {
                        if (_forEachIndex == 0) then {
                            _text pushBack LINE_SEPARATOR;
                            _text pushBack '<t size="1.2">Sites</t>';
                        };

                        _x params ["_scoutingMilestone", "_milestoneXp"];
                        _milestoneAnimXp = _milestoneXp;

                        private _milestoneText = format ["%1. ", _scoutingMilestone get "index"];
                        private _rowTemplate = format ['
                            <t>
                                Position: <t size="0.75">%%1</t><br/>
                                %1Photo: <t size="0.75">%%2</t><br/>
                                %1Type: <t size="0.75">%%3</t><br/>
                                %1Total: %%4XP
                            </t><br/>
                        ', '&#160;&#160;&#160;&#160;&#160;'];

                        private _positionLabel = _scoutingMilestone get "position" param [0, "not_complete"];
                        if (_positionLabel == "not_complete") then {
                            _milestoneText = _milestoneText + format [_rowTemplate,
                                localize "STR_VGM_MISSION_END_UI_MILESTONE_SITE_POSITION_NOT_COMPLETE",
                                "N/A",
                                "N/A",
                                _milestoneXp
                            ];
                        } else {
                            if (_positionLabel == "not_usable") exitWith {
                                _milestoneText = _milestoneText + format [_rowTemplate,
                                    localize "STR_VGM_MISSION_END_UI_MILESTONE_SITE_POSITION_NOT_USABLE",
                                    "N/A",
                                    "N/A",
                                    _milestoneXp
                                ];
                            };

                            _milestoneText = _milestoneText + format [_rowTemplate,
                                localize ("STR_VGM_MISSION_END_UI_MILESTONE_SITE_POSITION_" + (_scoutingMilestone get "position" select 0)),
                                localize ("STR_VGM_MISSION_END_UI_MILESTONE_SITE_PHOTO_" + (_scoutingMilestone get "photo" select 0)),
                                localize ("STR_VGM_MISSION_END_UI_MILESTONE_SITE_TYPE_" + (_scoutingMilestone get "type" select 0)),
                                _milestoneXp
                            ];
                        };
                        _text pushBack _milestoneText;
                    };

                    _ctrlBreakdown ctrlSetStructuredText parseText (_text joinString "<br/>");
                    _ctrlBreakdown ctrlSetPositionH (ctrlTextHeight _ctrlBreakdown);
                    _ctrlBreakdown ctrlCommit 0;
                    uiSleep 0.001; // we need a frame delay for the ctrlSetScrollValues to work
                    ctrlParentControlsGroup _ctrlBreakdown ctrlSetScrollValues [1, -1];

                    if (isGameFocused) then {
                        playSoundUI ["\a3\sounds_f\sfx\blip1.wss", 0.2];
                    };

                    // speed up the animation if there are a lot of milestones
                    private _animCoef = 1 / ((_milestoneValuesCount / 5) max 1);

                    // skip XP animation if mission was failed
                    if (_isFailure) then {
                        uiSleep (1.5 * _animCoef);
                        continue;
                    };

                    private _animDuration = (1 + (_milestoneAnimXp / 500)) * _animCoef;
                    private _time = time;
                    private _animTime = _time + _animDuration;
                    private _newExperience = _currentExperience;

                    // XP gain animation
                    while {_time < _animTime} do {
                        uiSleep 0.05; _time = _time + 0.05;

                        _newExperience = linearConversion [_animDuration, 0, _animTime - _time, _currentExperience, _currentExperience + _milestoneAnimXp, true];
                        _newExperience = _newExperience min vgm_g_leveling_maxExperience;
                        ["updateXpProgress", [_display, _newExperience, nil, _experienceOffset]] call SELF;

                        // level up
                        if (_newExperience >= _experienceThreshold) then {
                            playSoundUI ["\a3\sounds_f\sfx\UI\Tactical_Ping\Tactical_Ping.wss", 0.2];

                            _currentLevel = LEVEL_NEXT(_currentLevel);
                            _currentLevelData = vgm_g_leveling_levelsHashMap get _currentLevel;
                            _experienceOffset = _experienceThreshold;
                            _experienceThreshold = _currentLevelData get "experienceThreshold";

                            ["updateXpProgress", [_display, _newExperience, _experienceThreshold, _experienceOffset]] call SELF;
                            // increase current and next level texts
                            _ctrlCurrentLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _currentLevelData get "displayName"];
                            private _nextLevelData = vgm_g_leveling_levelsHashMap get LEVEL_NEXT(_currentLevel);
                            _ctrlNextLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _nextLevelData get "displayName"];
                            // show level up toast
                            _ctrlLevelUp ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL_UP", _currentLevelData get "skillPoints"];
                            _ctrlLevelUp ctrlSetFade 0;
                            _ctrlLevelUp ctrlCommit 0.5;
                            waitUntil {ctrlCommitted _ctrlLevelUp};
                            _ctrlLevelUp ctrlSetFade 1;
                            _ctrlLevelUp ctrlCommit 2.5;
                            waitUntil {ctrlCommitted _ctrlLevelUp};
                        };
                    };

                    _currentExperience = _newExperience;

                    uiSleep (0.2 * _animCoef);
                } forEach _milestoneValues;
            } forEach _milestones;
        };

        _display setVariable ["vgm_progressScript", _script];
    };

    case "updateLevelsHeader": {
        params ["_display", "_levelingData", "_offset"];

        private _currentLevelData = vgm_g_leveling_levelsHashMap get (_levelingData get "level");
        private _nextLevelData = vgm_g_leveling_levelsHashMap get LEVEL_NEXT(_levelingData get "level");

        private _currentExperience = _levelingData get "experience";
        private _nextLevelExperienceThreshold = [_currentLevelData get "experienceThreshold", _currentExperience] select (_currentLevelData isEqualTo _nextLevelData);

        private _ctrlCurrentLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELCURRENT;
        _ctrlCurrentLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _currentLevelData get "displayName"];

        private _ctrlNextLevel = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELNEXT;
        _ctrlNextLevel ctrlSetText format [localize "STR_VGM_MISSION_END_UI_LEVEL", _nextLevelData get "displayName"];

        ["updateXpProgress", [_display, _currentExperience, _nextLevelExperienceThreshold, _offset]] call SELF;
    };

    case "updateXpProgress": {
        params ["_display", "_leftXp", "_rightXp", ["_offset", 0]];

        private _ctrlProgressBarText = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_XPPROGRESS;
        if (isNil "_rightXp") then {
            _rightXp = _ctrlProgressBarText getVariable "vgm_rightXp";
        } else {
            _ctrlProgressBarText setVariable ["vgm_rightXp", _rightXp];
        };

        _ctrlProgressBarText ctrlSetText format ["%1 / %2", _leftXp toFixed 0, _rightXp];

        private _ctrlProgress = _display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_LEVELPROGRESS;
        if (_leftXp == _rightXp) exitWith {
            _ctrlProgress progressSetPosition 1;
        };
        _ctrlProgress progressSetPosition ((_leftXp - _offset) / (_rightXp - _offset));
    };

    case "updateEndStatus": {
        params ["_display", "_endType"];

        private _text = switch (_endType) do {
            case "SUCCESS": {localize "STR_VGM_MISSION_END_UI_SUCCESSFUL"};
            case "FAILURE": {localize "STR_VGM_MISSION_END_UI_FAILURE"};
            default {_endType};
        };

        (_display displayCtrl VGM_IDC_DISPLAYENDOFMISSION_STATUS) ctrlSetText _text;
    };

    default {
        format ["Invalid mode provided - %1", _mode] call vgm_g_fnc_logError;
    };
};
