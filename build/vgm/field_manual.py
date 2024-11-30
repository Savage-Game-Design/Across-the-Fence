from dataclasses import dataclass
from pathlib import Path
import re

import tomllib
from typing import Any, Optional, TypedDict, cast

import sgd.arma_config as arma_config
import sgd.arma_stringtable as arma_stringtable
from sgd.arma_stringtable import StringtableEntry, Stringtable

FieldManualStringtableEntry = tuple[str, str]

def to_stringtable_key(segments: list[str]) -> str:
    suffix = "_".join(segments).upper()
    return f"STR_VGM_FIELD_MANUAL_{suffix}"

def _replace_text_between_positions(original: str, new: str, start: int, end: int) -> str:
    return original[0:start] + new + original[end:]

# Matches whitespace at start of line, followed by `- ` or `* ``
bullet_regex = re.compile(r"^\s*(-|\*) ")
# Matches args, in format {1} {21}, etc. Unless preceeded by a backslash, such as \{1}
arg_regex = re.compile(r"(?<!\\)\{(\d+)\}")
def format_description_line(original_text: str) -> str:
    text = original_text
    bullet_match = bullet_regex.match(text)
    # Replace - or * with bullet, if it's starting a line (after whitespace)
    if bullet_match:
        text = _replace_text_between_positions(text, "%2", bullet_match.start(1), bullet_match.end(1))

    text = text.replace("[h]", "%3")
    text = text.replace("[/h]", "%4")

    while arg_match := arg_regex.search(text):
        arg_index = int(arg_match.group(1), 10)
        arg_code = 10 + arg_index
        text = _replace_text_between_positions(text, f"%{arg_code}", arg_match.start(), arg_match.end())

    return text


def format_description(text: str) -> str:
    lines = text.splitlines()
    return "%1".join(map(format_description_line, lines))

# Normal string, or an _EVAL formatted string
StrDef = str | list[str]

class _CategoryDefinition(TypedDict):
    displayName: StrDef
    pages: list[str]
    order: Optional[int]

class _PageDefinition(TypedDict):
    displayName: StrDef
    # This is heavily processed, so needs to strictly be a string.
    description: str
    tip: Optional[StrDef]
    arguments: Optional[list[str]]
    image: Optional[str]
    Triggers: Optional[dict[str, Any]]


class FieldManualConfigBuilder:
    stringtable_entries: list[StringtableEntry]
    categories: list[arma_config.Class]

    def __init__(self):
        self.stringtable_entries = []
        self.categories = []

    def add_to_stringtable(self, key_segments: list[str], text: str) -> str:
        key = to_stringtable_key(key_segments)
        entry = StringtableEntry(key, {
            "Original": text,
            "English": text,
        })
        self.stringtable_entries.append(entry)
        return key

    def add_formattable_text(self, key_segments: list[str], text: StrDef) -> arma_config.Value:
        if isinstance(text, list):
            if len(text) == 0:
                return arma_config.String("")

            if "%" in text[0]:
                stringtable_key = self.add_to_stringtable(key_segments, text[0])
                new_text = [f"localize '{stringtable_key}'"] + text[1:]
                return arma_config.EvalFormattedString(new_text)

            joined_text = "".join(text)

            return arma_config.String("$" + self.add_to_stringtable(key_segments, joined_text))

        # Already a stringtable entry - don't add again.
        if "$STR" in text:
            return arma_config.String(text)

        return arma_config.String("$" + self.add_to_stringtable(key_segments, text))

    def _prepare_description(self, key_segments: list[str], text: str) -> arma_config.String:
        description = format_description(text)
        return arma_config.String("$" + self.add_to_stringtable(key_segments, description))

    def add_category(
        self,
        category_name: str,
        category_def: _CategoryDefinition,
        page_defs: dict[str, _PageDefinition]
    ) -> arma_config.Class:
        category = arma_config.Class(category_name)

        logicalOrder = category_def.get("order", None)
        if logicalOrder:
            category.addProperty("logicalOrder", arma_config.Number(logicalOrder))

        category.addProperty(
            "displayName",
            self.add_formattable_text([category_name], category_def["displayName"])
        )

        for (index, page_name) in enumerate(category_def["pages"], 1):
            page_def = page_defs.get(page_name, None)
            if not page_def:
                print(f"No page found for '{category_name}' -> '{page_name}'")
                continue
            page = self._make_page(page_name, page_def)
            page.addProperty("logicalOrder", arma_config.Number(index))
            category.add(page)

        self.categories.append(category)

        return category

    def _make_page(self, page_name: str, page_def: _PageDefinition) -> arma_config.Class:
        page = arma_config.Class(page_name)

        page.addProperty("displayName", self.add_formattable_text([page_name], page_def["displayName"]))

        page.addProperty(
            "description",
            self._prepare_description([page_name, "DESC"], page_def["description"])
        )

        tip = page_def.get("tip", None)
        if tip:
            page.addProperty("tip", self.add_formattable_text([page_name, "TIP"], tip))

        image = page_def.get("image", None)
        if image:
            page.addProperty("image", arma_config.String(image))

        arguments = page_def.get("arguments", None)
        if arguments:
            page.addProperty(
                "arguments",
                arma_config.Array([arma_config.String(arg) for arg in arguments])
            )

        triggers = page_def.get("Triggers", None)
        if triggers and len(triggers) > 0:
            trigger_entry = arma_config.python_type_to_config_entry("Triggers", triggers)
            if trigger_entry:
                page.add(trigger_entry)

        return page


def _read_toml_file(file_path: Path) -> dict:
    with open(file_path, "rb") as toml_file:
        return tomllib.load(toml_file)

@dataclass
class ParseResult:
    categories: list[arma_config.Class]
    stringtable_entries: list[StringtableEntry]

def parse_field_manual_entries(files_root: Path) -> ParseResult:
    builder = FieldManualConfigBuilder()

    category_defs: dict[str, _CategoryDefinition] = _read_toml_file(files_root / "index.toml")

    for (category_name, category_definition) in category_defs.items():
        page_definitions = {}
        for page_name in category_definition["pages"]:
            page_file_name = f"{page_name}.toml"
            page_path = files_root / page_file_name
            if not page_path.exists():
                print(f"Cannot build field manual entry '{category_name} -> {page_name}', source file '{page_file_name}' found.")
                continue
            page_definition = cast(_PageDefinition, _read_toml_file(page_path))
            page_definitions[page_name] = page_definition

        builder.add_category(category_name, category_definition, page_definitions)

    return ParseResult(builder.categories, builder.stringtable_entries)

def update_field_manual(files_root: Path):
    result: ParseResult = parse_field_manual_entries(files_root / "field_manual")

    # Additional `list` call here fixes a weird type error
    config = arma_config.Config(list(result.categories))

    with open(files_root / "game" / "configs" / "mission" / "cfg_field_manual.hpp", "w") as field_manual_file:
        field_manual_file.write(config.to_string())

    patch_stringtable = Stringtable()
    field_manual_package = patch_stringtable.get_or_create_package("Field Manual")
    for entry in result.stringtable_entries:
        field_manual_package.add_entry(entry)

    arma_stringtable.patch_file(
        files_root / "game" / "mission" / "stringtable.xml",
        patch_stringtable
    )
