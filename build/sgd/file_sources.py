from dataclasses import dataclass
from pathlib import Path
import shutil
from typing import Any, Protocol, Callable

from .file_generators import FileGenerator

class FileSource(Protocol):
    def create_file(self, path):
        pass

@dataclass
class CopyFile(FileSource):
    source: Path

    def explain(self):
        return f"copies file from '{self.source.as_posix()}'"

    def create_file(self, path):
        shutil.copyfile(self.source, path)

@dataclass
class SymlinkFile(FileSource):
    source: Path

    def explain(self):
        return f"symlinks file from '{self.source.as_posix()}'"

    def create_file(self, path):
        Path(path).symlink_to(self.source)

@dataclass
class HardlinkFile(FileSource):
    source: Path

    def explain(self):
        return f"hardlinks file from '{self.source.as_posix()}'"

    def create_file(self, path):
        self.source.link_to(path)


@dataclass
class GenerateFile(FileSource):
    generator: FileGenerator

    def explain(self):
        print(self.generator)
        return f"generated file: {self.generator.description}"

    def create_file(self, path):
        self.generator.generate(path)


