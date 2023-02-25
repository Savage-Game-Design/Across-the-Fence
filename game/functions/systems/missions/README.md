## Conventions

* Public API functions should take IDs as parameters. e.g mission IDs, player DirectPlayIds
* Private API functions can take IDs, Hashmaps or other objects as appropriate.
* Tracked State is used for telling other systems about missions
    * It allows for simple JIP logic.
    * Helps avoid bugs due to bad event timing
