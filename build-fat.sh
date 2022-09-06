# Builds a fat library for a given xcode project (framework)
# https://docs.microsoft.com/en-us/xamarin/ios/platform/binding-swift/walkthrough

echo "Define parameters"
IOS_SDK_VERSION="15.5" # xcodebuild -showsdks
SWIFT_PROJECT_NAME="PhotoBrowser"
SWIFT_PROJECT_PATH="$SWIFT_PROJECT_NAME.xcodeproj"
SWIFT_BUILD_PATH="Output/build"
SWIFT_OUTPUT_PATH="Output/PhotoBrowser"
XAMARIN_BINDING_PATH="sharpie_output"
BUILD_ROOT="$(pwd)/$SWIFT_BUILD_PATH"

echo "Build iOS framework for simulator and device"
rm -Rf "$SWIFT_BUILD_PATH"
xcodebuild -sdk iphonesimulator$IOS_SDK_VERSION -project "$SWIFT_PROJECT_PATH" -configuration Release -scheme "$SWIFT_PROJECT_NAME" SYMROOT="$BUILD_ROOT" ARCHS=x86_64
xcodebuild -sdk iphoneos$IOS_SDK_VERSION -project "$SWIFT_PROJECT_PATH" -configuration Release -scheme "$SWIFT_PROJECT_NAME" SYMROOT="$BUILD_ROOT"

echo "Create fat binaries for Release-iphoneos and Release-iphonesimulator configuration"
echo "Copy one build as a fat framework"
cp -R "$SWIFT_BUILD_PATH/Release-iphoneos" "$SWIFT_BUILD_PATH/Release-fat"

echo "Combine modules from another build with the fat framework modules"
cp -R "$SWIFT_BUILD_PATH/Release-iphonesimulator/NSKPhotoBrowseruke.framework/Modules/SKPhotoBrowser.swiftmodule/" "$SWIFT_BUILD_PATH/Release-fat/SKPhotoBrowser.framework/Modules/SKPhotoBrowser.swiftmodule/"
cp -R "$SWIFT_BUILD_PATH/Release-iphonesimulator/PhotoBrowser.framework/Modules/PhotoBrowser.swiftmodule/" "$SWIFT_BUILD_PATH/Release-fat/PhotoBrowser.framework/Modules/PhotoBrowser.swiftmodule/"

echo "Combine iphoneos + iphonesimulator configuration as fat libraries"
lipo -create -output "$SWIFT_BUILD_PATH/Release-fat/SKPhotoBrowser.framework/SKPhotoBrowser" "$SWIFT_BUILD_PATH/Release-iphoneos/SKPhotoBrowser.framework/SKPhotoBrowser" "$SWIFT_BUILD_PATH/Release-iphonesimulator/SKPhotoBrowser.framework/SKPhotoBrowser"
lipo -create -output "$SWIFT_BUILD_PATH/Release-fat/PhotoBrowser.framework/PhotoBrowser" "$SWIFT_BUILD_PATH/Release-iphoneos/PhotoBrowser.framework/PhotoBrowser" "$SWIFT_BUILD_PATH/Release-iphonesimulator/PhotoBrowser.framework/PhotoBrowser"

echo "Verify results"
lipo -info "$SWIFT_BUILD_PATH/Release-fat/SKPhotoBrowser.framework/SKPhotoBrowser"
lipo -info "$SWIFT_BUILD_PATH/Release-fat/PhotoBrowser.framework/PhotoBrowser"

echo "Copy fat frameworks to the output folder"
rm -Rf "$SWIFT_OUTPUT_PATH"
mkdir -p "$SWIFT_OUTPUT_PATH"
cp -Rf "$SWIFT_BUILD_PATH/Release-fat/$SWIFT_PROJECT_NAME.framework" "$SWIFT_OUTPUT_PATH"

echo "Generating binding api definition and structs"
sharpie bind --sdk=iphoneos$IOS_SDK_VERSION --output="$SWIFT_OUTPUT_PATH/XamarinApiDef" --namespace="Xamarin.PhotoBrowser" --scope="$SWIFT_OUTPUT_PATH/$SWIFT_PROJECT_NAME.framework/Headers/" "$SWIFT_OUTPUT_PATH/$SWIFT_PROJECT_NAME.framework/Headers/$SWIFT_PROJECT_NAME-Swift.h"

echo "Replace existing metadata with the udpated"
cp -Rf "$SWIFT_OUTPUT_PATH/XamarinApiDef/." "$XAMARIN_BINDING_PATH/"

echo "Done!"
