## Conventions

* Group variables should be set when a squad is spawned, or manually added to the squad, to ensure they get persisted when squads despawn.

## Events


| Event                                | Arguments                         | Scope           |
|--------------------------------------|-----------------------------------|-----------------|
| vgm_virtsquad_created                | [_squad]                          | Server          |
| vgm_virtsquad_deleted                | [_squad]                          | Server          |
| vgm_virtsquad_spawned                | [_squad]                          | Server          |
| vgm_virtsquad_despawned              | [_squad]                          | Server          |
