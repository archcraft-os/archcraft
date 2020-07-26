#!/usr/bin/env bash

## rofi sudo askpass helper
export SUDO_ASKPASS=/usr/local/bin/askpass_rofi.sh

## zenity sudo askpass helper
#export SUDO_ASKPASS=/usr/local/bin/askpass_zenity.sh

## execute the application
sudo -A $1
