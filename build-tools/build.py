import argparse
import datetime
import os
import os.path as path
from pathlib import Path, PurePath
import shutil
import subprocess
import sys

root_directory = Path(path.realpath(__file__)).parent.parent
addon_prefix = "\\sgd\\anarchy"

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

def build(mod_names, overwrite=False):
    output_directory = root_directory / 'packed'
    log_directory = root_directory / 'build_logs' / (datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
    prefix_directory = Path('P:\\') / addon_prefix

    if not prefix_directory.exists():
        print(f"ERROR: P-Drive is not set up for Anarchy. The P-Drive must be set up before building. ({prefix_directory} does not exist)")
        print("You can set this feature up using the 'pdrive' command")
        return

    create_folder_if_not_exists(output_directory)
    create_folder_if_not_exists(log_directory)

    #Create mod folders
    for mod_name in mod_names:
        print(f"\n\n==BUILDING MOD {mod_name}==")
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

        print(f"\n=BUILDING {mod_name} ADDONS=")
        #Build addons with makepbo
        exclude_files = ",".join(["thumbs.db","*.txt","*.h","*.dep","*.cpp","*.bak","*.png","*.log","*.pew","*.hpp","source","*.tga"])
        base_command = ["MakePbo", "-PsFW", f"-X={exclude_files}"]
        for addon_input_path in (mod_input_path / "addons").iterdir():
            addon_name = addon_input_path.name
            addon_output_path = mod_output_path / "addons" / (addon_name + ".pbo")
            print(f"Building Addon '{addon_name}' to {addon_output_path}")

            #Check the source exists on the P-Drive
            addon_source_path = prefix_directory / addon_name;
            if not addon_source_path.exists():
                print(f"    FAILED: {addon_name} cannot be built - the source path does not exist ({addon_source_path})")
                continue

            log_file_path = log_directory / f"makepbo_{addon_name}.txt"
            with open(log_file_path, "w") as log_file:
                command = base_command + [str(addon_input_path), str(addon_output_path)]
                result = subprocess.run(command, stdout=log_file, stderr=subprocess.STDOUT)
                if result.returncode != 0:
                    print(f"    FAILED: {addon_name} build - see ({log_file_path}) for more information")
                    continue
                else:
                    print(f"    SUCCEEDED: {addon_name} build - see ({log_file_path}) for MakePBO output")

def pdrive(disable=False):
    drive = Path("P:\\")
    drive_addon_root = drive / addon_prefix

    if not disable:
        create_folder_if_not_exists(drive_addon_root)

        print("Linking files to addon root")
        mods = ["@anarchy_client", "@anarchy_server"]
        for mod in mods:
            addons_path = root_directory / mod / "addons"
            for addon_path in addons_path.iterdir():
                link_path = drive_addon_root / (addon_path.name)
                create_symlink(link_path, addon_path, is_directory=True)
    else:
        if drive_addon_root.exists():
            print(f"Deleting {drive_addon_root}")
            try:
                shutil.rmtree(drive_addon_root)
                print(f"Deleted {drive_addon_root}")
            except OSError as e:
                print(f"Error removing {drive_addon_root}")
                print("Raw error: ", e)
        else:
            print(f"P-Drive is not configured ({drive_addon_root} does not exist.)")

def filepatching(raw_path, disable=False):
    path = Path(raw_path)
    is_server = len(list(path.glob('arma3server*.exe'))) > 0
    is_client = len(list(path.glob('arma3*.exe'))) > 0
    if not (is_server or is_client):
        print(f"ERROR: {path} is not an Arma root directory")
        return False

    prefix_path = PurePath(addon_prefix)
    prefix_base = prefix_path.parents[0].name
    link_path = path.joinpath(prefix_base)
    
    if not disable:
        print(f"Setting up SGD filepatching at {path}")

        pdrive_addon_path = Path('P:\\') / prefix_path
        if not pdrive_addon_path.exists():
            print(f"ERROR: P-Drive is not set up for Anarchy. The P-Drive must be set up before enabling filepatching. ({pdrive_addon_path} does not exist)")
            print("You can set this feature up using the 'pdrive' command")
            return

        dest_path = Path('P:\\') / prefix_base
        create_symlink(link_path, dest_path, is_directory=True) 
    else:
        if link_path.exists():
            print(f"Removing SGD filepatching directory {link_path}")
            link_path.unlink()
        else:
            print(f"SGD Filepatching is not set up at {path}")
    
def subcommand_build(args):
    print("======================")
    print("=  BUILDING ANARCHY  =")
    print("======================")

    mods = []
    if not args.no_client:
        mods.append("@anarchy_client")
    if not args.no_server:
        mods.append("@anarchy_server")
    print(f"Building: {mods}")
    build(mods,overwrite=args.force)

def subcommand_pdrive(args):
    action = "Disabling" if args.disable else "Enabling"
    print(f"{action} P-Drive setup for Anarchy")
    pdrive(disable=args.disable)

def subcommand_filepatching(args):
    action = "Disabling" if args.disable else "Enabling"
    print(f"{action} filepatching")
    filepatching(args.path, args.disable)

if __name__ == "__main__":
    raw_args = sys.argv[1:]
    
    if len(raw_args) == 0:
        default_args = ["build", "--force"]
        print("No arguments given, using defaults: [{}]".format(" ".join(default_args)))
        raw_args = default_args

    parser = argparse.ArgumentParser(description="Tool for building Anarchy server and client mods")
    subparsers = parser.add_subparsers()

    build_parser = subparsers.add_parser('build', help='Build Anarchy addons')
    build_parser.add_argument('--no-server', help="Stops the Anarchy server mod being built", action="store_const", const=True, default=False)
    build_parser.add_argument('--no-client', help="Stops the Anarchy client mod being built", action="store_const", const=True, default=False)
    build_parser.add_argument('-f', '--force', help="Erases all content in the packed mod folder if it exists", action="store_const", const=True, default=False)
    build_parser.set_defaults(func=subcommand_build)

    pdrive_parser = subparsers.add_parser('pdrive', help="Sets up Anarchy on the P-Drive")
    pdrive_parser.add_argument('-d', '--disable', help="Removes Anarchy setup from P-Drive", action="store_const", const=True, default=False)
    pdrive_parser.set_defaults(func=subcommand_pdrive)

    filepatching_parser = subparsers.add_parser('filepatching', help="Set up filepatching")
    filepatching_parser.add_argument("path", help="Path to Arma Client or Server root")
    filepatching_parser.add_argument('-d', '--disable', help="Disables previously set up filepatching", action="store_const", const=True, default=False)
    filepatching_parser.set_defaults(func=subcommand_filepatching)

    help_parser = subparsers.add_parser('help', help='Prints help')
    help_parser.set_defaults(func=lambda *args: parser.print_help())

    args = parser.parse_args(raw_args)

    args.func(args)


    print("\nPress ENTER to finish")
    input()