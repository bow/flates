#!/usr/bin/env python

"""
Script description.
"""

import argparse
import sys

__version__ = "0.1.0"


def main() -> None:
    raise NotImplementedError("unimplemented")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        usage=f"{sys.argv[0]} [options]",
        formatter_class=argparse.RawTextHelpFormatter,
        description=__doc__.strip(),
    )
    parser.add_argument("-v", "--version", action="version", version=__version__)

    args = parser.parse_args()

    main()
