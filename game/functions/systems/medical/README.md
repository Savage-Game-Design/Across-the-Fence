## Events

| Event                    | Arguments                                 | Locality                  |
| ------------------------ | ----------------------------------------- | ------------------------- |
| vgm_medical_unconscious  | [_unit, _state]                           | Client/Local              |
| vgm_medical_woundAdded   | [_unit, _bodyPart, _woundIntensity]       | Client/Local              |
| vgm_medical_woundRemoved | [_unit, _bodyPart, _removeWoundIntensity] | Client/Local              |
| vgm_medical_heal         | [_healer, _patient, _itemType, _bodyPart] | Client/Target->`_patient` |
