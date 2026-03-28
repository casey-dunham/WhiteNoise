#!/bin/bash
set -e

APP_NAME="WhiteNoise"
BUILD_DIR="build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
ARCH=$(uname -m)

echo "Building WhiteNoise for $ARCH..."

rm -rf "$BUILD_DIR"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

swiftc \
    -target "${ARCH}-apple-macos13.0" \
    -O \
    -framework SwiftUI \
    -framework AppKit \
    -framework AVFoundation \
    -o "$APP_BUNDLE/Contents/MacOS/$APP_NAME" \
    Sources/*.swift

cp Resources/Info.plist "$APP_BUNDLE/Contents/"

codesign --force --sign - "$APP_BUNDLE"

echo ""
echo "Done! Built: $APP_BUNDLE"
echo ""
echo "  Run it:              open $APP_BUNDLE"
echo "  Install to Apps:     cp -r $APP_BUNDLE /Applications/"
echo ""
