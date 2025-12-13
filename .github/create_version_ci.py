"""
Creates VGM version string from CI environment variables
"""
import os
import re
import sys


def parse_github_ref():
    ref = os.environ.get("GITHUB_REF_NAME", "")
    if not ref.strip():
        return None
    match = re.fullmatch(r"v(?P<version>[0-9]+.[0-9]+.[0-9]+)-?(?P<postfix>[\w-]+)?", ref)
    if not match:
        return None
    return {
        "version": match.group("version"),
        "postfix": match.groupdict()["postfix"] or "beta"
    }


def github_commit_hash():
    return os.environ["GITHUB_SHA"][0:8]

github_ref_info = parse_github_ref()

version_number_input = os.environ.get("GITHUB_INPUT_VERSION", None)
version_number_tag = github_ref_info and github_ref_info["version"]

version_number = version_number_input or version_number_tag

if not version_number:
    print("Version number not found", file=sys.stderr, flush=True)
    sys.exit(1)

postfix_input = os.environ.get("GITHUB_INPUT_POSTFIX", None)
postfix_tag = github_ref_info and github_ref_info["postfix"]

postfix = postfix_input or postfix_tag

if not postfix:
    print("Postfix not found", file=sys.stderr, flush=True)
    sys.exit(1)

commit_hash = github_commit_hash()

if not postfix:
    print("Commit hash not found", file=sys.stderr, flush=True)
    sys.exit(1)


version = f"v{version_number}@{commit_hash} {postfix}"
print(version, end="", flush=True)
