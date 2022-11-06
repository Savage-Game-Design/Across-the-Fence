import argparse
import asyncio
import colorama
from colorama import Fore, Back, Style
from collections import defaultdict
import datetime
import json
import os
import os.path as path
from pathlib import Path, PurePath
import shutil
import subprocess
import sys
import vdf
import winreg

#Initialise colorama, which lets us print with colour on windows!
colorama.init()


p_drive = Path('P:\\')
root_directory = Path(path.realpath(__file__)).parent.parent
addon_prefix = "\\sgd\\anarchy"
output_directory = root_directory / 'packed'
# Old: Saving each buildlog into seperate folder
# log_directory = root_directory / 'build_logs' / (datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
# Put logs into the mainFolder
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

# The default async event loop on Windows doesn't let us use subprocesses.
# We need to use the "ProActor" loop to fix this.
# Setting the policy means anything using asyncio.run() uses ProActor
asyncio.set_event_loop_policy(asyncio.WindowsProactorEventLoopPolicy())
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
            data["use_addon_builder"] = data.get("use_addon_builder", False)
            return data
    except OSError:
        logger.error(f"Error: Unable to open build file: {build_file_path}")
        return None
    except json.JSONDecodeError:
        logger.error(f"Build file not a valid JSON document: {build_file_path}")
        return None

class AddonBuildJob:
    def __init__(self,addon_path, output_folder_path, use_addon_builder=False):
        self.addon_name = addon_path.name
        self.logger = Logger(self.addon_name, log_directory / "{}_log.txt".format(addon_path.name))
        self.set_state("INIT", "Initialising build job")
        self.addon_info = load_addon_info(addon_path)

        if not self.addon_info:
            self.set_state("FAILED", f"Build failed - build.json does not exist")
            return

        self.source_path = p_drive / self.addon_info["prefix_path"]
        self.output_folder_path = output_folder_path
        self.output_pbo_path = output_folder_path / self.addon_info["pbo_name"]
        self.use_addon_builder = use_addon_builder

    def get_addon_builder_command(self):
        install_dirs = find_arma_install_dirs()
        if len(install_dirs["tools"]) == 0:
            return (False, f"Cannot use Addon Builder - no tools installation found (Should be installed via Steam)")
        default_args = ["-packonly", "-clear", "-prefix={}".format(self.addon_info["prefix_path"])]
        args = self.addon_info.get("addonbuilder_arguments", default_args)
        base_command = [str(install_dirs["tools"][0] / "AddonBuilder" / "AddonBuilder.exe")]
        # Output to the folder, as AddonBuilder makes pbos with the same name as the input folder.
        return (True, base_command + [str(self.source_path), str(self.output_folder_path)] + args)

    def get_makepbo_command(self):
        #Build addons with makepbo
        exclude_files = ",".join(["thumbs.db","*.txt","*.h","*.dep","*.cpp","*.bak","*.png","*.log","*.pew","*.hpp","source","*.tga"])
        #MakePBO default arguments
        default_args = ["-PsFW", f"-X={exclude_files}"]
        args = self.addon_info.get("makepbo_arguments", default_args)
        base_command = ["MakePbo"]
        return base_command + args + [str(self.source_path), str(self.output_folder_path / self.source_path.name)]

    def set_state(self, state, reason):
        self.state = state
        self.reason = reason
        if (state == "FAILED"):
            self.logger.error(f"Build {state} - {reason}")
        else:
            self.logger.verbose(f"Build {state} - {reason}")

    async def build(self):
        if self.state != "INIT":
            return self

        command = self.get_makepbo_command()
        if self.use_addon_builder or self.addon_info["use_addon_builder"]:
            (command_possible, result) = self.get_addon_builder_command()
            if not command_possible:
                self.set_state("FAILED", result)
                return self
            command = result

        if not self.source_path.exists():
            self.set_state("FAILED", "Source path {} does not exist".format(self.source_path))
            return self

        self.logger.verbose("Beginning build")
        self.logger.verbose("Source Path: {}".format(self.source_path))
        self.logger.verbose("Path: {}".format(self.output_folder_path))
        self.logger.verbose("Command: {}".format(command))

        addon_name = self.addon_name
        stdout_path = log_directory / f"{addon_name}_build_output.txt"
        stderr_path = log_directory / f"{addon_name}_build_errors.txt"
        with stdout_path.open("w") as stdout_file:
            with stderr_path.open("w") as stderr_file:
                process = await asyncio.create_subprocess_exec(*command, stdout=stdout_file, stderr=stderr_file)
                returncode = await process.wait()
                if returncode != 0:
                    self.set_state("FAILED", f"Build command failed - See ({stderr_path}) for more information")
                else:
                    #Rename the file
                    #os.rename(output_pbo_path, output_folder_path / addon_info["pbo_name"])
                    self.set_state("SUCCEEDED", f"Successful build - see ({stdout_path}) for addon build output")

        return self

