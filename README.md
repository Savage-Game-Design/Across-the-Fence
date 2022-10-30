## Building

### Overview

In order to streamline building, the project can be built as both a mission, and as an addon (TBC).

This is facilitated by having a custom folder structure, which is compiled into the usual Arma folder structure by the build tools.

Currently, only mission-style building is supported.

### Project structure

There are two main top-level folders:

`build` - Build tooling

`game` - All gamemode files

Within `game`, we have:

#### `assets` 
Binary assets, such as textures, models, sounds.

#### `configs`
General-purpose configs. Broken down into `client`, `mission` and `server`.
Each set of configs is only used in its respective PBO. 

`config_client.hpp`, `config_mission.hpp` and `config_server.hpp` are the files that are `#include`d in the relevant PBOs, any files added into the folders need to be included in their respective `config_X.hpp` file.

#### `functions`
All functions, for both `client` and `server`. These are organised by functionality. 

The way the build tool *will eventually* work when building as an addon is to search down, looking for `client` and `server` folders, and split them into their appropriate PBOs.

When building as a mission, all folders are simply copied into the mission.

#### `maps`
One folder for each map the gamemode will be on. Each folder includes the `mission.sqm`, as well as `description_map.inc` which is included into `description.ext` and `map_config`, which contains map-specific config stored at `missionConfigFile >> "map_config"`.

One PBO is produced per map.

#### `mission`
The root of the mission PBO. Includes necessary mission skeleton files, as well as placeholders for files the build system will insret.


### Build Setup

Copy `build/config.example.py` to `build/config.py`, and edit the settings to point to folders on your local system. 

It's recommended to set the mission output folder to your Arma 3 profile's `mpmissions` folder.

### Running the build

The build will need running each time you update the mission. It will copy the files to the specified output directory, in the right format.

The main command is `python3 build/build.py build`. You likely want to add `--overwrite` to overwrite any existing files in the output folder.

For further details on build script commands, run `python3 build/build.py --help`. 




