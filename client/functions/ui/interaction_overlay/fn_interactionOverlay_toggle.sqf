/*
 *   File: fn_interactionOverlay_toggle.sqf
 *   Function: 
 *   Created: Heyoxe (https://github.com/Heyoxe/), 15.09.2020
 *   Updated: Heyoxe (https://github.com/Heyoxe/), 19.09.2020
 *   Public: No
 *   
 *   Description:
 *   	No description added yet.
 *   
 *   Environment: Unscheduled
 *   Parameters:
 *      0 - _variableName: <TYPE> (default: 0) Parameter description.
 *   
 *   Returns:
 *      <TYPE> Return description.
 *   
 *   Examples: none
 */

para_c_InteractionOverlay_Settings_toggled = !para_c_InteractionOverlay_Settings_toggled;
[
	[
		"Interaction Overlay",
		[localize "STR_vn_mf_hud_toggledOff", localize "STR_vn_mf_hud_toggledOn"] select para_c_InteractionOverlay_Settings_toggled
	]
] call para_c_fnc_postNotification;

private _icon = format ["\vn\ui_f_vietnam\ui\interactionOverlay\hud-%1.paa", ["off", "on"] select para_c_InteractionOverlay_Settings_toggled];
private _control = uiNamespace getVariable ["#para_InteractionOverlay_state_Icon", controlNull];
_control ctrlSetText _icon;

if (!para_c_InteractionOverlay_Settings_toggled) then {
	[] spawn para_c_fnc_interactionOverlay_hide;
};
