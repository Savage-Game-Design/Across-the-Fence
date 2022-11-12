/*
 *   File: fn_interactionOverlay_onDraw3D.sqf
 *   Function: para_c_fnc_interactionOverlay_onDraw3D
 *   Created: Heyoxe (https://github.com/Heyoxe/), 25.10.2020
 *   Updated: Heyoxe (https://github.com/Heyoxe/), 25.10.2020
 *   Public: No
 *   
 *   Description:
 *   	Handles Draw3D event
 *   
 *   Environment: Unscheduled
 *   Parameters: none
 *   
 *   Returns: nothing
 *   
 *   Examples: none
 */

if (para_c_InteractionOverlay_Settings_toggled) then {
	private _cursorObject = call para_c_fnc_interactionOverlay_intersect;
	// private _cursorObject = [cursorObject, getCursorObjectParams#0] select (isNull cursorObject); // Sometimes one returns NULL while the other not
	[(missionNamespace getVariable ["#para_InteractionOverlay_Object", objNull])] call para_c_fnc_interactionOverlay_update;
	if (
		/*
			Conditions, if any of these is trze, then hide the overlay
			Please put the '||' or '&&' operator on the start of the line so it can easily be commented out
		*/
		(isNull _cursorObject)
		|| {
			((_cursorObject distance player) > ((((boundingBox _cursorObject)#2) * 1.2) max para_c_InteractionOverlay_Settings_distance))		// Check if the object is to far
			|| (
				((_cursorObject getVariable ["para_wheel_menu_dyn_actions", []]) isEqualTo []) // Check if the object has interactions
				&& ((_cursorObject getVariable ["#para_InteractionOverlay_Data", []]) isEqualTo []) // Check if the object has data
			)
			|| !(isNull (uiNamespace getVariable ["vn_wheelmenu", displayNull])) // Check if the wheelmenu is opened
			|| dialog // Check if a dialog is opened
			|| !(alive player) // Check if player is alive
			|| !((incapacitatedState player) isEqualTo "") // Check if player is incapacited
			// || ((abs (player getRelDir getCursorObjectParams#0)) > 15) // Check if player is somewhat looking at the object
		}
	) then {
		if (missionNamespace getVariable ["#para_InteractionOverlay_Shown", false]) then {
			[] spawn para_c_fnc_interactionOverlay_hide;
		};
	} else {
		if !((missionNamespace getVariable ["#para_InteractionOverlay_Object", objNull]) isEqualTo _cursorObject) then {
			[_cursorObject] call para_c_fnc_interactionOverlay_modify;
		};
		missionNamespace setVariable ["#para_InteractionOverlay_Object", _cursorObject];
		if !(missionNamespace getVariable ["#para_InteractionOverlay_Shown", false]) then {
			[_cursorObject] spawn para_c_fnc_interactionOverlay_show;
		};
	};
};