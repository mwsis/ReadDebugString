#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")

# ##########################################################
# colours

if command -v tput > /dev/null; then

  SisClr_Blue=${FG_BLUE:-$(tput setaf 4)}
  SisClr_Red=${FG_RED:-$(tput setaf 1)}
  SisClr_Bold=${FD_BOLD:-$(tput bold)}
  SisClr_None=${FD_NONE:-$(tput sgr0)}
else

  SisClr_Blue=
  SisClr_Red=
  SisClr_Bold=
  SisClr_None=
fi

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
      printf "Runs the ${SisClr_Blue}${SisClr_Bold}%s${SisClr_None} tests using CTest\n\n" "$ProjectName"
      printf '%s [--debug-configuration|-d] [--no-make|-M] [--help]\n' "$ScriptPath"
      exit 0
      ;;
    *)
      >&2 printf "%s: ${SisClr_Red}${SisClr_Bold}unrecognised argument %s${SisClr_None}; use --help for usage\n" "$ScriptPath" "$1"
      exit 1
      ;;
  esac
  shift
done

ctest --test-dir "$CMakeDir" -C "$Configuration" --output-on-failure

