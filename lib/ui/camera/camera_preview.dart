import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';

/// Camera preview widget
class CameraPreviewWidget extends StatefulWidget {
  /// Constructor
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  Future<void> onTapSetFocus(TapUpDetails details) async {
    showFocusCircle.value = false;

    if (dataStore.cameraControllers[dataStore.selectedCameraIndex.value].value.isInitialized) {
      focusX = details.localPosition.dx;
      focusY = details.localPosition.dy;

      final double fullWidth = MediaQuery.of(context).size.width;
      final double cameraHeight =
          fullWidth * dataStore.cameraControllers[dataStore.selectedCameraIndex.value].value.aspectRatio;

      final double xp = focusX / fullWidth;
      final double yp = focusY / cameraHeight;
      showFocusCircle.value = true;

      final Offset point = Offset(xp, yp);

      await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].setFocusPoint(point);

      unawaited(
          Future<void>.delayed(const Duration(seconds: 2)).whenComplete(() {
        showFocusCircle.value = false;
      }));
    }
  }

  ValueNotifier<bool> showFocusCircle = ValueNotifier<bool>(false);
  double focusX = 0;
  double focusY = 0;

  Future<void> onZoom(double newScale) async {
    double scale = newScale;
    final double maxZoom =
        await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].getMaxZoomLevel();
    final double minZoom =
        await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].getMinZoomLevel();
    if (scale > maxZoom) {
      scale = maxZoom;
    } else if (scale < minZoom) {
      scale = minZoom;
    }
    await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].setZoomLevel(scale);
    }

  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            _baseScaleFactor = _scaleFactor;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            _scaleFactor = _baseScaleFactor * details.scale;
            onZoom(_scaleFactor);
          },
          child: GestureDetector(
            onTapUp: onTapSetFocus,
            child: Stack(
              children: <Widget>[
                CameraPreview(dataStore.cameraControllers[dataStore.selectedCameraIndex.value]),
                ValueListenableBuilder<bool>(
                  valueListenable: showFocusCircle,
                  builder:
                      (BuildContext context, bool value, Widget? child) {
                    if (value) {
                      return Positioned(
                        top: focusY - 20,
                        left: focusX - 20,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                            Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
