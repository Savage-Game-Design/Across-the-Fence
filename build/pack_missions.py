"""Pack generated Arma mission folders into standard, uncompressed PBO files.

Mission PBOs do not need a prefix header or binarization.  Keeping them
uncompressed avoids an external packing-tool dependency and makes the release
archives deterministic in structure while remaining directly loadable by Arma.
"""

from __future__ import annotations

import argparse
import os
from dataclasses import dataclass
from pathlib import Path
from struct import pack, unpack


@dataclass(frozen=True)
class PboEntry:
    name: str
    size: int


def mission_files(mission_path: Path) -> list[tuple[Path, str]]:
    files: list[tuple[Path, str]] = []
    for path in mission_path.rglob("*"):
        if not path.is_file():
            continue
        name = path.relative_to(mission_path).as_posix().replace("/", "\\")
        try:
            name.encode("ascii")
        except UnicodeEncodeError as exc:
            raise ValueError(f"PBO paths must be ASCII: {path}") from exc
        files.append((path, name))
    return sorted(files, key=lambda item: item[1].lower())


def read_c_string(stream) -> bytes:
    value = bytearray()
    while True:
        character = stream.read(1)
        if not character:
            raise ValueError("Unexpected end of PBO header")
        if character == b"\0":
            return bytes(value)
        value.extend(character)


def inspect_pbo(pbo_path: Path) -> list[PboEntry]:
    """Validate the PBO layout we create and return its entries."""
    entries: list[PboEntry] = []
    with pbo_path.open("rb") as stream:
        while True:
            name = read_c_string(stream)
            fields = stream.read(20)
            if len(fields) != 20:
                raise ValueError("Incomplete PBO header entry")
            mime_type, original_size, offset, timestamp, data_size = unpack("<IIIII", fields)
            if not name:
                if fields != b"\0" * 20:
                    raise ValueError("Unexpected PBO properties header")
                break
            if mime_type or offset or original_size not in (0, data_size):
                raise ValueError(f"Unsupported PBO entry encoding: {name!r}")
            if timestamp < 0:
                raise ValueError(f"Invalid PBO timestamp: {name!r}")
            entries.append(PboEntry(name.decode("ascii"), data_size))

        data_start = stream.tell()
        data_end = data_start + sum(entry.size for entry in entries)
        stream.seek(0, os.SEEK_END)
        if stream.tell() != data_end:
            raise ValueError("PBO data size does not match its header")
    return entries


def pack_mission(mission_path: Path, output_path: Path, overwrite: bool) -> tuple[int, int]:
    files = mission_files(mission_path)
    if not files:
        raise ValueError(f"Mission folder is empty: {mission_path}")
    if not (mission_path / "mission.sqm").is_file():
        raise ValueError(f"Mission folder has no mission.sqm: {mission_path}")
    if output_path.exists() and not overwrite:
        raise FileExistsError(f"Refusing to overwrite {output_path}; pass --overwrite to replace it")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    temporary_path = output_path.with_name(f"{output_path.name}.tmp")
    if temporary_path.exists():
        temporary_path.unlink()

    try:
        with temporary_path.open("wb") as destination:
            for source_path, archive_name in files:
                size = source_path.stat().st_size
                timestamp = min(int(source_path.stat().st_mtime), 0xFFFFFFFF)
                destination.write(archive_name.encode("ascii") + b"\0")
                # MIME type, original size, unused offset, timestamp, data size.
                destination.write(pack("<IIIII", 0, 0, 0, timestamp, size))
            destination.write(b"\0" + b"\0" * 20)
            for source_path, _ in files:
                with source_path.open("rb") as source:
                    while block := source.read(1024 * 1024):
                        destination.write(block)

        expected_entries = [PboEntry(name, source.stat().st_size) for source, name in files]
        if inspect_pbo(temporary_path) != expected_entries:
            raise ValueError(f"PBO validation failed: {temporary_path}")
        os.replace(temporary_path, output_path)
    finally:
        if temporary_path.exists():
            temporary_path.unlink()

    return len(files), output_path.stat().st_size


def main() -> None:
    repository_root = Path(__file__).resolve().parent.parent
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source",
        type=Path,
        default=repository_root / "output" / "missions",
        help="Folder containing generated mission directories",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=repository_root / "output" / "pbos",
        help="Folder for generated mission PBOs",
    )
    parser.add_argument("--overwrite", action="store_true", help="Replace existing PBOs in the output folder")
    args = parser.parse_args()

    source_path = args.source.resolve()
    output_path = args.output.resolve()
    if not source_path.is_dir():
        parser.error(f"Mission source folder does not exist: {source_path}")

    missions = sorted(path for path in source_path.iterdir() if path.is_dir())
    if not missions:
        parser.error(f"No mission folders found in: {source_path}")

    for mission in missions:
        target = output_path / f"{mission.name}.pbo"
        file_count, byte_count = pack_mission(mission, target, args.overwrite)
        print(f"Packed {target.name}: {file_count} files, {byte_count:,} bytes")


if __name__ == "__main__":
    main()
