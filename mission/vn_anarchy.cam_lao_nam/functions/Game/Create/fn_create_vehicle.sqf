/*
 * File: fn_createVehicle.sqf
 * Author: Spoffy
 * Description:
 *    Wrapper around script command 'createVehicle'
 * Params:
 *    Same as 'createVehicle'
 * Returns:
 *    Created vehicle, or objNull if not possible.
 * Example Usage:
 *    Example usage goes here
 */

params ["_type", "_position", ["_markers", []], ["_placement", 0], ["_special", "NONE"]];

createVehicle [_type, _position, _markers, _placement, _special];