from abc import abstractmethod
import re
from typing import Generic, Optional, Protocol, TypeVar

def escape_string(text: str) -> str:
    return text.replace('"', '""')

non_word_char_regex = re.compile(r"[^\w]")
whitespace_regex =  re.compile(r"\s")
def escape_identifier(text: str) -> str:
    return whitespace_regex.sub("_", non_word_char_regex.sub("", text))

indent_chars = "    "
def indent(lines: list[str], level=1) -> list[str]:
    indent = indent_chars * level
    return [(indent + line) for line in lines]

class Value(Protocol):
    @abstractmethod
    def to_config_lines(self) -> list[str]:
        raise NotImplementedError()

class ConfigEntry(Protocol):
    name: str

    @abstractmethod
    def to_config_lines(self) -> list[str]:
        raise NotImplementedError()

class Property(ConfigEntry):
    name: str
    value: Value

    def __init__(self, key: str, value: Value):
        self.name = key
        self.value = value

    def to_config_lines(self) -> list[str]:
        value_lines = self.value.to_config_lines()
        if len(value_lines) <= 0:
            return []

        identifier = escape_identifier(self.name)
        if isinstance(self.value, Array):
            identifier += "[]"

        if len(value_lines) == 1:
            return [f"{identifier} = {value_lines[0]};"]

        indented_lines = indent(value_lines)

        return [
            f"{identifier} = ",
            *(indented_lines[0:-1]),
            indented_lines[-1] + ";"
        ]

class ConfigEntryCollection:
    _children: list[ConfigEntry]
    _childMap: dict[str, ConfigEntry]

    def __init__(self, children: list[ConfigEntry] = []):
        self._children = list(children)
        self._childMap = {}

    def add(self, child: ConfigEntry):
        self._children.append(child)
        self._childMap[child.name] = child

    def addProperty(self, name: str, value: Value):
        self.add(Property(name, value))

    def get(self, name: str) -> Optional[ConfigEntry]:
        return self._childMap.get(name, None)

    def remove(self, name: str):
        member = self.get(name)
        if member:
            self._children.remove(member)
            del self._childMap[name]

    def entries(self):
        return self._children

class Class(ConfigEntryCollection):
    name: str

    def __init__(self, name: str, members: list[ConfigEntry] = []):
        super().__init__(members)
        self.name = name

    def to_config_lines(self) -> list[str]:
        entry_lines = []
        for entry in self.entries():
            entry_lines.extend(entry.to_config_lines())

        return [
            f"class {escape_identifier(self.name)} {{",
            *(indent(entry_lines)),
            "};"
        ]

class Config(ConfigEntryCollection):
    def __init__(self, members: list[ConfigEntry] = []):
        super().__init__(members)

    def to_config_lines(self) -> list[str]:
        entry_lines = [];
        for entry in self.entries():
            entry_lines.extend(entry.to_config_lines())
            entry_lines.append("")

        return entry_lines

    def to_string(self) -> str:
        return "\n".join(self.to_config_lines())


#=================
#   Value types
#=================

class EvalFormattedString(Value):
    source: list[str]

    def __init__(self, source: list[str]):
        self.source = source

    def to_config_lines(self) -> list[str]:
        if len(self.source) <= 0:
            return [""]

        return [rf"_EVAL(format [" + ", ".join(self.source) + "])"]

class String(Value):
    source: str

    def __init__(self, source: str):
        self.source = source

    def to_config_lines(self) -> list[str]:
        lines = self.source.splitlines()
        if len(lines) == 1:
            return ['"' + escape_string(lines[0]) + '"']

        escaped_lines = [escape_string(line) for line in lines]
        lines_with_line_ends = [line + "\\" for line in escaped_lines]

        # Format multi-line string
        return [
            '"' + lines_with_line_ends[0],
            *lines_with_line_ends[1:-1],
            escaped_lines[-1] + '"'
        ]

class Number(Value):
    source: int

    def __init__(self, source: int):
        self.source = source

    def to_config_lines(self) -> list[str]:
        return [str(self.source)]

ArrayMember = TypeVar('ArrayMember', bound=Value)
class Array(Value, Generic[ArrayMember]):
    source: list[ArrayMember]

    def __init__(self, source: list[ArrayMember]):
        self.source = source

    def to_config_lines(self) -> list[str]:
        all_member_lines = []
        for member in self.source:
            member_lines= member.to_config_lines()
            if len(member_lines) <= 0:
                continue
            member_lines[-1] = member_lines[-1] + ","
            all_member_lines.extend(member_lines)

        return ['{', *(indent(all_member_lines)), '}']
