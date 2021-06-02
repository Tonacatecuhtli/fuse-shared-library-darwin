#!/usr/bin/env bash

cd "$(dirname $0)"

# if you bump the version here remember to update it in index.js also.
LATEST_DMG='https://github.com/osxfuse/osxfuse/releases/download/macfuse-4.1.2/macfuse-4.1.2.dmg'
DMG_VOLUME='/Volumes/macFUSE'
DIRNAME="$PWD"
OUT="$PWD/macfuse"

rm -rf "$OUT"
mkdir -p "$OUT"

curl "$LATEST_DMG" -Lo "$OUT/macfuse-latest.dmg"

[ -d "$DMG_VOLUME" ] && umount "$DMG_VOLUME"
hdiutil attach "$OUT/macfuse-latest.dmg"
pkgutil --expand-full "$DMG_VOLUME/Install macFUSE.pkg" "$OUT/unpacked"
umount "$DMG_VOLUME"
mkdir -p "$OUT/"

cd "$OUT/unpacked/Core.pkg/Payload/Library/Filesystems/macfuse.fs"
tar czf "$OUT/macfuse.fs.tgz" "."

mv "$OUT/unpacked/Core.pkg/Payload/usr/local/include/fuse" "$OUT/include"
cp "$OUT/unpacked/Core.pkg/Payload/usr/local/lib/libosxfuse.2.dylib" "$OUT/"

rm -rf "$OUT/unpacked" "$OUT/macfuse-latest.dmg"

install_name_tool -id "@loader_path/libosxfuse.2.dylib" "$OUT/libosxfuse.2.dylib"
