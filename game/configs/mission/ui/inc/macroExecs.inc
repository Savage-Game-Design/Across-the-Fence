// Auxillary functions in the parsingNamespace
// Check macro documentation below for usage
__EXEC(\
    _fnc_y_h = {\
        params ["_delta", "_gridH"];\
        _y = _y + _delta;\
        format ["%1 * %2", _delta, _gridH]\
    };\
    _fnc_y_y = {\
        params ["_anchor", "_delta", "_gridH"];\
        _y = _y + _delta;\
        format ["%1 + %2 * %3", _anchor, _y, _gridH]\
    };\
    _fnc_VGMsizeEx = {\
        _pixelScale = 20 * VGM_PIXELSCALE;\
        _size = _this select 0;\
        _size = _size * _pixelScale;\
        _coef = _this select 1;\
        _sizes = _this select 2;\
        _sizeEx = _sizes select 0;\
        {\
            _xSize = _x * _coef;\
            _cond = _xSize < _size;\
            if _cond then {_sizeEx = _xSize;};\
        } foreach _sizes;\
        _sizeEx = _sizeEx / _pixelScale;\
        _bracketL = tostring [40];\
        _bracketR = tostring [41];\
        _pixelH = _bracketL + "1 / " + _bracketL + "getResolution select 3" + _bracketR + _bracketR;\
        str _sizeEx + " * " + _pixelH + " * pixelGridNoUIScale * " + str VGM_PIXELSCALE\
    };\
)
/*
    Macro: VGM_Y
    Author: Terra
    Date: 2023-02-03
    Public: No

    Description:
        Getter for the y offset. The y offset is the offset from a given base
        line (anchor). These macros are meant to keep track of the current y
        coordinate so if a control were to be removed later in development all
        the controls below are moved upwards as well.

    Parameter(s):
        ANCHOR - The origin of the display [MACRO]

    Returns:
        `y` attribute in format "ANCHOR + _y * VGM_GRID_H" [STRING]

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
        `h` attribute in format "H * VGM_GRID_H" [STRING]

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
        `y` attribute in format "ANCHOR + H * VGM_GRID_H" [STRING]

    Example(s):
        VGM_Y_Y(VGM_GRID_MIN_Y,1)
*/
#define VGM_Y_Y(ANCHOR,H) __EVAL([#ANCHOR, H, #VGM_GRID_H] call _fnc_y_y)

/*
    Macro: VGM_SIZEX_TT2020BASE
    Author: Savage Game Design
    Date: 2023-02-03
    Public: No

    Description:
        Calculates font height.

    Parameter(s):
        SIZEPX - Multiplier [NUMBER]

    Returns:
        `size(Ex)` attribute in format "CALCULATED_HEIGHT * (1 / (getResolution select 3)) * pixelGridNoUIScale * 0.375" - [STRING]

    Example(s):
        sizeEx = VGM_SIZEEX_TT2020BASE(SIZEEX_M);
        // Equivalent to:
        sizeEx = VGM_FONT_M;
        sizeEx = VGM_SIZEEX_TT2020BASE(SIZEEX_L);
        // Equivalent to:
        sizeEx = VGM_FONT_L;
*/
#define VGM_SIZEEX_TT2020BASE(SIZEPX) __EVAL([SIZEPX,1.8,[6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,34,35,37,46]] call _fnc_VGMsizeEx)

#define VGM_FONT_S VGM_SIZEEX_TT2020BASE(SIZEEX_S)
#define VGM_FONT_M VGM_SIZEEX_TT2020BASE(SIZEEX_M)
#define VGM_FONT_L VGM_SIZEEX_TT2020BASE(SIZEEX_L)
