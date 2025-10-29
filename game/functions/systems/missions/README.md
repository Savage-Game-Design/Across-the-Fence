## Conventions

* Public API functions should take IDs as parameters. e.g mission IDs, player DirectPlayIds
* Private API functions can take IDs, Hashmaps or other objects as appropriate.

## Events


| Event                                | Arguments                         | Scope           |
|--------------------------------------|-----------------------------------|-----------------|
| vgm_mission_available                | [_missionId]                      | Global          |
| vgm_mission_started                  | [_missionId]                      | Global          |
| vgm_mission_ended                    | [_missionId, _endType]            | Global          |
| vgm_mission_created                  | [_missionId]                      | Mission creator |
| vgm_mission_creationFailed           | [_reason, _reasonDetails]         | Mission creator |
| vgm_mission_joinable                 | [_missionId]                      | Global          |
| vgm_mission_notJoinable              | [_missionId]                      | Global          |
| vgm_mission_attached                 | [_missionId]                      | Global          |
| vgm_mission_joined                   | [_missionId]                      | Player joining  |
| vgm_mission_status_changed           | [_missionId, _status]             | Server          |
| vgm_mission_playerRemoved            | [_missionId, _playerId]           | Global          |
| vgm_mission_player_readiness_changed | [_playerId, _isReady, _missionId] | Global          |


## Global variables
### Client

`vgm_mission_onMission` - boolean indicating if player is on a mission
