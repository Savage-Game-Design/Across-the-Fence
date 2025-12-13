import subprocess
from pathlib import Path

def output_path(mod_path: Path) -> Path:
    return mod_path / ".hemttout"

def dev_path(mod_path: Path) -> Path:
    return output_path(mod_path) / "dev"

def launch(path: Path, args=[], arma_args=[]):
    command = [
        "hemtt",
        "launch",
        *args,
        "--",
        *arma_args,
    ]

    print(f"Launching HEMTT: {command}")

    return subprocess.Popen(command, cwd=path)

def dev(path: Path, args=[]):
    command = [
        "hemtt",
        "dev",
        *args,
    ]

    print(f"Building with HEMTT in development mode: {list(map(str, command))} at {str(path)}")

    return subprocess.run(command, cwd=path)

def build(path: Path, args=[]):
    command = [
        "hemtt",
        "build",
        *args,
    ]

    print(f"Building with HEMTT: {list(map(str, command))} at {str(path)}")

    return subprocess.run(command, cwd=path)

def release(path: Path, args=[]):
    command = [
        "hemtt",
        "release",
        *args,
    ]

    print(f"Building with HEMTT in release mode: {list(map(str, command))} at {str(path)}")

    return subprocess.run(command, cwd=path)
