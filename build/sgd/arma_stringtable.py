from pathlib import Path
from typing import Literal, Optional
import xml.etree.ElementTree as ET

LanguagesLiteral = Literal[
    "Original",
    "English",
    "Czech",
    "French",
    "Spanish",
    "Italian",
    "Polish",
    "Portuguese",
    "Russian",
    "German",
    "Korean",
    "Japanese",
    "Chinese",
    "Chinesesimp",
    "Turkish"
]

class StringtableEntry:
    key: str
    languages: dict[LanguagesLiteral, str]

    def __init__(self, key: str, values: dict[LanguagesLiteral, str] = {}) -> None:
        self.key = key
        self.languages = {**values}


    def set_language_text(self, language: LanguagesLiteral, text: str):
        self.languages[language] = text

class StringtablePackage:
    name: str
    entries: list[StringtableEntry]

    def __init__(self, name: str) -> None:
        self.name = name
        self.entries = []

    def add_entry(self, entry: StringtableEntry):
        self.entries.append(entry)

class Stringtable:
    packages: list[StringtablePackage]

    def __init__(self) -> None:
        self.packages = []

    def add_package(self, package: StringtablePackage):
        self.packages.append(package)

    def get_package(self, package_name: str) -> StringtablePackage | None:
        return next((package for package in self.packages if package.name == package_name), None)

    def get_or_create_package(self, package_name: str) -> StringtablePackage:
        package = self.get_package(package_name)
        if not package:
            package = StringtablePackage(package_name)
            self.packages.append(package)
        return package

    def get_entry(self, key: str) -> StringtableEntry | None:
        return next(
            (entry for package in self.packages for entry in package.entries if entry.key == key),
            None
        )

    def patch_tree(self, project_elem: Optional[ET.Element]) -> ET.Element:
        if project_elem is None:
            project_elem = ET.Element("Project", { "name": "VGM" })

        for package in self.packages:
            package_elem = project_elem.find(f"./Package[@name='{package.name}']")
            if package_elem is None:
                package_elem = ET.Element("Package", { "name": package.name })
                project_elem.append(package_elem)

            for entry in package.entries:
                entry_elem = package_elem.find(f"./Key[@ID='{entry.key}']")
                if entry_elem is None:
                    entry_elem = ET.Element("Key", { "ID": entry.key  })
                    package_elem.append(entry_elem)

                for (language, text) in entry.languages.items():
                    language_elem = entry_elem.find("Original")
                    if language_elem is None:
                        language_elem = ET.Element(language)
                        entry_elem.append(language_elem)

                    language_elem.text = text

        ET.indent(project_elem, space="    ")

        return project_elem

    def to_string(self) -> str:
        return ET.tostring(self.patch_tree(None), encoding="unicode")


def patch_file(file_path: Path, stringtable: Stringtable):
    parser = ET.XMLParser(target=ET.TreeBuilder(insert_comments=True))
    tree = ET.parse(file_path, parser=parser)

    stringtable.patch_tree(tree.getroot())

    tree.write(file_path, encoding="unicode", xml_declaration=True)




