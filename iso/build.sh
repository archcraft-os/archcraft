#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Deprecated in official archiso

_buildsh_path="$(realpath -- "$0")"
exec mkarchcraftiso "$@" "${_buildsh_path%/*}"
