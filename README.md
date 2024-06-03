# Advanced Media Picker

#### _Advanced Media Picker Package for Flutter_

## Getting Started

This plugin displays a gallery with user's Albums and Photos with ability to take photo and video.

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

final List<XFile> result = await
AdvancedMediaPicker.openPicker
(
context: context,
style: PickerStyle(),
cameraStyle: CameraStyle(),
allowedTypes: PickerAssetType.image,
maxVideoDuration: 60,
selectionLimit: 10,
showCamera:
true
,
videoCamera
:
true
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
```

- `cameraStyle`: The `CameraStyle` object to customize the camera.

```dart
Widget cameraCloseIcon;
Widget takePictureIcon;
Widget chooseCameraIcon;
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

- `maxVideoDuration`: The maximum duration in seconds of the video.
- `selectionLimit`: The maximum number of items that the user can select.
- `showCamera`: A boolean to show the camera button.
- `videoCamera`: A boolean to allow the user to take videos.



## Screenshots / Demo

* 

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

