from dataclasses import dataclass, field
from enum import Enum, auto
import re

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

class VersionParseError(Exception):
    def __init__(self, version_str: str):
        super().__init__(f"Bad version specifier: {version_str}")

# Parses a version number into its named parts
# Format is identical to Version's string: v1.2.3@hash postfix text
version_parser_regex = re.compile(r"(v(?P<major>\d+).(?P<minor>\d+).(?P<patch>\d+))?(@(?P<hash>\w+))?( (?P<postfix>.+))?")

@dataclass
class Version:
    major: int = 0
    minor: int = 0
    patch: int = 0
    hash: str = ""
    postfix: str = "indev"

    def __str__(self) -> str:
        version_str = ""
        if self.major > 0 or self.minor > 0 or self.patch > 0:
            version_str = f"v{self.major}.{self.minor}.{self.patch}"
        hash_str = ""
        if len(self.hash) > 0:
            hash_str = f"@{self.hash}"
        postfix_str = ""
        if len(self.postfix) > 0:
            postfix_str = f" {self.postfix}"
        return f"{version_str}{hash_str}{postfix_str}".strip()

    @staticmethod
    def parse(version_str: str) -> 'Version':
        match = version_parser_regex.fullmatch(version_str.strip())
        if not match:
            raise VersionParseError(version_str)
        return Version(
            major=int(match.group("major")) if match.group("major") else 0,
            minor=int(match.group("minor")) if match.group("minor") else 0,
            patch=int(match.group("patch")) if match.group("patch") else 0,
            hash=match.group("hash") or "",
            postfix=match.group("postfix") or ""
        )
