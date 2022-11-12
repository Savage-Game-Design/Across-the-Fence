/*
    File: fn_interactionOverlay_init.sqf
    Author:  Savage Game Design
    Public: No
    
    Description:
        Initializes the Interaction HUD main Event Handler.
    
    Parameter(s): none
    
    Returns:
		False if HUD has already been initialized [Boolean]
    
    Example(s): none
*/

private _previousHandler = missionNamespace getVariable ["#para_InteractionOverlay_EventHandler", -1];
if (_previousHandler > -1) exitWith { false };

private _settingsConfig = missionConfigFile >> "gamemode" >> "interaction_overlay" >> "Settings";
para_c_InteractionOverlay_Settings_liveText = [false,true]#(getNumber (_settingsConfig >> "liveText"));
para_c_InteractionOverlay_Settings_distance = getNumber (_settingsConfig >> "distance");
para_c_InteractionOverlay_Settings_defaultKey = getNumber (_settingsConfig >> "defaultKey");
para_c_InteractionOverlay_Settings_lookAngle = 45;

para_c_InteractionOverlay_Settings_toggled = true;
"para_InteractionOverlay_state" cutRsc ["para_InteractionOverlay_state", "PLAIN", -1, false];

// Showing / Hiding the HUD
private _eventId = addMissionEventHandler ["Draw3D", para_c_fnc_interactionOverlay_onDraw3D];

missionNamespace setVariable ["#para_InteractionOverlay_EventHandler", _eventId];
true;