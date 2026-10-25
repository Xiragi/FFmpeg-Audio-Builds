#!/usr/bin/env bash
set -eo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ $(uname -s) != Darwin ]]; then
    echo "This script requires macOS." >&2
    exit 1
fi
if (( BASH_VERSINFO[0] < 5 )); then
    echo "Use Homebrew Bash (bash 5 or newer)." >&2
    exit 1
fi

# GNU tools are build tools only; none are linked into the artifacts.
BREW_PREFIX="$(brew --prefix)"
for tool in bash coreutils gnu-sed make bison texinfo gettext; do
    tool_prefix="$(brew --prefix "$tool")"
    export PATH="$tool_prefix/bin:$tool_prefix/libexec/gnubin:$PATH"
done
case "$(uname -m)" in
    arm64) TARGET=macosarm64 ;;
    x86_64) TARGET=macos64 ;;
    *) echo "Unsupported macOS architecture" >&2; exit 1 ;;
esac
VARIANT=lgpl-audio
source util/vars.sh "$TARGET" "$VARIANT"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/ffmpeg-audio-macos.XXXXXXXX")"
echo "Native build directory: $WORK"
cleanup() {
    local status=$?
    if [[ $status == 0 ]]; then
        rm -rf "$WORK"
    else
        echo "Build files retained in $WORK" >&2
    fi
}
trap cleanup EXIT
export FFBUILD_PREFIX="$WORK/prefix"
export FFBUILD_CMAKE_TOOLCHAIN="$WORK/native.cmake"
export FFBUILD_CROSS_PREFIX=""
export FFBUILD_CXX_RUNTIME=-lc++
export CC=clang CXX=clang++
LIBTOOLIZE="$(brew --prefix libtool)/bin/glibtoolize"
export LIBTOOLIZE
FFBUILD_TOOLCHAIN="$(clang -dumpmachine)"
export FFBUILD_TOOLCHAIN
export CFLAGS="-O2 -fPIC -I$FFBUILD_PREFIX/include"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="-I$FFBUILD_PREFIX/include"
export LDFLAGS="-L$FFBUILD_PREFIX/lib"
export PKG_CONFIG=pkg-config
export PKG_CONFIG_LIBDIR="$FFBUILD_PREFIX/lib/pkgconfig:$FFBUILD_PREFIX/share/pkgconfig"
export PKG_CONFIG_PATH=""
# Ignore inherited search paths which could introduce Homebrew dylibs.
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH DYLD_LIBRARY_PATH CMAKE_PREFIX_PATH
mkdir -p "$FFBUILD_PREFIX" "$WORK/bin" "$WORK/licenses" "$WORK/sources"
cp images/base/git-mini-clone.sh "$WORK/bin/git-mini-clone"
cp images/base/retry-tool.sh "$WORK/bin/retry-tool"
chmod +x "$WORK/bin/"*
export PATH="$WORK/bin:$PATH"
cat > "$FFBUILD_CMAKE_TOOLCHAIN" <<EOF
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_PREFIX_PATH "$FFBUILD_PREFIX")
set(CMAKE_FIND_FRAMEWORK LAST)
set(CMAKE_IGNORE_PREFIX_PATH "$BREW_PREFIX")
EOF

# Follow the audio dependency graph in topological order. "base" contains
# cross-compiler setup, which is unnecessary for a native build.
declare -A VISITED
STAGES=()
visit() {
    local name="$1" script dep
    [[ $name != base ]] || return 0
    [[ ! -v VISITED[$name] ]] || return 0
    VISITED[$name]=1
    local candidates=("$ROOT"/scripts.d/??-"$name".sh)
    script="${candidates[0]}"
    [[ -f $script ]] || { echo "Missing recipe: $name" >&2; exit 1; }
    ( source "$ROOT/util/vars.sh" "$TARGET" "$VARIANT"; source "$script"; ffbuild_enabled ) || return 0
    for dep in $(source "$ROOT/util/vars.sh" "$TARGET" "$VARIANT"; source "$script"; ffbuild_depends); do
        visit "$dep"
    done
    STAGES+=("$script")
}
for dep in $(source scripts.d/zz-final.sh; ffbuild_depends); do
    visit "$dep"
done

