## Conventions

* Public API functions should take IDs as parameters. e.g mission IDs, player DirectPlayIds
* Private API functions can take IDs, Hashmaps or other objects as appropriate.

## Events


| Event               | Arguments              |
| ------------------- | ---------------------- |
| vgm_mission_started | [_missionId]           |
| vgm_mission_ended   | [_missionId, _endType] |

## Global variables
### Client

`vgm_mission_onMission` - boolean indicating if player is on a mission
