library advanced_media_picker;

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'advanced_media_picker_impl.dart';
import 'models/camera_style.dart';
import 'models/picker_style.dart';

export 'package:cross_file/cross_file.dart' show XFile;
export 'advanced_media_picker_impl.dart' show PickerAssetType;
export 'models/picker_style.dart';
export 'models/camera_style.dart';

class AdvancedMediaPicker {
  static Future<List<XFile>> openPicker({
    required BuildContext context,
    bool showCamera = true,
    bool videoCamera = true,
    int maxVideoDuration = -1,

    /// The maximum number of files that can be selected in the picker.
    /// If the value is -1, it means that there is no limit to the number of files that can be selected.
    int selectionLimit = 3,
    PickerAssetType? allowedTypes,
    PickerStyle? style,
    CameraStyle? cameraStyle,
  }) async {
    limitToSelection = selectionLimit;
    videoDuration = maxVideoDuration;
    isNeedToShowCamera = showCamera;
    isNeedToTakeVideo = videoCamera;
    if (!await requestPermissions()) {
      throw Exception('Permission denied');
    }
    await getAssetsPath(
      allowedTypes: allowedTypes ?? PickerAssetType.all,
    );

    // List<MediaFile>? media;
    try {
      await Navigator.push(
        context,
        PageRouteBuilder(
          barrierColor: Colors.black26,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ),
              ),
              child: PickerBottomSheet(
                style: style ?? PickerStyle(),
                cameraStyle: cameraStyle ?? CameraStyle(),
              ),
            );
          },
          opaque: false,
          fullscreenDialog: true,
          barrierDismissible: true,
          pageBuilder: (_, __, ___) => PickerBottomSheet(
            style: style ?? PickerStyle(),
            cameraStyle: cameraStyle ?? CameraStyle(),
          ),
        ),
      );
    } catch (_) {}

    return onClose();
  }
}
