// Macros
#define CHECK(CONDITION) \
	if (CONDITION) exitWith {};

// Cancel
#define IDC_CANCEL 2

// Scripts
#define GROUPS								{ _this call (missionNamespace getVariable ["para_c_fnc_dynamicGroups", {}]); }
#define DISPLAY								{ _this call (missionNamespace getVariable ["para_c_fnc_ui_dynamicGroups", {}]); }

// Variables
#define PARA_C_DYNAMICGROUPS_INITIALIZED_VAR                        "para_c_dg_ini"
#define PARA_C_DYNAMICGROUPS_MAX_UNITS_PER_GROUP_VAR                "para_c_dg_mupg"
#define PARA_C_DYNAMICGROUPS_MINIMAL_INTERACTION_VAR                "para_c_dg_mii"
#define PARA_C_DYNAMICGROUPS_FORCED_INSIGNIA_VAR                    "para_c_dg_fia"
#define PARA_C_DYNAMICGROUPS_GROUP_REGISTERED_VAR                   "para_c_dg_reg"
#define PARA_C_DYNAMICGROUPS_GROUP_CREATOR_VAR                      "para_c_dg_cre"
#define PARA_C_DYNAMICGROUPS_GROUP_INSIGNIA_VAR                     "para_c_dg_ins"
#define PARA_C_DYNAMICGROUPS_GROUP_PRIVATE_VAR                      "para_c_dg_pri"
#define PARA_C_DYNAMICGROUPS_GROUP_VAR_VAR                          "para_c_dg_var"
#define PARA_C_DYNAMICGROUPS_KICKED_BY_VAR                          "para_c_dg_kic"
#define PARA_C_DYNAMICGROUPS_INVITES_VAR                            "para_c_dg_inv"
#define PARA_C_DYNAMICGROUPS_UI_DISPLAY_VAR                         "para_c_dynamicGroups_display"
#define PARA_C_DYNAMICGROUPS_ON_CLIENT_MESSAGE_VAR                  "para_c_dynamicGroups_clientMessage"
#define PARA_C_DYNAMICGROUPS_PLAYER_DRAW3D_VAR                      "para_c_dynamicGroups_draw3D"
#define PARA_C_DYNAMICGROUPS_LAST_UPDATE_TIME_VAR                   "para_c_dynamicGroups_lastUpdateTime"
#define PARA_C_DYNAMICGROUPS_PLAYER_RESPAWN_KEYDOWN_VAR             "para_c_dynamicGroups_respawnKeyDown"
#define PARA_C_DYNAMICGROUPS_OLD_GROUPS_LIST_VAR                    "para_c_dynamicGroups_oldGroupsList"
#define PARA_C_DYNAMICGROUPS_OLD_GROUPS_DATA_LIST_VAR               "para_c_dynamicGroups_oldGroupsDataList"
#define PARA_C_DYNAMICGROUPS_OLD_GROUPS_PLAYERS_LIST_VAR            "para_c_dynamicGroups_oldGroupsPlayersList"
#define PARA_C_DYNAMICGROUPS_OLD_GROUPS_DATA_PLAYERS_LIST_VAR       "para_c_dynamicGroups_oldGroupsPlayersDataList"
#define PARA_C_DYNAMICGROUPS_OLD_PLAYERS_LIST_VAR                   "para_c_dynamicGroups_oldPlayersList"
#define PARA_C_DYNAMICGROUPS_OLD_MEMBERS_LIST_VAR                   "para_c_dynamicGroups_oldMembersList"
#define PARA_C_DYNAMICGROUPS_SHOW_GROUPS_VAR                        "para_c_dynamicGroups_showGroups"
#define PARA_C_DYNAMICGROUPS_LAST_PLAYER_GROUP_VAR                  "para_c_dynamicGroups_lastPlayerGroup"
#define PARA_C_DYNAMICGROUPS_HAS_FOCUS_VAR                          "para_c_dynamicGroups_hasFocus"
#define PARA_C_DYNAMICGROUPS_SELECTED_MEMBER_VAR                    "para_c_dynamicGroups_selectedMember"
#define PARA_C_DYNAMICGROUPS_SELECTED_PLAYER_VAR                    "para_c_dynamicGroups_selectedPlayer"
#define PARA_C_DYNAMICGROUPS_SELECTED_GROUPORPLAYER_VAR             "para_c_dynamicGroups_selectedGroupOrPlayer"
#define PARA_C_DYNAMICGROUPS_OLD_MEMBERS_VAR                        "para_c_dynamicGroups_oldMembers"
#define PARA_C_DYNAMICGROUPS_OLD_PLAYERS_VAR                        "para_c_dynamicGroups_oldPlayers"
#define PARA_C_DYNAMICGROUPS_OLD_GROUPS_VAR                         "para_c_dynamicGroups_oldGroups"
#define PARA_C_DYNAMICGROUPS_OLD_GROUP_VAR                          "para_c_dynamicGroups_oldGroup"
#define PARA_C_DYNAMICGROUPS_COLLAPSED_GROUPS_VAR                   "para_c_dynamicGroups_collapsedGroups"
#define PARA_C_DYNAMICGROUPS_ALLOW_INTERFACE_VAR                    "para_c_dynamicGroups_allowInterface"
#define PARA_C_DYNAMICGROUPS_KEY_VAR                                "para_c_dynamicGroups_key"
#define PARA_C_DYNAMICGROUPS_KEY_MAIN_VAR                           "para_c_dynamicGroups_keyMain"
#define PARA_C_DYNAMICGROUPS_KEYDOWNTIME_VAR                        "para_c_dynamicGroups_keyDownTime"
#define PARA_C_DYNAMICGROUPS_IGNORE_INTERFACE_OPENING_VAR           "para_c_dynamicGroups_ignoreInterfaceOpening"
#define PARA_C_DYNAMICGROUPS_LAST_INSIGNIA_VAR                      "para_c_dynamicGroups_lastInsignia"
#define PARA_C_DYNAMICGROUPS_AVAILABLE_INSIGNIA_VAR                 "para_c_dynamicGroups_availableInsignia"

