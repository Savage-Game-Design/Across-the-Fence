/*
 * File: fn_createGroup
 * Author: Spoffy
 * Description:
 *    Wrapper around script command 'createGroup', to allow us to implement gamemode-specific functionality.
 * Params:
 *    _side - Side of the group
 *    _deleteWhenEmpty - Whether or not to delete the group when empty. Defaults to true.
 * Returns:
 *    Group created
 * Example Usage:
 *    [east, false] call vn_mf_fnc_create_group
 */

params ["_side", ["_deleteWhenEmpty", true]];

createGroup [_side, _deleteWhenEmpty];