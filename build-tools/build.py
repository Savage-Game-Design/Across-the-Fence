import argparse
import datetime
import json
import os
import os.path as path
from pathlib import Path, PurePath
import shutil
import subprocess
import sys
import vdf

p_drive = Path('P:\\')
root_directory = Path(path.realpath(__file__)).parent.parent
addon_prefix = "\\sgd\\anarchy"
output_directory = root_directory / 'packed'
log_directory = root_directory / 'build_logs' / (datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
prefix_directory = p_drive / addon_prefix
missions_directory = root_directory / "missions"
arma_mod_folder_name = "anarchy"

#All mods that are to be built/linked
all_mods = ["@anarchy_client", "@anarchy_server"]
#Additional symlinks that should be created as part of the `arma-setup` command.
#Destination is relative to the arma root directory
extra_setup_links = [
   {"source": "packed\\asc_files", "dest": "asc_files", "is_dir": True}
]

def find_steam_library_paths():
    steam_path = Path(os.environ["ProgramFiles(x86)"]) / "Steam"
    if not steam_path.exists():
        return (False, f"Unable to find Steam at {steam_path}")
    library_file_path = steam_path / "steamapps" / "libraryfolders.vdf"
    if not library_file_path.exists():
        return (False, f"Unable to locate Steam libraries ({library_file_path} does not exist)")

    steam_library_paths = [steam_path]
    try:
        with open(library_file_path, "r") as library_file:
            lib_info = vdf.load(library_file)
            for (key, value) in lib_info["LibraryFolders"].items():
                #Check if the key is an integer - that means it's a library path
                try:
                    int(key)
                    steam_library_paths.append(Path(value))
                except ValueError:
                    #Don't need to do anything. This just means the key/value pair isn't one we want.
                    pass
    except Exception as e:
        return (False, f"An error occurred while loading Steam library info. {e}")

    return (True, steam_library_paths)

def is_arma_server_dir(path):
    return (path / "arma3server.exe").exists() and not is_arma_client_dir(path)

def is_arma_client_dir(path):
    return (path / "arma3.exe").exists()

def is_arma_tools_dir(path):
    return (path / "Arma3Tools.exe").exists()

def find_arma_install_dirs():
    (success, result) = find_steam_library_paths()
    if not success:
        return (success, result)

    arma_paths = {
        "games": [],
        "servers": [],
        "tools": []
    }

    steam_library_paths = result
    game_folder_root_paths = list(filter(lambda p: p.exists(), [path / "steamapps" / "common" for path in steam_library_paths]))
    for root_path in game_folder_root_paths:
        for game_dir in root_path.iterdir():
            #Quick filter - saves the overhead of checking every directory for an exe - makes a noticable difference
            if not game_dir.name.casefold().find("arma 3") == 0:
                continue
            if is_arma_client_dir(game_dir):
                arma_paths["games"].append(game_dir)
                continue
            if is_arma_server_dir(game_dir):
                arma_paths["servers"].append(game_dir)
                continue
            if is_arma_tools_dir(game_dir):
                arma_paths["tools"].append(game_dir)
                continue

    return arma_paths

def create_folder_if_not_exists(folder_path, verbose=True):
    if folder_path.exists():
        if verbose:
            print(f"Directory {folder_path} already exists - not creating")
    else:
        print(f"Creating folder {folder_path}")
        folder_path.mkdir(parents=True,exist_ok=True)

def create_symlink(link_path,dest_path,is_directory=False):
    try:
        if not link_path.exists():
            print(f"Linking {link_path} to {dest_path}")
            link_path.symlink_to(dest_path, target_is_directory=is_directory)
        else:
            print(f"Skipping {link_path} - file already exists")
    except OSError as e:
        if e.winerror == 183:
            print("Error: Link/file already exists. This should not happen. Please try again")
        else:
            print("Error while creating symlinks. Possible fix: This script needs to be run as an administrator.")
            print("Raw error: ", e)

def create_symlink_and_parents(link_path,source_path,is_directory=False):
    create_folder_if_not_exists(link_path.parent)
    create_symlink(link_path, source_path, is_directory)

def remove_file_and_empty_parent_folders(path):
    deleted = []
    if path.exists():
        deleted.append(path)
        path.unlink()
    for parent in path.parents:
        if not parent.exists():
            break
        if len(list(parent.iterdir())) == 0:
            deleted.append(parent)
            parent.rmdir()
            continue
        break
    
    return deleted

def remove_if_symlink_to_here(link_path):
    if link_path.is_symlink():
        #if our link path begins with the path to our root directory, we consider it a link to inside this repo.
        #Alternatively, it it's a symlink to a non-existant file/folder
        if root_directory.resolve().as_posix() in link_path.resolve().as_posix() or not link_path.exists():
            print(f"Unlinking {link_path}")
            link_path.unlink()

def load_addon_info(folder_path):
    build_file_path = folder_path / "build.json"
    
    if not build_file_path.exists():
        return None

    try:
        with build_file_path.open("r") as build_file:
            data = json.load(build_file)
            data["name"] = folder_path.name
            data["pbo_name"] =  data["name"] + ".pbo"
            data["prefix"] = data.get("prefix", "sgd\\{addon_name}").format(addon_name = data["name"])
            #We need to create a path here that has no root, so we can safely join it onto other paths
            #This does it cross-platform, without errors, even if it has no root.
            prefix_path = PurePath(data["prefix"])
            data["prefix_path"] = prefix_path.relative_to(prefix_path.root)
            return data
    except OSError:
        print(f"Error: Unable to open build file: {build_file_path}")
        return None
    except json.JSONDecodeError:
        print(f"Build file not a valid JSON document: {build_file_path}")
        return None

def build(mod_names, overwrite=False):

    if not prefix_directory.exists():
        print(f"ERROR: P-Drive is not set up for Anarchy. The P-Drive must be set up before building. ({prefix_directory} does not exist)")
        print("You can set this feature up using the 'pdrive' command")
        return

    create_folder_if_not_exists(output_directory)
    create_folder_if_not_exists(log_directory)

    #Create mod folders
    for mod_name in mod_names:
        print(f"\n\n==== BUILDING MOD {mod_name} ====")
        mod_input_path = root_directory / mod_name
        mod_output_path = output_directory / mod_name
        if mod_output_path.exists():
            if overwrite:
                print(f"Output folder already exists, deleting folder ({mod_output_path})")
                shutil.rmtree(mod_output_path)
            else:
                print(f"Output path already exists - aborting build ({mod_output_path})")
                continue

        create_folder_if_not_exists(mod_output_path)
        create_folder_if_not_exists(mod_output_path / 'addons')

        #Copy over relevant folders
        for child in mod_input_path.iterdir():
            #Skip the addons folder - we build this with MakePBO
            if child.name == "addons": 
                continue
            dest_path = mod_output_path / child.name
            if child.is_dir():
                print(f"Copying folder {child} to {dest_path}")
                shutil.copytree(child, dest_path, symlinks=True)
            else:
                print(f"Copying file {child} to {dest_path}")
                shutil.copyfile(child, dest_path, follow_symlinks=True)

        print(f"\n==== BUILDING {mod_name} ADDONS ====")
        #Build addons with makepbo
        exclude_files = ",".join(["thumbs.db","*.txt","*.h","*.dep","*.cpp","*.bak","*.png","*.log","*.pew","*.hpp","source","*.tga"])
        default_args = ["-PsFW", f"-X={exclude_files}"]
        base_command = ["MakePbo"]

        for addon_input_path in (mod_input_path / "addons").iterdir():
            addon_info = load_addon_info(addon_input_path)

            if not addon_info:
                print(f"Skipping {addon_input_path} - No build info")
                continue

            addon_name = addon_info["name"]
            addon_source_path = p_drive / addon_info["prefix_path"];
            addon_output_path = mod_output_path / "addons" / (addon_info["pbo_name"])

            print(f"Building Addon '{addon_name}'")
            print("    Prefix: {}".format(addon_info["prefix"]))
            print("    Source Path: {}".format(addon_source_path))
            print("    Output Path: {}".format(addon_output_path))

            #Check the source exists on the P-Drive
            if not addon_source_path.exists():
                print(f"    FAILED: {addon_name} cannot be built - the source path does not exist ({addon_source_path})")
                continue

            command = base_command + addon_info.get("makepbo_arguments", default_args) + [str(addon_source_path), str(addon_output_path)]

            log_file_path = log_directory / f"makepbo_{addon_name}.txt"
            with open(log_file_path, "w") as log_file:
                result = subprocess.run(command, stdout=log_file, stderr=subprocess.STDOUT)
                if result.returncode != 0:
                    print(f"    FAILED: {addon_name} build - see ({log_file_path}) for more information")
                    continue
                else:
                    print(f"    SUCCEEDED: {addon_name} build - see ({log_file_path}) for MakePBO output")

def pdrive(mods,disable=False):
    symlinks = []

    for mod in mods:
        addons_path = root_directory / mod / "addons"
        for addon_path in addons_path.iterdir():
            addon_info = load_addon_info(addon_path)
            if addon_info:
                symlinks.append({
                    "addon_info": addon_info,
                    "addon_path": addon_path,
                    "link_path": p_drive / addon_info["prefix_path"], 
                    "source_path": addon_path
                })
 
    if not disable:
        print("Linking files to addon root")
        for link in symlinks:
            create_folder_if_not_exists(link["link_path"].parent)
            create_symlink(link["link_path"], link["source_path"], is_directory=True)
    else:
        for link in symlinks:
            try:
                for deleted_path in remove_file_and_empty_parent_folders(link["link_path"]):
                    print(f"Deleted: {deleted_path}")
            except OSError as e:
                print(f"Error removing {link_path}")
                print("Raw error: ", e)

def filepatching(raw_path,mods,disable=False):
    path = Path(raw_path)

    if not path.exists():
        print(f"ERROR: {path} does not exist")
        return False

    is_server = is_arma_server_dir(path)
    is_client = is_arma_client_dir(path)
    if not (is_server or is_client):
        print(f"ERROR: {path} is not an Arma root directory")
        return False

    symlinks = []

    for mod in mods:
        addons_path = root_directory / mod / "addons"
        for addon_path in addons_path.iterdir():
            addon_info = load_addon_info(addon_path)
            if addon_info:
                symlinks.append({
                    "addon_info": addon_info,
                    "addon_path": addon_path,
                    "link_path": path / addon_info["prefix_path"], 
                    "source_path": addon_path
                })
    
    if not disable:
        print(f"Setting up SGD filepatching at {path}")

        for link in symlinks:
            addon_name = link["addon_info"]["name"]
            print(f"Setting up filepatching for {addon_name}")

            if not link["source_path"].exists():
                print("ERROR: {} does not exist".format(link["source_path"]))
                continue

            create_folder_if_not_exists(link["link_path"].parent)
            create_symlink(link["link_path"], link["source_path"], is_directory=True) 
    else:
        for link in symlinks:
            try:
                for deleted_path in remove_file_and_empty_parent_folders(link["link_path"]):
                    print(f"Deleted: {deleted_path}")
            except OSError as e:
                print(f"Error removing {link_path}")
                print("Raw error: ", e)

def arma_setup(raw_path,link_missions=True,disable=False):
    arma_path = Path(raw_path)

    if not arma_path.exists():
        print(f"ERROR: {arma_path} does not exist")
        return False


    is_server = is_arma_server_dir(arma_path)
    is_client = is_arma_client_dir(arma_path)
    if not (is_server or is_client):
        print(f"ERROR: {arma_path} is not an Arma root directory")
        return False

    arma_link_folder_path = arma_path / arma_mod_folder_name
    mod_names = all_mods

    if not disable:
        create_folder_if_not_exists(arma_link_folder_path)
        
        print(f"==== Linking packed mods to Arma 3: {mod_names} ====")
        for mod_name in mod_names:
            try:
                mod_path = output_directory / mod_name
                link_path = arma_link_folder_path / mod_name
                create_symlink(link_path, mod_path, is_directory = True)
            except FileNotFoundError as e:
                print(f"WARNING: Mod {mod_name} cannot be linked - path does not exist {e.filename}")

        if link_missions:
            print(f"==== Linking missions to Arma 3 ====")
            try:
                for mission in missions_directory.iterdir():
                    if not mission.is_dir():
                        continue
                    link_path = arma_path / "mpmissions" / mission.name
                    create_symlink(link_path, mission, is_directory = True)
            except FileNotFoundError as e:
                print(f"WARNING: Cannot link missions, {e.filename} does not exist")

        print(f"==== Linking additional folders to Arma 3 ====")
        for extra_link in extra_setup_links:
            source = root_directory / extra_link["source"]
            dest = arma_path / extra_link["dest"]
            if not source.exists():
                print(f"WARNING: Cannot link extra folder, ({source}) does not exist")
                continue
            create_symlink(dest, source, is_directory=extra_link["is_dir"])
    else:
        print(f"==== Unlinking mods from Arma 3: {mod_names} ====")
        for child_path in arma_link_folder_path.iterdir():
            remove_if_symlink_to_here(child_path)
        print(f"==== Unlinking missions from Arma 3 ====")
        for child_path in (arma_path / "mpmissions").iterdir():
            remove_if_symlink_to_here(child_path)
        print(f"==== Unlinking additional links from Arma 3 ====")
        for extra_link in extra_setup_links:
            remove_if_symlink_to_here(arma_path / extra_link["dest"])

def select(options):
    print(f"Select an option below by typing its number. Press 'a' to choose all options, or 'q' for none:")
    for index, option in enumerate(options):
        print(f"    {index}: {option}")
    
    while True:
        choice = input()
        if choice.lower() == "a":
            return options
        if choice.lower() == "q":
            return []
        try:
            index = int(choice)
            if index >= 0 and index < len(options):
                return [options[index]]
        except ValueError:
            #Do nothing, it's just an invalid input
            pass
        print(f"'{choice}' is not a valid option")

def choose_arma_paths(permit_dedicated=True):
    arma_paths = find_arma_install_dirs()
    usable_paths = arma_paths["games"]
    if permit_dedicated:
        usable_paths = arma_paths["games"] + arma_paths["servers"]
    if len(usable_paths) == 0:
        return []
    return select(usable_paths)
    
def subcommand_build(args):
    print("====  BUILDING ANARCHY ====")

    for mod in args.mod:
        if not mod in all_mods:
            print(f"ERROR: Invalid mod specified ({mod}), aborting build")
            return

    #Deduplicate the mods list
    mods = list(set(args.mod))

    if len(args.mod) == 0:
        mods = all_mods

    print(f"Building: {mods}")
    build(mods,overwrite=args.force)

def subcommand_pdrive(args):
    action = "Disabling" if args.disable else "Enabling"
    print(f"==== {action} P-Drive setup for Anarchy ====")
    pdrive(all_mods,disable=args.disable)

def subcommand_filepatching(args):
    action = "Disabling" if args.disable else "Enabling"
    print(f"==== {action} filepatching ====")
    paths = args.paths
    if args.autodetect or len(paths) == 0:
        print("Autodetecting Arma installations...")
        paths = choose_arma_paths(permit_dedicated=True)

    for path in paths:
        print (f"Configuring filepatching for {path}")
        filepatching(path,all_mods,args.disable)

def subcommand_arma_setup(args):
    action = "unlinking" if args.disable else "linking"
    print(f"==== Setting up Arma for Anarchy development - {action} mods and missions ====")
    paths = args.paths
    if args.autodetect or len(paths) == 0:
        print("Autodetecting Arma installations...")
        paths = choose_arma_paths(permit_dedicated=True)

    for path in paths:
        print(f"\nSetting up Arma instance at path: {path}")
        arma_setup(path,link_missions=True,disable=args.disable)

if __name__ == "__main__":
    raw_args = sys.argv[1:]
    
    if len(raw_args) == 0:
        default_args = ["build", "--force"]
        print("No arguments given, using defaults: [{}]".format(" ".join(default_args)))
        raw_args = default_args

    parser = argparse.ArgumentParser(description="Tool for building Anarchy server and client mods")
    subparsers = parser.add_subparsers()

    build_parser = subparsers.add_parser('build', help='Build Anarchy addons')
    build_parser.add_argument('-m', '--mod', help=f"Builds only the named mod. May be specified more than once. Valid options are: {all_mods}", nargs="*", default=[])
    build_parser.add_argument('-f', '--force', help="Erases all content in the packed mod folder if it exists", action="store_const", const=True, default=False)
    build_parser.set_defaults(func=subcommand_build)

    pdrive_parser = subparsers.add_parser('pdrive', help="Sets up Anarchy on the P-Drive")
    pdrive_parser.add_argument('-d', '--disable', help="Removes Anarchy setup from P-Drive", action="store_const", const=True, default=False)
    pdrive_parser.set_defaults(func=subcommand_pdrive)

    filepatching_parser = subparsers.add_parser('filepatching', help="Set up filepatching")
    filepatching_parser.add_argument("paths", help="Path to Arma Client or Server root", nargs="*")
    filepatching_parser.add_argument("-a", "--autodetect", help="Autodetect Arma installations done through Steam. Note: This ignores any paths passed in", action="store_const", const=True, default=False)
    filepatching_parser.add_argument('-d', '--disable', help="Disables previously set up filepatching", action="store_const", const=True, default=False)
    filepatching_parser.set_defaults(func=subcommand_filepatching)

    arma_setup_parser = subparsers.add_parser('arma-setup', help="Installs links to all necessary mods and missions in Arma")
    arma_setup_parser.add_argument("paths", help="Path to Arma Client or Server root", nargs="*")
    arma_setup_parser.add_argument("-a", "--autodetect", help="Autodetect Arma installations done through Steam. Note: This ignores any paths passed in", action="store_const", const=True, default=False)
    arma_setup_parser.add_argument('-d', '--disable', help="Unlinks mods and missions from specified Arma install", action="store_const", const=True, default=False)
    arma_setup_parser.set_defaults(func=subcommand_arma_setup)

    #start_game_parser = subparsers.add_parser('start-game', help="Starts a dedicated server and joins an Arma 3 client to it, with mods.")
    #start_game_parser.set_defaults(func=subcommand_start_game)

    help_parser = subparsers.add_parser('help', help='Prints help')
    help_parser.set_defaults(func=lambda *args: parser.print_help())

    args = parser.parse_args(raw_args)

    args.func(args)


    print("\nPress ENTER to finish")
    input()