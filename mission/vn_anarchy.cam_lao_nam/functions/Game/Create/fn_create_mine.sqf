/*
 * File: fn_createMine.sqf
 * Author: Spoffy
 * Description:
 *    Wrapper around script command 'createMine'
 * Params:
 *    Same as 'createMine'
 * Returns:
 *    Created Mine, or objNull if not possible.
 * Example Usage:
 *    Example usage goes here
 */

params ["_type", "_position", ["_markers", []], ["_placement", 0]];

createMine [_type, _position, _markers, _placement];