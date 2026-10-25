#!/bin/bash

SCRIPT_REPO="https://github.com/acoustid/chromaprint.git"
SCRIPT_COMMIT="aed8eba2202dd9d7b3b0a56c77904cc805490d72"

ffbuild_depends() {
    echo base
    [[ $VARIANT == lgpl* ]] || echo fftw3
    return 0
}

ffbuild_enabled() {
    (( $(ffbuild_ffver) >= 600 )) || return -1
    return 0
}

ffbuild_dockerbuild() {
    local fft_lib=fftw3
    [[ $VARIANT != lgpl* ]] || fft_lib=kissfft
    mkdir build && cd build

    local fft_options=()
    if [[ $fft_lib == kissfft ]]; then
        fft_options+=( -DKISSFFT_SOURCE_DIR="$PWD/../src/3rdparty/kissfft" )
    fi
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DBUILD_SHARED_LIBS=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DBUILD_TOOLS=OFF -DBUILD_TESTS=OFF -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON \
        -DFFT_LIB="$fft_lib" "${fft_options[@]}" ..
    make -j$(nproc)
    make install DESTDIR="$FFBUILD_DESTDIR"

    if [[ $fft_lib == fftw3 ]]; then
        echo "Libs.private: -lfftw3 ${FFBUILD_CXX_RUNTIME:--lstdc++} -lm" >> "$FFBUILD_DESTPREFIX"/lib/pkgconfig/libchromaprint.pc
    else
        echo "Libs.private: ${FFBUILD_CXX_RUNTIME:--lstdc++} -lm" >> "$FFBUILD_DESTPREFIX"/lib/pkgconfig/libchromaprint.pc
    fi
    echo "Cflags.private: -DCHROMAPRINT_NODLL" >> "$FFBUILD_DESTPREFIX"/lib/pkgconfig/libchromaprint.pc
}

ffbuild_configure() {
    echo --enable-chromaprint
}

ffbuild_unconfigure() {
    echo --disable-chromaprint
}
