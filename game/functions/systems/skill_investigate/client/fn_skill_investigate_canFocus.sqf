/*
    File: fn_skill_investigate_canFocus.sqf
    Author:
    Date: 2025-01-05
    Last Update: 2025-08-31
    Public: Yes

    Description:
        Checks if the player is eligible to focus.

    Parameter(s):
        None

    Returns:
        True if the player is able to focus [BOOL]

    Example(s):
        [] call vgm_c_fnc_skill_investigate_canFocus;
 */

player getUnitTrait "vgm_skill_investigate_canMoveFreely"
// bipod anims have varying names so simply check if it's deployed
|| isWeaponDeployed player
|| {
    animationState player select [9, 3] isEqualTo "stp"
    // checking animation "step" allows us to catch "odd" ones like rolling while prone
    && vectorMagnitude (player getUnitMovesInfo 4) < 1 // return
} // return
