# Across the Fence - Arma 3 Mission and Mod
<a rel="license" href="https://www.bohemia.net/community/licenses/arma-public-license-share-alike" target="_blank" ><img src="https://data.bistudio.com/images/license/APL-SA.png" ><br>This work is licensed under the Public License Share Alike</a>

Across the Fence, a dynamic recon experience for individuals and teams of up to 6 players.

Inspired by the namesake book from RT Idaho One-Zero and SOG Prairie Fire adviser John “Tilt” Stryker Meyer, in Across the Fence you'll explore hostile NVA territory to investigate and locate enemy sites, before you try to extract safely and prepare for the next mission.

As you gain experience fighting the NVA, you'll develop your skills and abilities while gaining access to new weapons and equipment.


## Project structure

The top-level folders are:

- `build` - Build tooling - compiles the gamemode into the structure Arma 3 is expecting, as either a mission or mission + addon pair.
- `field_manual` - In-game documentation in .toml format, that's compiled into config entries for the in-game Field Manual by the build tools.
- `game` - All gamemode files (described in more detail below).
- `mod` - All mod-specific build files (mod.cpp, etc). These are used when building the server addon.
- `paradigm` - An integrated copy of the [Paradigm](https://github.com/Savage-Game-Design/Paradigm) shared library. 

### `game` folder

#### `configs`
General-purpose configs. Broken down into `client`, `mission` and `server`.
Each set of configs is only used in its respective PBO. 

`config_client.hpp`, `config_mission.hpp` and `config_server.hpp` are the files that are `#include`d in the relevant PBOs, any files added into the folders need to be included in their respective `config_X.hpp` file.

#### `functions`
All functions, for both `client` and `server`. These are organised by functionality. 

The way the build tool *will eventually* work when building as an addon is to search down, looking for `client` and `server` folders, and split them into their appropriate PBOs.

When building as a mission, all folders are simply copied into the mission.

#### `maps`
One folder for each map the gamemode will be on. Each folder includes the `mission.sqm`, as well as `description_map.inc` which is included into `description.ext` and `map_config`, which contains map-specific config stored at `missionConfigFile >> "MapConfig"`.

One PBO is produced per map.

#### `mission`
The root of the mission PBO. Includes:

- Necessary mission skeleton files, as well as placeholders for files the build system will insert.
- Binary assets (`assets` folder)
- Stringtable (`stringtable.xml`) for translations

### `mod` folder:

#### `client`
The client mod build files, including .hemtt config, mod.cpp and the base config.cpp for addons.

#### `server`
The server mod build files, including .hemtt config mod.cpp and the base config.cpp for addons.

## Building

### Overview

In order to streamline building, the project can be built as both a mission, and as a set of mods (client, server, mission)

This is facilitated by having a custom folder structure, which is compiled into the usual Arma folder structure by the build tools.

Currently, the client mod is not used. 

### Build Setup

Copy `build/config.example.py` to `build/config.py`, and edit the settings to point to folders on your local system. 
Copy `build/arma_server.example.hpp` to `build/arma_server.hpp`, and add your Steam64 ID to the `admins` section.

It's recommended to set the mission output folder to your Arma 3 profile's `mpmissions` folder.

#### Required software
- Python (3.12 or later, must be windows MSC python[^0])
- HEMTT (On windows: winget hemtt) if using `--pack-mods`

### Running the build

The build will need running each time you update the gamemode. It will copy the files to the specified output directories, with the conventional Arma folder structure.

#### Mission

To build as a mission, run `python3 build/run.py build`. 

Useful options:

- `--overwrite` to overwrite any existing files in the output folder.
- `--version "MyVersion"` to set the mission version
- `--mod` to build as a mission / server mod pair

The mission (in the output directory) can then be opened in the Arma editor, e.g using `python3 build/run.py launch client --editor`.

Most build commands accept the following options:
- `--overwrite` - Overwrites any existing files.
- `--clean` - Removes the existing folder (e.g mod output folders, mission folder)
- `--version` - Accepts a version in the format: `v<version>@<hash> <text>`, e.g `v1.2.3@abcd indev`. All components are optional, so `@abcd indev` is valid, as is `v1.2.3` or just `indev`.

For doing release builds, there's `python3 build/run.py release` which runs a build in release mode. 

#### Mod

Internally, there are two steps to building as a mod:
- Copying the gamemode files into the correct folders (client mod, mission, server mod).
- Building the mods as PBOs using HEMTT.

To prepare the mod folders, run `python3 build/run.py build --mod`. This will output the raw mod files into `output/mods`. You can add `--pack` to then to run HEMTT and pack the mods into PBOs.

The PBOs can be found in `.hemttout` folder of the mod output path. Typically `output/mods/@<mod_name>/.hemttout`.

##### Development helpers

The build script provides commands for launching Arma for development:
- `python3 build/run.py launch client` - Launches the Arma client. Use `--connect` to connect to a local server, or `--editor` to launch straight into the mission in the editor.
- `python3 build/run.py launch server` - Launches the Arma dedicated server locally. Use `--mod` to automatically build and load the server mod.
- `python3 build/run.py launch dev` - Runs a development build, then launches the client and server (unless `--no-client` or `--no-server` is used). Use `--mod` to build and load the server mod.

The server commands will also:
- Set up filepatching using HEMTT
- Symlink the mission into the server's `mpmissions` folder
- Make the server automatically load the mission

For further details on build script commands, run `python3 build/run.py --help`. 

[^0]: GCC python builds, such as those distributed by MSYS2's pacman, utilise posix paths and break the build scripts.
