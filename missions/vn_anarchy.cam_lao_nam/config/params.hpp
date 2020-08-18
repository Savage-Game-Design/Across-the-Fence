/*
    Author: Wyqer, veteran29
    Date: 2019-06-15

    Description:
        Basic mission parameters for the vn coop missions.
*/

// gamemode specific start

class ai_quantity
{
	title = $STR_vn_mf_ai_quantity;
	values[] = {0, 1};
	texts[] = {"Debug", "Normal"};
	default = 1;
};

class buildables_require_vehicles
{
    title = $STR_vn_mf_buildables_require_vehicles;
    values[] = {0, 1};
    texts[] = {"False", "True"};
    default = 0;
};

class dawn_length
{
    title = $STR_vn_mf_dawn_length;
    values[] = {600, 1200, 1800, 2400, 3600, 5400, 7200, 9000, 10800};
    texts[] = {"10 minutes", "20 minutes", "30 minutes", "40 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3 hours"};
    default = 1200;
};

class day_length
{
    title = $STR_vn_mf_day_length;
    values[] = {3600, 5400, 7200, 9000, 10800, 21600, 43200, 86400, 172800};
    texts[] = {"1 hour", "1.5 hours", "2 hours", "2.5 hours", "3 hours", "6 hours", "12 hours", "24 hours", "48 hours"};
    default = 7200;
};

class dusk_length
{
    title = $STR_vn_mf_dusk_length;
    values[] = {600, 1200, 1800, 2400, 3600, 5400, 7200, 9000, 10800};
    texts[] = {"10 minutes", "20 minutes", "30 minutes", "40 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3 hours"};
    default = 1200;
};

class night_length
{
    title = $STR_vn_mf_night_length;
    values[] = {600, 1200, 1800, 2400, 3600, 5400, 7200, 9000, 10800, 21600, 43200, 86400, 172800};
    texts[] = {"10 minutes", "20 minutes", "30 minutes", "40 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3 hours", "6 hours", "12 hours", "24 hours", "48 hours"};
    default = 1200;
};

class always_allow_withstand
{
    title = $STR_vn_mf_always_allow_withstand;
    values[] = {0, 1};
    texts[] = {"False", "True"};
    default = 1;
};

class building_supply_crate_value
{
    title = $STR_vn_mf_building_supply_crate_value;
    values[] = {500};
    texts[] = {"Default (500)"};
    default = 500;
};

class building_sandbag_value
{
    title = $STR_vn_mf_building_sandbag_value;
    values[] = {10};
    texts[] = {"Default (10)"};
    default = 10;
};
// gamemode specific stop


// TODO Decide if the BI Revive settings should be removed or if we handle this in an own function instead of the BI functions
class BiReviveSettings
{
    title = $STR_VN_PARAMS_REVIVE_BI_SETTINGS;
    values[] = {""};
    texts[] = {""};
    default = "";
};
class ReviveMode
{
    title = $STR_A3_ReviveMode;
    isGlobal = 1;
    values[] = {0, 1};
    texts[] = {$STR_A3_Disabled, $STR_A3_EnabledForAllPlayers};
    default = 0;
    function = "bis_fnc_paramReviveMode";
};
class ReviveDuration
{
    title = $STR_A3_ReviveDuration;
    isGlobal = 1;
    values[] = {6, 8, 10, 12, 15, 20, 25, 30};
    texts[] = {6, 8, 10, 12, 15, 20, 25, 30};
    default = 6;
    function = "bis_fnc_paramReviveDuration";
};
class ReviveRequiredTrait
{
    title = $STR_A3_RequiredTrait;
    isGlobal = 1;
    values[] = {0, 1};
    texts[] = {$STR_A3_None, $STR_A3_Medic};
    default = 1;
    function = "bis_fnc_paramReviveRequiredTrait";
};
class ReviveMedicSpeedMultiplier
{
    title = $STR_A3_RequiredTrait_MedicSpeedMultiplier;
    isGlobal = 1;
    values[] = {1, 1.5, 2, 2.5, 3};
    texts[] = {"1x", "1.5x", "2x", "2.5x", "3x"};
    default = 1;
    function = "bis_fnc_paramReviveMedicSpeedMultiplier";
};
class ReviveRequiredItems
{
    title = $STR_A3_RequiredItems;
    isGlobal = 1;
    values[] = {0, 1, 2};
    texts[] = {$STR_A3_None, $STR_A3_Medikit, $STR_A3_FirstAidKitOrMedikit};
    default = 1;
    function = "bis_fnc_paramReviveRequiredItems";
};
class UnconsciousStateMode
{
    title = $STR_A3_IncapacitationMode;
    isGlobal = 1;
    values[] = {0, 1, 2};
    texts[] = {$STR_A3_Basic, $STR_A3_Advanced, $STR_A3_Realistic};
    default = 0;
    function = "bis_fnc_paramReviveUnconsciousStateMode";
};
class ReviveBleedOutDuration
{
    title = $STR_A3_BleedOutDuration;
    isGlobal = 1;
    values[] = {10, 15, 20, 30, 45, 60, 90, 180};
    texts[] = {10, 15, 20, 30, 45, 60, 90, 180};
    default = 180;
    function = "bis_fnc_paramReviveBleedOutDuration";
};
class ReviveForceRespawnDuration
{
    title = $STR_A3_ForceRespawnDuration;
    isGlobal = 1;
    values[] = {3, 4, 5, 6, 7, 8, 9, 10};
    texts[] = {3, 4, 5, 6, 7, 8, 9, 10};
    default = 10;
    function = "bis_fnc_paramReviveForceRespawnDuration";
};

