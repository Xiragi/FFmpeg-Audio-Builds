#!/bin/bash

SCRIPT_SKIP="1"

ffbuild_depends() {
    echo libiconv
    echo zlib
    echo gmp
    echo openssl
    echo xz

    echo libvorbis
    echo libmp3lame
    echo libopus
    echo opencore-amr
    [[ $TARGET != winarm64 ]] && echo openmpt
    echo soxr
    echo twolame

    echo rpath
}

ffbuild_enabled() {
    return 0
}

ffbuild_dockerfinal() {
    return 0
}

ffbuild_dockerdl() {
    return 0
}

ffbuild_dockerlayer() {
    return 0
}

ffbuild_dockerstage() {
    return 0
}

ffbuild_dockerbuild() {
    return 0
}

ffbuild_ldexeflags() {
    return 0
}
