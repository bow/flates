"""
Package description.
"""

from importlib.metadata import PackageNotFoundError, version
from pathlib import Path

NAME = "pkg"

# __author__ = ""
# __contact__ = ""
# __homepage__ = ""
try:
    __version__ = version(__name__)
except PackageNotFoundError:
    __version__ = "0.0.dev0"

del PackageNotFoundError, Path, version
