#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

printf '\n[%s] WARNING: %s\n\n' "mkarchiso" "build.sh scripts are deprecated! Please use mkarchiso directly." >&2
_buildsh_path="$(realpath -- "$0")"
exec mkarchiso "$@" "${_buildsh_path%/*}"
