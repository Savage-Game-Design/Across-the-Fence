__EXEC(\
    _fnc_y_h = {\
        params ["_delta", "_gridH"];\
        _y = _y + _delta;\
        format ["%1 * %2", _delta, _gridH]\
    };\
    _fnc_y_y = {\
        params ["_anchor", "_delta", "_gridH"];\
        _y = _y + _delta;\
        diag_log _this;\
        format ["%1 + %2 * %3", _anchor, _y, _gridH]\
    };\
)
/*
    Macro: VGM_Y
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        Getter for the y offset.

    Parameter(s):
        ANCHOR - The origin of the display [MACRO]

    Returns:
        `y` attribute [STRING]

    Example(s):
        VGM_Y(VGM_GRID_MIN_Y)
*/
#define VGM_Y(ANCHOR) __EVAL(format ["%1 + %2 * %3", #ANCHOR, _y, #VGM_GRID_H])
/*
    Macro: VGM_SET_Y
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        Setter for the y offset.

    Parameter(s):
        Y - New value [NUMBER]

    Returns:
        nil

    Example(s):
        VGM_SET_Y(0)
*/
#define VGM_SET_Y(Y) __EXEC(_y = Y;)
/*
    Macro: VGM_Y_H
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        Assigns the given height to the control and also adds it to the y
        offset.

    Parameter(s):
        H - Height of the control [NUMBER]

    Returns:
        `h` attribute [STRING]

    Example(s):
        VGM_Y(VGM_GRID_MIN_Y)
*/
#define VGM_Y_H(H) __EVAL([H, #VGM_GRID_H] call _fnc_y_h)
/*
    Macro: VGM_Y_Y
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        Set the `y` attribute of a control while also adding a given number to
        the offset.

    Parameter(s):
        ANCHOR - The origin of the display [MACRO]
        H - Delta [NUMBER]

    Returns:
        `y` attribute [STRING]

    Example(s):
        VGM_Y_Y(VGM_GRID_MIN_Y,1)
*/
#define VGM_Y_Y(ANCHOR,H) __EVAL([#ANCHOR, H, #VGM_GRID_H] call _fnc_y_y)
