from pathlib import Path
import shutil
from typing import Iterable, Union

def concatenate_files(files: Iterable[Union[Path, str]]):
    file_paths = (Path(file) for file in files)

    def generate_concatenated_file(dest_path: Path):
        with open(dest_path, "wb") as output_fd:
            for file_path in file_paths:
                with open(file_path, "rb") as input_fd:
                    shutil.copyfileobj(input_fd, output_fd)

    return generate_concatenated_file