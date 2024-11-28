from dataclasses import dataclass, field
from enum import Enum, auto

import sgd.file_tree

class BuildArtifact(Enum):
    MISSION = auto()
    CLIENT_MOD = auto()
    SERVER_MOD = auto()


@dataclass
class Mod:
    files: sgd.file_tree.Folder = field(default_factory=sgd.file_tree.FileTreeRoot)

@dataclass
class Mission:
    name: str
    map: str
    files: sgd.file_tree.Folder = field(default_factory=sgd.file_tree.FileTreeRoot)

    @property
    def folder_name(self):
        return f"{self.name}.{self.map}"

@dataclass
class Gamemode:
    missions: list[Mission]
    client_mod: Mod
    server_mod: Mod
