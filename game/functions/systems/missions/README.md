## Conventions

* Public API functions should take IDs as parameters. e.g mission IDs, player DirectPlayIds
* Private API functions can take IDs, Hashmaps or other objects as appropriate.

## Events


| Event                 | Arguments              | Scope  |
| --------------------- | ---------------------- | ------ |
| vgm_mission_available | [_missionId]           | Global |
| vgm_mission_started   | [_missionId]           | Global |
| vgm_mission_ended     | [_missionId, _endType] | Global |

## Global variables
### Client

`vgm_mission_onMission` - boolean indicating if player is on a mission
