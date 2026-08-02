/*
    File: fn_ron_cinematic.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Client-side RON cinematic. Fades screen to black, displays
        SOG-themed flavor text using player names, then waits for
        server to signal fade back in.

    Parameter(s):
        _outcome - "quiet" or "contact" [STRING]
        _names   - Array of player names in the group [ARRAY]

    Returns:
        Nothing (runs as spawned script)

    Example(s):
        ["quiet", ["Atlas", "Viper", "Snake"]] call vgm_c_fnc_ron_cinematic;
 */

params ["_outcome", "_names"];

if (!hasInterface) exitWith {};

// Ensure we have at least one name
if (_names isEqualTo []) then {
    _names = [name player];
};

private _leader = _names select 0;
private _other1 = if (count _names > 1) then {_names select (1 + floor random (count _names - 1))} else {""};
private _other2 = if (count _names > 2) then {
    private _pool = _names - [_leader, _other1];
    if (_pool isEqualTo []) then {""} else {selectRandom _pool}
} else {""};

// --- Flavor text pools ---

private _quietTexts = [];

// Build text lines based on team size
if (count _names == 1) then {
    _quietTexts = [
        format ["You leaned against a tree, weapon across your lap. Sleep came in fragments..."],
        format ["The jungle clicked and hummed around you. You peeled a leech off your collar in the dark..."],
        format ["Something large moved through the undergrowth fifty meters out. You froze, finger on the trigger. Minutes passed... nothing."],
        format ["You sat motionless, back against a tree. Centipedes crawled across your boots. The hours crept by..."],
        format ["No sleeping bag, no hammock. Just you and the dark. You dozed sitting upright, rifle ready..."]
    ];
} else {
    _quietTexts = [
        format ["%1 leaned against a tree, weapon across his lap. %2 sat nearby, listening to the dark. Sleep came in fragments...", _leader, _other1],
        format ["The jungle clicked and hummed around them. %1 peeled a leech off his collar by feel. No one really slept...", _other1],
        format ["%1 took first watch. %2 dozed sitting upright, rifle ready. Something moved in the treeline — just an animal...", _leader, _other1],
        format ["Something large circled their perimeter in the dark. %1 and %2 sat back to back, weapons ready. It never came closer...", _leader, _other1],
        format ["%1 pointed to the treeline — eyes wide. %2 shook his head slowly. Just an animal. The hours crawled by...", _other1, _leader]
    ];
};

if (_other2 != "") then {
    _quietTexts pushBack format ["%1 checked the claymores one last time. %2 and %3 sat in silence, backs against the same tree...", _leader, _other1, _other2];
    _quietTexts pushBack format ["%1 heard footsteps downhill — %2 raised a fist. The team froze. A deer broke through the brush. %3 exhaled slowly...", _other1, _leader, _other2];
};

private _contactTexts = [];

if (count _names == 1) then {
    _contactTexts = [
        format ["You sat motionless, rifle ready. A branch snapped nearby..."],
        format ["The jungle went quiet. Too quiet. Then — movement in the treeline..."],
        format ["You heard them before you saw them. Footsteps, deliberate and close..."]
    ];
} else {
    _contactTexts = [
        format ["%1 sat motionless, rifle ready. %2 tapped his shoulder twice — movement, close...", _leader, _other1],
        format ["The jungle went quiet. %1 held up a fist. Shapes in the treeline...", _leader],
        format ["%1 heard them first. A low whisper to %2 — footsteps, deliberate and near...", _other1, _leader]
    ];
};

// --- Cinematic sequence ---

// Fade to black
[true] call vgm_c_fnc_ron_fadeScreen;
sleep 2;

// Show flavor text
private _flavorText = if (_outcome == "quiet") then {
    selectRandom _quietTexts
} else {
    selectRandom _contactTexts
};

// titleText renders above the cut layer (visible on black screen)
titleText [format ["<t font='tt2020base_vn' color='#ffffff' size='3.5' align='center'>%1</t>", _flavorText], "PLAIN DOWN", -1, true, true];

sleep 5;

// Show outcome text
private _outcomeText = if (_outcome == "quiet") then {
    "The night was quiet..."
} else {
    "During watch, noises were heard in the jungle..."
};

titleText [format ["<t font='tt2020base_vn' color='#ffffff' size='4.5' align='center'>%1</t>", _outcomeText], "PLAIN DOWN", -1, true, true];

// Server handles the fade back in and time/spawn logic
