/*
    File: fn_voicelines_init.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Initializes the centralized voice line system. Sets up voice line pools
        organized by category/subcategory, cooldown state, and the invisible COVEY
        radio unit used for sideRadio broadcasts.

        Voice lines use SOG Prairie Fire's CfgRadio entries (vn_radiocom_coop_*)
        which are already defined in the mod. sideRadio broadcasts to all BLUFOR
        players with subtitles in side chat.

        Two tiers:
        - Always play: Helicopter comms (insertion, extraction) - pilot has radio
        - RTO-gated: COVEY intel (combat, tracker, CAS) - requires vn_artillery trait

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        call vgm_s_fnc_voicelines_init;
*/

if (!isServer) exitWith {};

// ---- Voice Line Pools ----
// HashMap: category -> subcategory -> [CfgRadio classnames]
vgm_s_voicelines_pools = createHashMap;

// INSERTION (no RTO required - heli crew comms)
private _insertion = createHashMap;
_insertion set ["lz_approach", [
    "vn_radiocom_coop_01_01",  // "LZ spotted, standby for insertion."
    "vn_radiocom_coop_02_02",  // "LZ in sight, 2 mikes, lock n load"
    "vn_radiocom_coop_05_01"   // "There's your LZ, looks quiet down there, you good?"
]];
_insertion set ["lz_hot", [
    "vn_radiocom_coop_04_15",  // "...Keep shooting, the Kingbees will be there in 2 mikes."
    "vn_radiocom_coop_06_04"   // "...roger, get us help now!"
]];
vgm_s_voicelines_pools set ["insertion", _insertion];

// EXTRACTION (no RTO required - heli crew comms)
private _extraction = createHashMap;
_extraction set ["inbound", [
    "vn_radiocom_coop_02_04",  // "...roger, slicks inbound, three mikes."
    "vn_radiocom_coop_02_11",  // "...slicks will be there in 2 mikes."
    "vn_radiocom_coop_04_15"   // "...Keep shooting, the Kingbees will be there in 2 mikes."
]];
_extraction set ["arrival", [
    "vn_radiocom_coop_01_10",  // "Hello! ...do you guys need a ride home?"
    "vn_radiocom_coop_02_05",  // "Hi ...you guys ready to go home?"
    "vn_radiocom_coop_06_40",  // "Hey ..., you comin or what?"
    "vn_radiocom_coop_03_17"   // "...let's get going, beaucoup VC will be on us soon."
]];
_extraction set ["liftoff", [
    "vn_radiocom_coop_01_11",  // "KINGBEE, I'm gonna kiss you when we land..."
    "vn_radiocom_coop_03_18"   // "...I'm sure glad to see you. Get us outta this hell-hole."
]];
_extraction set ["lz_compromised", [
    "vn_radiocom_coop_03_13",  // "...there are enemy forces converging from the north, east and west"
    "vn_radiocom_coop_05_03"   // "...It looks busy down there...I'll bring the air back as soon as you need it."
]];
_extraction set ["lz_cleared", [
    "vn_radiocom_coop_01_10",  // "Hello! ...do you guys need a ride home?"
    "vn_radiocom_coop_05_01"   // "There's your LZ, looks quiet down there, you good?"
]];
_extraction set ["lz_timeout", [
    "vn_radiocom_coop_01_05",  // "...Roger, head south. Out."
    "vn_radiocom_coop_02_14"   // "...Can't see anywhere down here. Got voices all around us..."
]];
vgm_s_voicelines_pools set ["extraction", _extraction];

// COMBAT (RTO required - COVEY intel)
private _combat = createHashMap;
_combat set ["prairie_fire", [
    "vn_radiocom_coop_01_06",  // "...Prairie Fire! Prairie Fire! They're comin' for us..."
    "vn_radiocom_coop_04_12",  // "...Prairie Fire! Prairie Fire! We need extraction NOW!"
    "vn_radiocom_coop_05_13"   // "...Prairie Fire! Prairie Fire! Need extraction... need tac-air..."
]];
_combat set ["heavy_contact", [
    "vn_radiocom_coop_01_08",  // "...They're on top of us! Give me 20 mike mike, rockets and nape..."
    "vn_radiocom_coop_02_10",  // "...They're on top of us. Where are the Slicks?"
    "vn_radiocom_coop_06_04"   // "...roger, get us help now!"
]];
_combat set ["status_check", [
    "vn_radiocom_coop_06_41"   // "...How're you holding up?"
]];
vgm_s_voicelines_pools set ["combat", _combat];

