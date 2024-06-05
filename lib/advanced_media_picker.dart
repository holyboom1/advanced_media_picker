library advanced_media_picker;

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'advanced_media_picker_impl.dart';
import 'models/camera_style.dart';
import 'models/picker_style.dart';

export 'package:cross_file/cross_file.dart' show XFile;

export 'advanced_media_picker_impl.dart' show PickerAssetType;
export 'models/camera_style.dart';
export 'models/close_alert_style.dart';
export 'models/picker_style.dart';

final DataStore dataStore = DataStore();
final AssetsService assetsService = AssetsService();

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
    dataStore.limitToSelection = selectionLimit;
    dataStore.maxVideoDuration = maxVideoDuration;
    dataStore.isNeedToShowCamera = showCamera;
    dataStore.isNeedToTakeVideo = videoCamera;
    dataStore.style = style ?? PickerStyle();
    dataStore.cameraStyle = cameraStyle ?? CameraStyle();

    if (!await assetsService.requestPermissions()) {
      throw Exception('Permission denied');
    }
    await assetsService.getAssetsPath(
      allowedTypes: allowedTypes ?? PickerAssetType.all,
    );
    final Completer<List<XFile>> completer = Completer<List<XFile>>();

    try {
      unawaited(Navigator.push(
        context,
        PageRouteBuilder<void>(
          barrierColor: Colors.black26,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ),
              ),
              child: const PickerBottomSheet(),
            );
          },
          opaque: false,
          fullscreenDialog: true,
          barrierDismissible: true,
          pageBuilder: (_, __, ___) {
            return const PickerBottomSheet();
          },
        ),
      ));
    } catch (_) {}

    return completer.future;
  }
}
