#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")
CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}
Configuration=Release

while [[ $# -gt 0 ]]; do
  case $1 in
    --debug-configuration|-d)
      Configuration=Debug
      ;;
    --no-make|-M)
      ;;
    --help)
      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      printf 'Runs the %s tests using CTest\n\n' "$ProjectName"
      printf '%s [--debug-configuration|-d] [--no-make|-M] [--help]\n' "$ScriptPath"
      exit 0
      ;;
    *)
      >&2 printf '%s: unrecognised argument %s; use --help for usage\n' "$ScriptPath" "$1"
      exit 1
      ;;
  esac
  shift
done

ctest --test-dir "$CMakeDir" -C "$Configuration" --output-on-failure

