#include "macros.inc"

params ["_mode", "_this"];
switch _mode do {
    case "onLoad": {
        params ["_display"];
        uiNamespace setVariable ["VGM_RscSquad", _display];
    };
};

