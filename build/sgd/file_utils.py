from pathlib import Path
from typing import Generator
from .logger import logger

def all_files(folder_path: Path, recursive=False):
    search_func = Path.glob if not recursive else Path.rglob

    return filter(lambda path: path.is_file(), search_func(folder_path, "*"))

def all_files_relative(folder_path: Path, recursive=False) -> Generator[Path, None, None]:
    file_paths = all_files(folder_path, recursive)
    return (file_path.relative_to(folder_path) for file_path in file_paths)

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

