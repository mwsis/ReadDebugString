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
    >&2 printf "%s: ${SisClr_Red}${SisClr_Bold}unrecognised argument %s${SisClr_None}; use --help for usage\n" "$ScriptPath" "$1"
    exit 1
    ;;
esac

if [ -d "$CMakeDir" ]; then
  rm -rf "$CMakeDir"
fi