// Misc
#define PARA_C_DYNAMICGROUPS_UI_OPEN_KEY							"TeamSwitch"
#define PARA_C_DYNAMICGROUPS_DEFAULT_INSIGNIA					    "BI"
#define PARA_C_DYNAMICGROUPS_HOLD_DOWN_TIME_FOR_INVITE_ACCEPT	    0.7
#define PARA_C_DYNAMICGROUPS_INTERFACE_UPDATE_DELAY				    0.4
#define PARA_C_DYNAMICGROUPS_INVITE_LIFETIME						60
#define PARA_C_DYNAMICGROUPS_IS_PUBLIC							    true
#define PARA_C_DYNAMICGROUPS_IS_LOCAL							    false
#define PARA_C_DYNAMICGROUPS_LOG_ENABLED							true
#define PARA_C_DYNAMICGROUPS_SECTION_FADE_TIME 					    0.2
#define PARA_C_DYNAMICGROUPS_UPDATE_RATE							2.0
#define PARA_C_DYNAMICGROUPS_MAX_GROUP_NAME_SIZE					20
#define PARA_C_DYNAMICGROUPS_COLOR_DEFAULT						    0.1, 0.1, 0.1, 0.9
#define PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_CONFIG					{PARA_C_DYNAMICGROUPS_COLOR_DEFAULT}
#define PARA_C_DYNAMICGROUPS_COLOR_DEFAULT_ARRAY					[PARA_C_DYNAMICGROUPS_COLOR_DEFAULT]
#define PARA_C_DYNAMICGROUPS_COLOR_SELF							    [PARA_C_DYNAMICGROUPS_COLOR_DEFAULT]
#define PARA_C_DYNAMICGROUPS_COLOR_LOCKED						    [0.5, 0.5, 0.5, 1.0]
#define PARA_C_DYNAMICGROUPS_COLOR_DEAD							    [0.5, 0.5, 0.5, 0.6]
#define PARA_C_DYNAMICGROUPS_COLOR_GROUP							[0.0, 0.5, 0.0, 1.0]
#define PARA_C_DYNAMICGROUPS_COLOR_INCAPACITATED					[0.5, 0.0, 0.0, 1.0]
#define PARA_C_DYNAMICGROUPS_ICON_KIA							    "a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa"
#define PARA_C_DYNAMICGROUPS_ICON_REVIVE							"A3\Ui_f\data\GUI\Rsc\RscDisplayEGSpectator\ReviveIcon_ca.paa"
#define PARA_C_DYNAMICGROUPS_ICON_GENERAL						    "a3\Ui_f\data\GUI\Cfg\Ranks\general_gs.paa"
#define PARA_C_DYNAMICGROUPS_ICON_LOCK							    "a3\Ui_f\data\GUI\Rsc\RscDisplayDynamicGroups\Lock.paa"
#define PARA_C_DYNAMICGROUPS_UNSORTED_GROUP_ID					    localize "STR_A3_RscDisplayDynamicGroups_Ungrouped"
#define PARA_C_DYNAMICGROUPS_UNSORTED_GROUP_DATA					"UnsortedGroupData"
#define PARA_C_DYNAMICGROUPS_NEEDS_REVIVE_VAR					    "para_c_dynamicGroups_revive_incapacitated"

