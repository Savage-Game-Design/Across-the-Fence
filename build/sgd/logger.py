from enum import IntEnum
import os
from pathlib import Path

class LogLevel(IntEnum):
    ERROR = 0
    WARNING = 1
    INFO = 2
    VERBOSE = 3
    DEBUG = 4

class Logger:
    def __init__(self, prefix, log_file, log_level=LogLevel.INFO):
        self.prefix = f"{prefix}: " if prefix != "" else ""
        self.log_file = log_file
        self.log_level = log_level

    def error(self, message):
        self.log(LogLevel.ERROR, message)

    def warning(self, message):
        self.log(LogLevel.WARNING, message)

    def info(self, message):
        self.log(LogLevel.INFO, message)

    def verbose(self, message):
        self.log(LogLevel.VERBOSE, message)

    def debug(self, message):
        self.log(LogLevel.DEBUG, message)

    def log(self, level, message):
        prefixed_message = f"{self.prefix}{message}"
        if level <= self.log_level:
            log_level_prefix = f"{level.name} - " if level <= LogLevel.WARNING else ""
            print(log_level_prefix + prefixed_message)
        with self.log_file.open("a") as file:
            file.write("{} - {}".format(level.name, prefixed_message))
            file.write("\n")

log_directory = Path(os.getcwd()) / 'build_logs'
log_directory.mkdir(parents=True,exist_ok=True)
logger = Logger("", log_directory / "build_log.txt", LogLevel.INFO)
