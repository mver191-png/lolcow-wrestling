"""Blender entry point for the shared region-aware asset compiler.
Also runnable with standard Python. Import the resulting GLB in Blender to edit.
"""
from pathlib import Path
import runpy
import sys

if __name__ == "__main__":
    sys.argv = ["build_roster.py", "--character", "tophiachu"]
    runpy.run_path(str(Path(__file__).resolve().parents[1] / "tools" / "build_roster.py"), run_name="__main__")
