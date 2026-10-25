#!/usr/bin/env python3
"""Reject macOS executables that require libraries outside the operating system."""
from pathlib import Path
import subprocess
import sys


def validate_listing(listing):
    dependencies = [line.strip().split(" (", 1)[0] for line in listing.splitlines()[1:] if line.strip()]
    if not dependencies:
        raise ValueError("otool did not report any dynamic library dependencies")
    for dependency in dependencies:
        if not dependency.startswith(("/usr/lib/", "/System/Library/")):
            raise ValueError("Non-system dynamic dependency: " + dependency)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit("Usage: check_macos_linkage.py <executable> [executable ...]")
    for binary in sys.argv[1:]:
        listing = subprocess.check_output(["otool", "-L", binary], text=True)
        print(listing, end="")
        validate_listing(listing)
        print("PASS: system-only dynamic dependencies:", Path(binary).name)
