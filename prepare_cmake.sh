#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")
CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}
Configuration=Release
RunMake=0

while [[ $# -gt 0 ]]; do
  case $1 in
    --debug-configuration|-d)
      Configuration=Debug
      ;;
    --run-make|-m)
      RunMake=1
      ;;
    --help)
      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      printf 'Prepares the CMake build for %s\n\n' "$ProjectName"
      printf '%s [--debug-configuration|-d] [--run-make|-m] [--help]\n' "$ScriptPath"
      exit 0
      ;;
    *)
      >&2 printf '%s: unrecognised argument %s; use --help for usage\n' "$ScriptPath" "$1"
      exit 1
      ;;
  esac
  shift
done

cmake -S "$Dir" -B "$CMakeDir" -DCMAKE_BUILD_TYPE="$Configuration" || exit 1

if [ "$RunMake" -ne 0 ]; then
  cmake --build "$CMakeDir" --config "$Configuration"
fi

