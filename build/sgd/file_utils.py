from dataclasses import dataclass, field
from pathlib import Path
from typing import Generator, Callable
from .logger import logger

@dataclass
class Omit:
    dirs: set[str] = field(default_factory=set)
    files: set[str] = field(default_factory=set)
    funcs: list[Callable[[Path], bool]] = field(default_factory=list)

def _filter_entries(root: Path, dirs: list[str], files: list[str], omissions) -> Generator[Path, None, None]:
    for dir_name in dirs:
        if dir_name in omissions.dirs:
            dirs.remove(dir_name)
    for file_name in files:
        if file_name in omissions.files:
            continue
        yield root / file_name

def all_files(folder_path: Path, recursive=False, omissions=Omit()) -> Generator[Path, None, None]:
    if not recursive:
        dirs = []
        files = []
        for entry in folder_path.iterdir():
            if entry.is_dir():
                dirs.append(entry.name)
            elif entry.is_file():
                dirs.append(entry.name)

        yield from _filter_entries(folder_path, dirs, files, omissions)
        return

    for root, dirs, files in folder_path.walk():
        yield from _filter_entries(root, dirs, files, omissions)

def all_files_relative(folder_path: Path, recursive=False, omissions=Omit()) -> Generator[Path, None, None]:
    for file_path in all_files(folder_path, recursive, omissions):
        yield file_path.relative_to(folder_path)

def create_folder_if_not_exists(folder_path):
    if folder_path.exists():
        logger.verbose(f"Directory {folder_path} already exists - not creating")
    else:
        # print(f"Creating folder {folder_path}")   # SPOFFY
        folder_path.mkdir(parents=True,exist_ok=True)

def create_symlink(link_path,dest_path,is_directory=False):
    try:
        if not link_path.exists():
            logger.info(f"Linking {link_path} to {dest_path}")
            link_path.symlink_to(dest_path, target_is_directory=is_directory)
        else:
            logger.verbose(f"Skipping {link_path} - file already exists")
    except OSError as e:
        if e.winerror == 183:
            logger.error("Error: Link/file already exists. This should not happen. Please try again")
        else:
            logger.error("Error while creating symlinks. Possible fix: This script needs to be run as an administrator.")
            logger.error("Raw error: ", e)

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

def remove_if_symlink_inside_location(link_path, location):
    if link_path.is_symlink():
        #if our link path begins with the path to our root directory, we consider it a link to inside this repo.
        #Alternatively, it it's a symlink to a non-existant file/folder
        if location.resolve().as_posix() in link_path.resolve().as_posix() or not link_path.exists():
            logger.info(f"Unlinking {link_path}")
            link_path.unlink()