for script in "${STAGES[@]}"; do
    name="$(basename "$script" .sh)"
    (
        set -e
        source "$ROOT/util/vars.sh" "$TARGET" "$VARIANT"
        source "$ROOT/util/dl_functions.sh"
        source "$script"
        # Use the recipe's HTTPS origin instead of the optional git:// mirror.
        [[ ${SCRIPT_MIRROR:-} != git://* ]] || SCRIPT_MIRROR="$SCRIPT_REPO"
        export FFBUILD_DESTDIR="$WORK/stage-$name"
        export FFBUILD_DESTPREFIX="$FFBUILD_DESTDIR$FFBUILD_PREFIX"
        mkdir -p "$WORK/sources/$name"
        cd "$WORK/sources/$name"
        eval "$(ffbuild_dockerdl)"
        source_dir="$PWD"
        ffbuild_dockerbuild
        cp -a "$FFBUILD_DESTPREFIX/." "$FFBUILD_PREFIX/"
        mkdir -p "$WORK/licenses/$name"
        (
            cd "$source_dir"
            find . -name .git -prune -o -type f \( -iname 'copying*' -o -iname 'license*' -o -iname 'copyright*' \) \
                -exec cp --parents '{}' "$WORK/licenses/$name/" \;
        )
        printf '%s %s %s\n' "$name" "${SCRIPT_REPO:-}" "${SCRIPT_COMMIT:-${SCRIPT_REV:-}}" >> "$WORK/dependencies.txt"
    )
done

# Private pkg-config metadata must use Apple's C++ runtime.
find "$FFBUILD_PREFIX" -name '*.pc' -exec sed -i 's/-lstdc++/-lc++/g' '{}' +
if find "$FFBUILD_PREFIX" -name '*.dylib' -o -name '*.so*' | grep -q .; then
    echo "A dependency installed a shared library into the static prefix." >&2
    exit 1
fi

source "variants/$TARGET-$VARIANT.sh"
FFMPEG_SOURCE="${FFMPEG_REPO_OVERRIDE:-https://github.com/FFmpeg/FFmpeg.git}"
FFMPEG_REF="${FFMPEG_COMMIT:-${GIT_BRANCH_OVERRIDE:-$GIT_BRANCH}}"
git-mini-clone "$FFMPEG_SOURCE" "$FFMPEG_REF" "$WORK/ffmpeg"
cd "$WORK/ffmpeg"
# FFmpeg libraries and third-party libraries are static. Apple system libraries
# and frameworks remain dynamic, as required by the macOS platform.
./configure --prefix="$WORK/installed" --disable-doc \
    --pkg-config="pkg-config --static" --pkg-config-flags=--static \
    --extra-cflags="$CFLAGS" --extra-cxxflags="$CXXFLAGS" \
    --extra-ldflags="$LDFLAGS" --extra-libs="$FFBUILD_CXX_RUNTIME $FF_LIBS" \
    --enable-static --disable-shared --extra-version="$(date +%Y%m%d)" \
    $FF_CONFIGURE || { cat ffbuild/config.log; exit 1; }
if grep -Eq '^#define CONFIG_(GPL|NONFREE) 1$' config.h; then
    echo "Refusing a GPL or nonfree audio build." >&2
    exit 1
fi
make -j"$(nproc)"
make install

BUILD_NAME="ffmpeg-$(./ffbuild/version.sh .)-$TARGET-$VARIANT"
PACKAGE="$WORK/package/$BUILD_NAME"
mkdir -p "$PACKAGE/bin" "$PACKAGE/licenses" "$ROOT/artifacts"
cp "$WORK/installed/bin/ffmpeg" "$WORK/installed/bin/ffprobe" "$PACKAGE/bin/"
cp COPYING.LGPLv3 "$PACKAGE/LICENSE.txt"
cp -a "$WORK/licenses/." "$PACKAGE/licenses/"
cp "$WORK/dependencies.txt" "$PACKAGE/dependencies.txt"
cp config.h config_components.h ffbuild/config.mak "$PACKAGE/"
git rev-parse HEAD > "$PACKAGE/ffmpeg-commit.txt"

python3 "$ROOT/util/check_macos_linkage.py" "$PACKAGE/bin/ffmpeg" "$PACKAGE/bin/ffprobe"
tar -cJf "$ROOT/artifacts/$BUILD_NAME.tar.xz" -C "$WORK/package" "$BUILD_NAME"
printf '%s\n' "$BUILD_NAME.tar.xz" > "$ROOT/artifacts/$TARGET-$VARIANT.txt"
