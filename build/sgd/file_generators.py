from dataclasses import dataclass
from pathlib import Path
import shutil
from typing import Any, Callable, Iterable, Union

type GeneratorFunc = Callable[[Path], Any]

@dataclass
class FileGenerator:
    description: str | None
    generate: GeneratorFunc


def concatenate_files(files: Iterable[Union[Path, str]]):
    file_paths = [Path(file) for file in files]

    def generate_concatenated_file(dest_path: Path):
        with open(dest_path, "wb") as output_fd:
            for file_path in file_paths:
                with open(file_path, "rb") as input_fd:
                    shutil.copyfileobj(input_fd, output_fd)

    # Generates a relative path for context, without making the line too long
    file_names_desc = ", ".join(str(path.relative_to(path.parent.parent.parent.parent)) for path in file_paths)

    return FileGenerator(
        description=f"combines {len(file_paths)} files - {file_names_desc}",
        generate=generate_concatenated_file
    )

def from_text(content: str):
    def write_text_to_file(dest_path: Path):
        with open(dest_path, "w", encoding="utf8") as output_fd:
            output_fd.write(content)

    preview = content[0:20] + ("..." if len(content) >= 20 else "")
    return FileGenerator(
        description=f"from text: '{preview}'",
        generate=write_text_to_file
    )

def replace(file: Union[Path, str], old: str, new: str):
    file_path = Path(file)
    def replace_text_in_file(dest_path: Path):
        with open(file_path, "r", encoding="utf8") as source_fd:
            contents = source_fd.read()
        contents.replace(old, new)
        with open(dest_path, "w", encoding="utf8") as output_fd:
            output_fd.write(contents)

    old_preview = old[0:20] + ("..." if len(old) >= 20 else "")
    new_preview = new[0:20] + ("..." if len(new) >= 20 else "")

    return FileGenerator(
        description=f"replaces '{old_preview}' with '{new_preview}' in '{str(file_path)}'",
        generate=replace_text_in_file
    )