async def build(mod_names, overwrite=False, use_addon_builder=False):
    if not prefix_directory.exists():
        logger.error(f"P-Drive is not set up for Anarchy. The P-Drive must be set up before building. ({prefix_directory} does not exist)")
        logger.error("You can set this feature up using the 'pdrive' command")
        return

    create_folder_if_not_exists(output_directory)

    #Create mod folders
    for mod_name in mod_names:
        logger.info(f"\n\n==== BUILDING MOD {mod_name} ====")
        mod_input_path = root_directory / mod_name
        mod_output_path = output_directory / mod_name
        if mod_output_path.exists():
            if overwrite:
                logger.info(f"Output folder already exists, deleting folder ({mod_output_path})")
                shutil.rmtree(mod_output_path)
            else:
                logger.error(f"Output path already exists - aborting build ({mod_output_path})")
                continue

        addon_input_folder_path = mod_input_path / 'addons'
        addon_output_folder_path = mod_output_path / 'addons'

        create_folder_if_not_exists(mod_output_path)
        create_folder_if_not_exists(addon_output_folder_path)

        #Copy over relevant folders
        for child in mod_input_path.iterdir():
            #Skip the addons folder - we build this with MakePBO
            if child.name == "addons":
                continue
            dest_path = mod_output_path / child.name
            if child.is_dir():
                logger.verbose(f"Copying folder {child} to {dest_path}")
                shutil.copytree(child, dest_path, symlinks=True)
            else:
                logger.verbose(f"Copying file {child} to {dest_path}")
                shutil.copyfile(child, dest_path, follow_symlinks=True)

        logger.info(f"\n==== BUILDING {mod_name} ADDONS ====")
        addon_build_jobs = [AddonBuildJob(addon_source_path, addon_output_folder_path, use_addon_builder) for addon_source_path in addon_input_folder_path.iterdir()]
        addon_build_tasks = [asyncio.create_task(job.build()) for job in addon_build_jobs]
        results = await asyncio.gather(*addon_build_tasks)
        for result in results:
            state_color_map = defaultdict(lambda: Fore.RESET, {"FAILED": Fore.RED, "SUCCEEDED": Fore.GREEN})
            color = state_color_map[result.state]
            state_output = color + result.state + Fore.RESET
            logger.info(f"{state_output} - {result.addon_name}: {result.reason}")


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
        logger.info("Linking files to addon root")
        for link in symlinks:
            create_folder_if_not_exists(link["link_path"].parent)
            create_symlink(link["link_path"], link["source_path"], is_directory=True)
    else:
        for link in symlinks:
            try:
                for deleted_path in remove_file_and_empty_parent_folders(link["link_path"]):
                    logger.info(f"Deleted: {deleted_path}")
            except OSError as e:
                logger.error(f"Error removing {link_path}")
                logger.error("Raw error: ", e)

def filepatching(raw_path,mods,disable=False):
    path = Path(raw_path)

    if not path.exists():
        logger.error(f"{path} does not exist")
        return False

    is_server = is_arma_server_dir(path)
    is_client = is_arma_client_dir(path)
    if not (is_server or is_client):
        logger.error(f"{path} is not an Arma root directory")
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
        logger.info(f"Setting up SGD filepatching at {path}")

        for link in symlinks:
            addon_name = link["addon_info"]["name"]
            logger.info(f"Setting up filepatching for {addon_name}")

            if not link["source_path"].exists():
                logger.error("{} does not exist".format(link["source_path"]))
                continue

            create_folder_if_not_exists(link["link_path"].parent)
            create_symlink(link["link_path"], link["source_path"], is_directory=True)
    else:
        for link in symlinks:
            try:
                for deleted_path in remove_file_and_empty_parent_folders(link["link_path"]):
                    logger.info(f"Deleted: {deleted_path}")
            except OSError as e:
                logger.error(f"Error removing {link_path}")
                logger.error("Raw error: ", e)

