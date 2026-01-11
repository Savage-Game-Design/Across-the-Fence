## Events

| Event                    | Arguments                                 | Locality                  |
| ------------------------ | ----------------------------------------- | ------------------------- |
| vgm_medical_unconscious  | [_unit, _state]                           | Client/Local              |
| vgm_medical_woundAdded   | [_unit, _bodyPart, _woundIntensity]       | Client/Local              |
| vgm_medical_woundRemoved | [_unit, _bodyPart, _removeWoundIntensity] | Client/Local              |
| vgm_medical_heal         | [_healer, _patient, _itemType, _bodyPart] | Client/Target->`_patient` |
| vgm_medical_fullHeal     | [_patient]                                | Client/Target->`_patient` |

## API

| Function                                              | Description                |
| ----------------------------------------------------- | -------------------------- |
| [_unit, _state] call vgm_c_fnc_medical_setUnconscious | Set unit unconscious state |
| [_unit, _bodyPart] call vgm_c_fnc_medical_getWound    | Get amount of wounds       |
| [_unit] call vgm_g_fnc_medical_isWounded              | Check if unit is wounded   |

## Status Effects

| Effect     | Description                                                  | Trigger                             |
| ---------- | ------------------------------------------------------------ | ----------------------------------- |
| bleeding   | Unit bleeds out over time, causes unconscious if not stopped | When unit should bleed (has wounds) |
| blockADS   | Prevents aiming down sights                                  | Arms SEVERE wound                   |
| forceWalk  | Forces unit to walk (no sprinting/jogging)                   | Legs MAJOR wound                    |
| forceJog   | Forces unit to jog (no sprinting)                            | Legs MINOR wound                    |
| forceCrawl | Forces unit to crawl                                         | Legs SEVERE wound                   |

## Coefficients

| Coefficient      | Description                                       | Default | Range      | Variable                              |
| ---------------- | ------------------------------------------------- | ------- | ---------- | ------------------------------------- |
| bleedOut         | Multiplier for bleed out time (120s base)         | 1.0     | 0.5 - 3.0  | vgm_c_medical_coefficient_bleedout    |
| hitShrug         | Chance to completely ignore incoming damage       | 0.0     | 0.0 - 1.0  | vgm_c_medical_coefficient_hitShrug    |
| interact_medical | Multiplier for medical interaction speed          | 1.0     | 0.1 - 5.0  | vgm_c_coefficient_interact            |
| healModifier     | Additional wounds healed per healing action       | 0       | 0+         | vgm_g_medical_healModifier            |

## Bodyparts
- "head"
- "torso"
- "arms"
- "legs"