class Spacer1
{
    title = "";
    values[] = {""};
    texts[] = {""};
    default = "";
};

class ReviveSettings
{
    title = $STR_VN_PARAMS_REVIVE_SETTINGS;
    values[] = {""};
    texts[] = {""};
    default = "";
};
class vn_advanced_revive_params_toggle
{
        title = "Revive Mode /loc";
        values[] = {0, 1};
        texts[] = {"DLC /loc", "Off /loc"};
        default = 0;
};
class vn_advanced_revive_params_enable
{
        title = "Advanced Revive parameter override /loc";
        values[] = {0, 1};
        texts[] = {"Disabled /loc", "Enabled /loc"};
        default = 1; // TODO Toggle this to no override later?
};
class vn_advanced_revive_params_bleedout_time
{
        title = "Bleedout time";
        values[] = {1, 20, 40, 60, 90, 120, 180, 300, 420, 600};
        texts[] = {"None /loc", "20 seconds /loc", "40 seconds /loc", "1 minute /loc", "1.5 minute /loc", "2 minutes /loc", "3 minutes /loc", "5 minutes /loc", "7 minutes /loc", "10 minutes /loc"};
        default = 300;
};
class vn_advanced_revive_params_bandage_item
{
        title = "Required items (Stabilize) /loc";
        values[] = {0, 1, 2};
        texts[] = {"None /loc", "Medikit /loc", "First Aid Kit / Medikit /loc"};
        default = 2;
};
class vn_advanced_revive_params_remove_bandage_item
{
        title = "Remove stabilize item /loc";
        values[] = {0, 1};
        texts[] = {"Disbaled /loc", "Enabled /loc"};
        default = 1;
};
class vn_advanced_revive_params_revive_item
{
        title = "Required items (Resuscitate) /loc";
        values[] = {0, 1, 2};
        texts[] = {"None /loc", "Medikit /loc", "First Aid Kit / Medikit /loc"};
        default = 2;
};
class vn_advanced_revive_params_remove_revive_item
{
        title = "Remove Resuscitate item /loc";
        values[] = {0, 1};
        texts[] = {"Disbaled /loc", "Enabled /loc"};
        default = 1;
};
class vn_advanced_revive_params_revive_ability
{
        title = "Required Trait /loc";
        values[] = {0, 1};
        texts[] = {"None /loc", "Medic /loc"};
        default = 0;
};
class vn_advanced_revive_params_move_percentage
{
        title = "Incapacitated movement chance /loc";
        values[] = {0, 25, 50, 75, 100};
        texts[] = {"Disabled /loc", "25 /loc", "50 /loc", "75 /loc", "100 /loc"};
        default = 75;
};
class vn_advanced_revive_params_throw_percentage
{
        title = "Incapacitated throw/place chance /loc";
        values[] = {0, 25, 50, 75, 100};
        texts[] = {"Disabled /loc", "25 /loc", "50 /loc", "75 /loc", "100 /loc"};
        default = 75;
};
class vn_advanced_revive_params_respawn_action_percentage
{
        title = "Respawn action wait time /loc";
        values[] = {0, 25, 50, 75, 100};
        texts[] = {"Disabled /loc", "25 /loc", "50 /loc", "75 /loc", "100 /loc"};
        default = 75;
};
class vn_advanced_revive_params_bleedout_percentages
{
        title = "Percentage decay /loc";
        values[] = {0, 1};
        texts[] = {"Enabled /loc", "Disabled /loc"};
        default = 1;
};

