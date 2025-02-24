#!/usr/bin/env sh

VERSION=0.1.0

has_exe() { [ -n "${1}" ] && command -v "${1}" 1>/dev/null 2>&1; }

exit_err() {
    printf "\e[31mError\e[0m: %s\n" "${1}" >&2
    exit 1
}

show_version() { printf "%s\n" "${VERSION}"; }

show_usage() {
    cat <<__USAGE__
Usage: ${0} [OPTIONS]

Script description.

Options:
        --tbd              TBD

Common options:
    -h, --help             Show this help message and exit
    -v, --version          Show the version and exit
__USAGE__
}

parse_opts() {
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
        -h | --help)
            show_usage
            exit 0
            ;;
        -v | --version)
            show_version
            exit 0
            ;;
        *)
            printf "Unknown option: %s\n" "${1}" >&2
            show_usage
            exit 1
            ;;
        esac
        shift
    done
}

main() {
    exit_err "unimplemented"
}

###

parse_opts "${@}"
main
