#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")
CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}

case ${1:-} in
  '')
    ;;
  --help)
    [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
    printf 'Removes the %s CMake build directory\n\n' "$ProjectName"
    printf '%s [--help]\n' "$ScriptPath"
    exit 0
    ;;
  *)
    >&2 printf '%s: unrecognised argument %s; use --help for usage\n' "$ScriptPath" "$1"
    exit 1
    ;;
esac

if [ -d "$CMakeDir" ]; then
  rm -rf "$CMakeDir"
fi