class Spacer2: Spacer1 {};

class EnvironmentSettings
{
    title = $STR_VN_PARAMS_ENVIRONMENT_SETTINGS;
    values[] = {""};
    texts[] = {""};
    default = "";
};
class vn_difficulty
{
    title = $STR_VN_PARAMS_DIFFICULTY;
    values[] = {1, 2, 3, 4};
    texts[] = {$STR_VN_PARAMS_DIFFICULTY_EASY, $STR_VN_PARAMS_DIFFICULTY_NORMAL, $STR_VN_PARAMS_DIFFICULTY_HARD, $STR_VN_PARAMS_DIFFICULTY_HELL};
    default = 3; // TODO change to 1 in release
    function = "vn_ms_fnc_params_difficulty";
};
class vn_respawn_delay
{
    title = $STR_VN_PARAMS_RESPAWN_DELAY;
    isGlobal = 1;
    values[] = {10, 30, 60, 90, 120};
    texts[] = {"10", "30", "60", "90", "120"};
    default = 10; // TODO change to 60 in release
    function = "vn_ms_fnc_params_respawnDelay";
};
class vn_hints
{
    title = $STR_VN_PARAMS_HINTS;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 1;
    function = "vn_ms_fnc_params_hints";
};
class vn_stamina
{
    title = $STR_VN_PARAMS_STAMINA;
    isGlobal = 1;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 0; // TODO change to 1 in release
    function = "vn_ms_fnc_params_stamina";
};
class vn_aimCoef
{
    title = $STR_VN_PARAMS_AIMCOEF;
    isGlobal = 1;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 1; // TODO change to 0 in release
    function = "vn_ms_fnc_params_aimCoef";
};
class vn_failOnWipe
{
    title = $STR_VN_PARAMS_FAILONWIPE;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 0; // TODO change to 1 in release
    function = "vn_ms_fnc_params_failOnWipe";
};
class vn_teleportAction
{
    title = $STR_VN_PARAMS_TELEPORTACTION;
    isGlobal = 1;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 1;
    function = "vn_ms_fnc_params_teleportAction";
};

class Spacer3: Spacer1 {};

class ArsenalSettings
{
    title = $STR_VN_PARAMS_ARSENAL_SETTINGS;
    values[] = {""};
    texts[] = {""};
    default = "";
};
class vn_whitelisted_arsenal_params_enable
{
    title = $STR_VN_PARAMS_ARSENAL_TOGGLE;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_DISABLED, $STR_VN_MISSIONS_ENABLED};
    default = 0; // TODO change to 0 in release
};
class vn_whitelisted_arsenal_params_scope
{
    title = $STR_VN_PARAMS_ARSENAL_SCOPE;
    values[] = {0, 1, 2};
    texts[] = {$STR_VN_PARAMS_ARSENAL_SCOPE_DLC, $STR_VN_PARAMS_ARSENAL_SCOPE_CUSTOM, $STR_VN_PARAMS_ARSENAL_SCOPE_UNSUNG};
    default = 0;
};
class vn_whitelisted_arsenal_params_rank
{
    title = $STR_VN_PARAMS_ARSENAL_RANK;
    values[] = {0, 1};
    texts[] = {$STR_VN_MISSIONS_ENABLED, $STR_VN_MISSIONS_DISABLED};
    default = 1;
};
class vn_whitelisted_arsenal_params_side
{
    title = $STR_VN_PARAMS_ARSENAL_SIDE;
    values[] = {0, 1};
    texts[] = {$STR_VN_PARAMS_ARSENAL_SIDE_RESTRICTED, $STR_VN_PARAMS_ARSENAL_UNRESTRICTED};
    default = 1; // TODO change to 0 in release
};
class vn_whitelisted_arsenal_params_equipment
{
    title = $STR_VN_PARAMS_ARSENAL_EQUIPMENT;
    values[] = {0, 1, 2, 3};
    texts[] = {$STR_VN_PARAMS_ARSENAL_EQUIPMENT_EQUIPMENT, $STR_VN_PARAMS_ARSENAL_EQUIPMENT_VEHICLES, $STR_VN_PARAMS_ARSENAL_EQUIPMENT_BOTH, $STR_VN_PARAMS_ARSENAL_EQUIPMENT_NONE};
    default = 0;
};