// CAS (naturally RTO-gated - only RTO can call CAS)
private _cas = createHashMap;
_cas set ["cas_inbound", [
    "vn_radiocom_coop_06_08",  // "...strike package on station, 1 mike out, where do you want it?"
    "vn_radiocom_coop_06_14"   // "SUNDOWNER strike package on station, whaddya need?"
]];
_cas set ["cas_run", [
    "vn_radiocom_coop_06_06",  // "...commencing run, holy shit this is hot... Yee Ha."
    "vn_radiocom_coop_06_10"   // "...smoke seen, rolling in."
]];
_cas set ["cas_effect", [
    "vn_radiocom_coop_06_11",  // "...good effect! You really knocked them dead"
    "vn_radiocom_coop_06_17"   // "...good effect, repeat strike..."
]];
_cas set ["cas_shootdown", [
    "vn_radiocom_coop_01_06",  // "...Prairie Fire! Prairie Fire! They're comin' for us..."
    "vn_radiocom_coop_05_13"   // "...Prairie Fire! Prairie Fire! Need extraction... need tac-air..."
]];
vgm_s_voicelines_pools set ["cas", _cas];

// TRACKER (RTO required - COVEY intel)
private _tracker = createHashMap;
_tracker set ["warning", [
    "vn_radiocom_coop_03_13",  // "...there are enemy forces converging from the north, east and west"
    "vn_radiocom_coop_01_05",  // "...Roger, head south. Out."
    "vn_radiocom_coop_05_03"   // "...It looks busy down there...I'll bring the air back as soon as you need it."
]];
vgm_s_voicelines_pools set ["tracker", _tracker];

// MISSION END
private _missionEnd = createHashMap;
_missionEnd set ["success", [
    "vn_radiocom_coop_02_03",  // "...Trucks destroyed. Well done!"
    "vn_radiocom_coop_02_17"   // "Geez, ...you guys sure know how to throw a party..."
]];
_missionEnd set ["surrounded", [
    "vn_radiocom_coop_02_14"   // "...Can't see anywhere down here. Got voices all around us..."
]];
vgm_s_voicelines_pools set ["mission_end", _missionEnd];

// PRISONER SNATCH (RTO required - COVEY intel)
private _snatch = createHashMap;
_snatch set ["briefing", [
    "vn_radiocom_coop_04_11"   // "We'll be on station for your snatch today. Kingbees will be orbiting."
]];
// target_down sequence: Columbia reports → Covey confirms → Columbia acknowledges
_snatch set ["target_down", [
    "vn_radiocom_coop_05_23"   // "COVEY, we have a BICYCLE. Tell HQ it might get us more air."
]];
_snatch set ["target_down_confirm", [
    "vn_radiocom_coop_05_24"   // "COLUMBIA, COVEY, Roger, confirm a living BICYCLE?"
]];
_snatch set ["target_down_ack", [
    "vn_radiocom_coop_05_25"   // "COVEY, that's a Roger. Now get us out of here."
]];
// extracting sequence: crew comment → banter pair
_snatch set ["extracting", [
    "vn_radiocom_coop_04_18"   // "Ok team, stop eyeing up our prize. It ain't happening!"
]];
_snatch set ["extracting_banter_1", [
    "vn_radiocom_coop_05_28"   // "Hey is that guy a General?"
]];
_snatch set ["extracting_banter_2", [
    "vn_radiocom_coop_05_29"   // "Negative he's a colonel, and boy does he look pissed."
]];
vgm_s_voicelines_pools set ["snatch", _snatch];

// BRIGHT LIGHT (RTO required - COVEY intel)
private _brightLight = createHashMap;
// In helicopter — briefing
_brightLight set ["briefing", [
    "vn_radiocom_coop_03_01"   // "Bright Light emergency! A Kingbee has gone down, crashed in the trees."
]];
// In helicopter — approaching crash site
_brightLight set ["approach", [
    "vn_radiocom_coop_03_02"   // "There's the crash site. We'll set you down here."
]];
// After landing — moving out exchange
_brightLight set ["moving_out", [
    "vn_radiocom_coop_03_03"   // "COVEY this is Spike Team COLUMBIA. Moving out."
]];
_brightLight set ["moving_out_response", [
    "vn_radiocom_coop_03_04"   // "COLUMBIA, COVEY, Roger that, Good hunting. Out."
]];
// Reaching crash site — secure + KIA report + COVEY response
_brightLight set ["crash_secure", [
    "vn_radiocom_coop_03_05"   // "COVEY, COLUMBIA, Crash site secure"
]];
_brightLight set ["crash_report", [
    "vn_radiocom_coop_03_07"   // "Package 1 secure, 3 KIA to pick up. Package 2 is probably nearby..."
]];
_brightLight set ["crash_report_response", [
    "vn_radiocom_coop_03_08"   // "COLUMBIA, COVEY, Roger, RT Raleigh will extract the KIAs..."
]];
// Finding the pilot — package 2 secured + enemy warning
_brightLight set ["target_picked_up", [
    "vn_radiocom_coop_03_12"   // "We have Package 2, one pilot. Give me a Lima Zulu."
]];
_brightLight set ["target_picked_up_response", [
    "vn_radiocom_coop_03_13"   // "COLUMBIA COVEY Good to hear from you again, enemy forces converging..."
]];
vgm_s_voicelines_pools set ["bright_light", _brightLight];

