from typing import Optional, Protocol

class Value(Protocol):
    pass

class ConfigEntry(Protocol):
    name: str

class Property(ConfigEntry):
    name: str
    value: Value

    def __init__(self, key: str, value: Value):
        self.name = key
        self.value = value

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


class Class(ConfigEntryCollection, ConfigEntry):
    def __init__(self, name: str, members: list[ConfigEntry] = []):
        super().__init__(members)
        self.name = name


class EvalFormattedString(Value):
    source: list[str]

    def __init__(self, source: list[str]):
        self.source = source

class String(Value):
    source: str

    def __init__(self, source: str):
        self.source = source

class Number(Value):
    source: int

    def __init__(self, source: int):
        self.source = source

class Array(Value):
    source: list[str]

    def __init__(self, source: list[str]):
        self.source = source


