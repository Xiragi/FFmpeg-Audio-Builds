#!/bin/bash
source "$(dirname "$BASH_SOURCE")"/defaults-lgpl-audio.sh
FF_CONFIGURE+=" --enable-shared --disable-static"