def arma_setup(raw_path,link_missions=True,disable=False):
    arma_path = Path(raw_path)

    if not arma_path.exists():
        logger.error(f"{arma_path} does not exist")
        return False


    is_server = is_arma_server_dir(arma_path)
    is_client = is_arma_client_dir(arma_path)
    if not (is_server or is_client):
        logger.error(f"{arma_path} is not an Arma root directory")
        return False

    arma_link_folder_path = arma_path / arma_mod_folder_name
    mod_names = all_mods

    if not disable:
        create_folder_if_not_exists(arma_link_folder_path)

        logger.info(f"==== Linking packed mods to Arma 3: {mod_names} ====")
        for mod_name in mod_names:
            try:
                mod_path = output_directory / mod_name
                link_path = arma_link_folder_path / mod_name
                create_symlink(link_path, mod_path, is_directory = True)
            except FileNotFoundError as e:
                logger.warning(f"WARNING: Mod {mod_name} cannot be linked - path does not exist {e.filename}")

        if link_missions:
            logger.info(f"==== Linking missions to Arma 3 ====")
            try:
                for mission in missions_directory.iterdir():
                    if not mission.is_dir():
                        continue
                    link_path = arma_path / "mpmissions" / mission.name
                    create_symlink(link_path, mission, is_directory = True)
            except FileNotFoundError as e:
                logger.warning(f"WARNING: Cannot link missions, {e.filename} does not exist")

        logger.info(f"==== Linking additional folders to Arma 3 ====")
        for extra_link in extra_setup_links:
            source = root_directory / extra_link["source"]
            dest = arma_path / extra_link["dest"]
            if not source.exists():
                logger.warning(f"WARNING: Cannot link extra folder, ({source}) does not exist")
                continue
            create_symlink(dest, source, is_directory=extra_link["is_dir"])
    else:
        logger.info(f"==== Unlinking mods from Arma 3: {mod_names} ====")
        for child_path in arma_link_folder_path.iterdir():
            remove_if_symlink_to_here(child_path)
        logger.info(f"==== Unlinking missions from Arma 3 ====")
        for child_path in (arma_path / "mpmissions").iterdir():
            remove_if_symlink_to_here(child_path)
        logger.info(f"==== Unlinking additional links from Arma 3 ====")
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
    logger.info("====  BUILDING ANARCHY ====")

    for mod in args.mod:
        if not mod in all_mods:
            logger.error(f"Invalid mod specified ({mod}), aborting build")
            return

    #Deduplicate the mods list
    mods = list(set(args.mod))

    if len(args.mod) == 0:
        mods = all_mods

    logger.info(f"Building: {mods}")
    asyncio.run(build(mods,overwrite=args.force,use_addon_builder=args.addonbuilder))

def subcommand_pdrive(args):
    action = "Disabling" if args.disable else "Enabling"
    logger.info(f"==== {action} P-Drive setup for Anarchy ====")
    pdrive(all_mods,disable=args.disable)

def subcommand_filepatching(args):
    action = "Disabling" if args.disable else "Enabling"
    logger.info(f"==== {action} filepatching ====")
    paths = args.paths
    if args.autodetect or len(paths) == 0:
        logger.info("Autodetecting Arma installations...")
        paths = choose_arma_paths(permit_dedicated=True)

    for path in paths:
        logger.info (f"Configuring filepatching for {path}")
        filepatching(path,all_mods,args.disable)

def subcommand_arma_setup(args):
    action = "unlinking" if args.disable else "linking"
    logger.info(f"==== Setting up Arma for Anarchy development - {action} mods and missions ====")
    paths = args.paths
    if args.autodetect or len(paths) == 0:
        logger.info("Autodetecting Arma installations...")
        paths = choose_arma_paths(permit_dedicated=True)

    for path in paths:
        logger.info(f"\nSetting up Arma instance at path: {path}")
        arma_setup(path,link_missions=True,disable=args.disable)

if __name__ == "__main__":
    raw_args = sys.argv[1:]

    if len(raw_args) == 0:
        default_args = ["build", "--force"]
        logger.warning("No arguments given, using defaults: [{}]".format(" ".join(default_args)))
        raw_args = default_args

    parser = argparse.ArgumentParser(description="Tool for building Anarchy server and client mods")
    subparsers = parser.add_subparsers()

    build_parser = subparsers.add_parser('build', help='Build Anarchy addons')
    build_parser.add_argument('-m', '--mod', help=f"Builds only the named mod. May be specified more than once. Valid options are: {all_mods}", nargs="*", default=[])
    build_parser.add_argument('-f', '--force', help="Erases all content in the packed mod folder if it exists", action="store_const", const=True, default=False)
    build_parser.add_argument('-a', '--addonbuilder', help="Uses AddonBuilder instead of MakePBO, if AddonBuilder is installed (Arma 3 Tools)", action="store_const", const=True, default=False)
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
