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

    if (dataStore.cameraController!.value.isInitialized) {
      focusX = details.localPosition.dx;
      focusY = details.localPosition.dy;

      final double fullWidth = MediaQuery.of(context).size.width;
      final double cameraHeight =
          fullWidth * dataStore.cameraController!.value.aspectRatio;

      final double xp = focusX / fullWidth;
      final double yp = focusY / cameraHeight;
      showFocusCircle.value = true;

      final Offset point = Offset(xp, yp);

      await dataStore.cameraController!.setFocusPoint(point);

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
    if (dataStore.cameraController != null) {
      final double maxZoom =
          await dataStore.cameraController!.getMaxZoomLevel();
      final double minZoom =
          await dataStore.cameraController!.getMinZoomLevel();
      if (scale > maxZoom) {
        scale = maxZoom;
      } else if (scale < minZoom) {
        scale = minZoom;
      }
      await dataStore.cameraController!.setZoomLevel(scale);
    }
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
          child: ValueListenableBuilder<bool>(
            valueListenable: dataStore.isCameraReady,
            builder: (BuildContext context, bool value, Widget? child) {
              if (!value) {
                return const CircularProgressIndicator.adaptive();
              }
              return GestureDetector(
                onTapUp: onTapSetFocus,
                child: Stack(
                  children: <Widget>[
                    CameraPreview(dataStore.cameraController!),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
