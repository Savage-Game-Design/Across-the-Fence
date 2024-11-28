from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable, Generator, List, Protocol, Union

from .file_utils import all_files_relative, Omit
from .file_sources import FileGenerator, FileSource, CopyFile, GenerateFile, HardlinkFile, SymlinkFile
from .protocols import Explainable


"""
Takes a list of mappings, and builds a file tree.

This file tree can then be either symlinked or copied into existence.
"""

class FileConflictError(Exception):
    def __init__(self, file1_desc, file2_desc):
        super().__init__(f"({file1_desc}) conflicts with ({file2_desc})")

class FileTreeEntry(Explainable, Protocol):
    name: str
    parent: 'Folder' = None

    def resolve_path(self):
        path_entries = [self.name]
        next = self.parent
        while next:
            path_entries.append(next.name)
            next = next.parent
        return Path(*reversed(path_entries))

    def remove(self):
        self.parent.children.remove(self)
        self.parent = None

@dataclass
class File(FileTreeEntry):
    name: str
    source: FileSource
    parent: 'Folder' = None

    def explain(self) -> str:
        return f"File source '{self.resolve_path()}' [{self.source.explain()}]"

    def create_at(self, path):
        return self.source.create_file(path)

@dataclass
class Folder(FileTreeEntry):
    name: str
    parent: 'Folder' = None
    children: List[FileTreeEntry] = field(default_factory=list)

    def explain(self) -> str:
        return f"Folder '{self.resolve_path()}'"

    def add(self, new_entry: FileTreeEntry):
        existing_entry = self.get(new_entry.name)
        if (existing_entry):
            raise FileConflictError(new_entry.explain(), existing_entry.explain())

        self.children.append(new_entry)
        new_entry.parent = self

    def contains(self, name: str) -> bool:
        return True if self.get(name) else False

    def get(self, name: str) -> FileTreeEntry:
        return next((child for child in self.children if child.name == name), None)

    def get_or_create_subfolder(self, name: str) -> FileTreeEntry:
        existing_entry = self.get(name)

        if not existing_entry:
            new_folder = Folder(name=name)
            self.add(new_folder)
            return new_folder

        if not isinstance(existing_entry, type(self)):
            raise FileConflictError(f"Subfolder '{name}' in {self.explain()}", existing_entry.explain())

        return existing_entry

    def folders(self) -> Generator['Folder', None, None]:
        return (entry for entry in self.children if isinstance(entry, type(self)))

    def files(self) -> Generator[File, None, None]:
        return (entry for entry in self.children if isinstance(entry, File))

    def __truediv__(self, other: str):
        value = self.get(other)
        if value:
            return value
        return self.get_or_create_subfolder(other)

    def create_tree_at(self, path):
        path.mkdir(parents=True,exist_ok=True)
        for folder in self.folders():
            folder.create_tree_at(path / folder.name)
        for file in self.files():
            file.create_at(path / file.name)

FileTreeRoot = lambda: Folder(name="")

def add_file_to_tree(root: Folder, path: Union[Path, str], file_source: FileSource):
    destination_path = Path(path)

    parents = destination_path.parts[:-1]
    name = destination_path.parts[-1]
    current_root = root

    # Start with the topmost parent, and descends down the tree, making sure each folder exists.
    for parent_name in parents:
        current_root = current_root.get_or_create_subfolder(parent_name)

    current_root.add(File(name = name, source=file_source))

def print_file_tree(file_tree: Folder, indentation=0, explain=False):
    indent_spaces = " " * indentation
    for folder in file_tree.folders():
        print(f"{indent_spaces}- {folder.name}")
        print_file_tree(folder, indentation + 1, explain=explain)
    for file in file_tree.files():
        explanation = f"({file.source.explain()})"
        print(f"{indent_spaces}- {file.name} {explanation if explain else ''}")

def __include_file_tree_entries_func(include_action=Callable[[Path], FileSource]):
    def perform_include(
        file_tree: Folder,
        source: Union[Path, str],
        dest: Union[Path, str],
        omit: Omit = Omit(),
    ):
        source_path = Path(source)
        dest_path = Path(dest)
        if source_path.is_dir():
            for file_path in all_files_relative(source_path, recursive=True, omit=omit):
                add_file_to_tree(file_tree, dest_path / file_path, include_action(source_path / file_path))
        else:
            add_file_to_tree(file_tree, dest_path, include_action(source_path))
    return perform_include

copy = __include_file_tree_entries_func(
    lambda source_path: CopyFile(source=source_path)
)

symlink = __include_file_tree_entries_func(
    lambda source_path: SymlinkFile(source=source_path)
)

hardlink = __include_file_tree_entries_func(
    lambda source_path: HardlinkFile(source=source_path)
)

def generate_file(file_tree: Folder, dest_path: Union[Path, str], generator: FileGenerator):
    add_file_to_tree(file_tree, dest_path, GenerateFile(generator))

def remove(file_tree: Folder, path: Union[Path, str]):
    path_to_remove = Path(path)

    parents = path_to_remove.parts[:-1]
    name = path_to_remove.parts[-1]
    current_root = file_tree

    # Start with the topmost parent, and descends down the tree, making sure each folder exists.
    for parent_name in parents:
        current_root = current_root / parent_name
        if not current_root:
            return

    to_remove = current_root / name
    if to_remove:
        to_remove.remove()
