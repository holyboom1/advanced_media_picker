
<p align="center">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter"
      alt="Platform" />
  </a>
  <a href="https://pub.dartlang.org/packages/advanced_media_picker">
    <img src="https://img.shields.io/pub/v/advanced_media_picker.svg"
      alt="Pub Package" />
  </a>
  <a href="https://github.com/holyboom1/advanced_media_picker/issues">
    <img src="https://img.shields.io/github/workflow/status/holyboom1/advanced_media_picker/CI?logo=github"
      alt="Build Status" />
  </a>
  <br>
  <a href="https://codecov.io/gh/holyboom1/advanced_media_picker">
    <img src="https://codecov.io/gh/holyboom1/advanced_media_picker/branch/master/graph/badge.svg"
      alt="Codecov Coverage" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/holyboom1/advanced_media_picker?color=red"
      alt="License: MIT" />
  </a>

</p>

# Advanced Media Picker

#### _Advanced Media Picker Package for Flutter_
###### [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C8Z5SA5)

## Getting Started

This plugin displays a gallery with user's Albums and Photos with ability to take photo and video.

## Prepare for use

### Configure native platforms

Minimum platform versions:
**Android 16, iOS 9.0, macOS 10.15**.

- Android: [Android config preparation](#android-config-preparation).
- iOS: [iOS config preparation](#ios-config-preparation).
- macOS: Pretty much the same with iOS.

#### Android config preparation

##### Kotlin, Gradle, AGP

We ship this plugin with **Kotlin `1.7.22`**.
If your projects use a lower version of Kotlin/Gradle/AGP,
please upgrade them to a newer version.

More specifically:

- Upgrade your Gradle version (`gradle-wrapper.properties`)
  to `7.5.1` or the latest version.
- Upgrade your Kotlin version (`ext.kotlin_version`)
  to `1.7.22` or the latest version.
- Upgrade your AGP version (`com.android.tools.build:gradle`)
  to `7.2.2` or the latest version.

##### Android 10 (Q, 29)

_If you're not setting your `compileSdkVersion` or `targetSdkVersion` to 29,
you can skip this section._

On Android 10, **Scoped Storage** was introduced,
which causes the origin resource file not directly
inaccessible through it file path.

If your `compileSdkVersion` or `targetSdkVersion` is `29`,
you can consider adding `android:requestLegacyExternalStorage="true"`
to your `AndroidManifest.xml` in order to obtain resources:

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.example">

    <application android:label="example" android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true"></application>
</manifest>
```

**Note: Apps that are using the flag will be rejected from the Google Play.**

#### iOS config preparation

Define the `NSPhotoLibraryUsageDescription` , `NSCameraUsageDescription`
and `NSMicrophoneUsageDescription`
key-value in the `ios/Runner/Info.plist`:

```plist
<key>NSPhotoLibraryUsageDescription</key>
<string>In order to access your photo library</string>
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

## Usage

### Request for permission

This plugin requires the user's permission to access the media library and camera .
You should handle cases where the user denies the permission request.

#### Limited entities access

##### Limited entities access on iOS

With iOS 14 released, Apple brought a "Limited Photos Library" permission
(`PermissionState.limited`) to iOS.

To suppress the automatic prompting from the system
when each time you access the media after the app has restarted,
you can set the `Prevent limited photos access alert` key to `YES`
in your app's `Info.plist` (or manually writing as below):

```plist
<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key>
<true/>
```

##### Limited entities access on Android

Android 14 (API 34) has also introduced the concept of limited assets similar to iOS.

However, there is a slight difference in behavior (based on the emulator):
On Android, the access permission to a certain resource cannot be revoked once it is granted,
even if it hasn't been selected when using `presentLimited` in future actions.

### Usage

1. Add the plugin to your `pubspec.yaml` file:

```yaml
dependencies:
  advanced_media_picker: ^0.0.1
```

2. Import the plugin in your Dart code:

```dart
import 'package:advanced_media_picker/advanced_media_picker.dart';
```

3. Use the plugin in your Dart code:

```dart

final List<XFile> result = 
        await AdvancedMediaPicker.openPicker(
                                    context: context,
                                    style: PickerStyle(),
                                    cameraStyle: CameraStyle(),
                                    allowedTypes: PickerAssetType.image,
                                    maxVideoDuration: 60,
                                    selectionLimit: 10,
                                    showCamera : true,
                                    videoCamera : true,
                                    );
```

### Parameters

- `context`: The `BuildContext` of the widget.
- `style`: The `PickerStyle` object to customize the picker.

```dart
 BorderRadius borderRadius;
 BorderRadius itemsBorderRadius;
 Color backgroundColor;
 Color textColor;
 Color selectIconBackgroundColor;
 Border selectIconBorder;
 Widget selectIcon;
 Widget cameraIcon;
 bool isNeedDragIndicator;
 Color dragIndicatorColor;
 EdgeInsets mainPadding;
 Color shimmerBaseColor;
 Color shimmerHighlightColor;
 Color dividerColor;
 Alignment selectIconAlignment;
 BoxDecoration selectedFolderDecoration;
 BoxDecoration unselectedFolderDecoration;
 BoxDecoration cameraContainerDecoration;
 Color selectedFolderTextColor;
 Color unselectedFolderTextColor;
/// A function that returns a boolean value from your custom alert dialog.
 bool Function()? showCustomAlert;
 Widget? completeWidget;
 Widget? typeSelectionWidget;
 double bottomPadding;
```

- `cameraStyle`: The `CameraStyle` object to customize the camera.

```dart
Widget cameraCloseIcon;
Widget takePictureIcon;
Widget chooseCameraIcon;
Widget cameraBackButton;
Widget cameraAddMediaButton;
Widget cameraDeleteMediaButton;
Widget cameraSelectedMediaButton;
Widget videoIcon;
Widget flipCameraIcon;
String finishButtonTitle;
TextStyle finishButtonStyle;
EdgeInsets finishButtonPadding;
```

- `allowedTypes`: The `PickerAssetType` enum to allow the user to select.

```dart
enum PickerAssetType {
  other,
  all,
  image,
  imageAndVideo,
  video,
  audio;
}
```

```dart
bool isNeedToShowCamera = true,
bool isNeedVideoCamera = true,
int maxVideoDuration = -1,
List<String> fileSelectorAllowedTypes = const <String>['pdf', 'doc'],
/// The maximum number of files that can be selected in the picker.
/// If the value is -1, it means that there is no limit to the number of files that can be selected.
int selectionLimit = 3,
PickerController? controller,
```
## Screenshots / Demo

[<img src="https://i.ytimg.com/vi/Hc79sDi3f0U/maxresdefault.jpg" width="50%">](https://youtu.be/E6lGKX7U2SQ "Now in Android: 55")

______________________________________________

## Plugins

Dillinger is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin                       | README                                                |
|------------------------------|-------------------------------------------------------|
| photo_manager                | https://pub.dev/packages/photo_manager                |
| photo_manager_image_provider | https://pub.dev/packages/photo_manager_image_provider |
| flutter_sticky_header        | https://pub.dev/packages/flutter_sticky_header        |
| camera                       | https://pub.dev/packages/camera                       |