// HATCHET FORCE (no RTO required - recon team has their own radio)
private _hatchet = createHashMap;
_hatchet set ["briefing", [
    "vn_radiocom_coop_04_13"   // "COLUMBIA, COVEY, Roger, Wait out. All callsigns this is COVEY 59 declaring a Prairie Fire Emergency..."
]];
_hatchet set ["insertion_hot", [
    "vn_radiocom_coop_02_02"   // "LZ in sight, 2 mikes, lock n load"
]];
_hatchet set ["insertion_cold", [
    "vn_radiocom_coop_01_01"   // "LZ spotted, standby for insertion."
]];
_hatchet set ["team_contact", [
    "vn_radiocom_coop_03_18",  // "...I'm sure glad to see you. Get us outta this hell-hole."
    "vn_radiocom_coop_02_12",  // "Hi MINUTEMAN, yeah we're sure glad you made it in here. Beers are on us..."
    "vn_radiocom_coop_03_17"   // "Hey COLUMBIA let's get going, beaucoup VC will be on us soon."
]];
_hatchet set ["team_casualty", [
    "vn_radiocom_coop_02_14",  // "...Can't see anywhere down here. Got voices all around us..."
    "vn_radiocom_coop_06_41",  // "...How're you holding up?"
    "vn_radiocom_coop_06_04"   // "...roger, get us help now!"
]];
_hatchet set ["first_bird_inbound", [
    "vn_radiocom_coop_02_04"   // "...roger, slicks inbound, three mikes."
]];
_hatchet set ["player_bird_inbound", [
    "vn_radiocom_coop_02_11"   // "...slicks will be there in 2 mikes."
]];
_hatchet set ["player_bird_away", [
    "vn_radiocom_coop_02_17"   // "Geez, ...you guys sure know how to throw a party. Just look at the place!"
]];
vgm_s_voicelines_pools set ["hatchet", _hatchet];

// CHECK-IN (no RTO required - player-initiated, COVEY responds)
private _checkin = createHashMap;
_checkin set ["report", [
    "vn_radiocom_coop_01_02"   // "COVEY, Spike Team COLUMBIA. All clear."
]];
_checkin set ["acknowledge", [
    "vn_radiocom_coop_01_03"   // "COLUMBIA this is COVEY, Roger, Good hunting. Out."
]];
vgm_s_voicelines_pools set ["checkin", _checkin];

// ---- Cooldown State ----
// HashMap: "category_subcategory" -> last play time (serverTime)
vgm_s_voicelines_cooldowns = createHashMap;

// Global cooldown: minimum seconds between ANY voice line (prevents overlap)
vgm_s_voicelines_globalCooldown = 15;

// Last time ANY voice line played
vgm_s_voicelines_lastPlayTime = -999;

// Per-category cooldown overrides (seconds)
vgm_s_voicelines_categoryCooldowns = createHashMapFromArray [
    ["insertion", 60],
    ["extraction", 60],
    ["combat", 120],
    ["cas", 90],
    ["tracker", 180],
    ["mission_end", 30],
    ["snatch", 30],
    ["bright_light", 30],
    ["hatchet", 30],
    ["checkin", 30]
];

// ---- COVEY Radio Unit ----
// Invisible BLUFOR unit for sideRadio calls (non-vehicle radio comms)
private _coveyGroup = createGroup [west, true];
private _coveyUnit = _coveyGroup createUnit ["B_Soldier_F", [0,0,0], [], 0, "NONE"];
_coveyUnit allowDamage false;
hideObjectGlobal _coveyUnit;
_coveyUnit setPos [0,0,0];
vgm_s_voicelines_coveyUnit = _coveyUnit;

"VGM: Voice lines system initialized" call vgm_g_fnc_logInfo;
