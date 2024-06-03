import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../flutter_media_picker_impl.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  Future<void> onTapSetFocus(TapUpDetails details) async {
    showFocusCircle.value = false;

    if (cameraController!.value.isInitialized) {
      focusX = details.localPosition.dx;
      focusY = details.localPosition.dy;

      final double fullWidth = MediaQuery.of(context).size.width;
      final double cameraHeight = fullWidth * cameraController!.value.aspectRatio;

      final double xp = focusX / fullWidth;
      final double yp = focusY / cameraHeight;
      showFocusCircle.value = true;

      final Offset point = Offset(xp, yp);
      print("point : $point");

      await cameraController!.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      unawaited(Future<void>.delayed(const Duration(seconds: 2)).whenComplete(() {
        showFocusCircle.value = false;
      }));
    }
  }

  ValueNotifier<bool> showFocusCircle = ValueNotifier<bool>(false);
  double focusX = 0;
  double focusY = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: isCameraReady,
          builder: (BuildContext context, bool value, Widget? child) {
            if (!value) {
              return const CircularProgressIndicator.adaptive();
            }
            return GestureDetector(
              onTapUp: onTapSetFocus,
              child: Stack(
                children: <Widget>[
                  CameraPreview(cameraController!),
                  ValueListenableBuilder<bool>(
                    valueListenable: showFocusCircle,
                    builder: (BuildContext context, bool value, Widget? child) {
                      if (value) {
                        return Positioned(
                          top: focusY - 20,
                          left: focusX - 20,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
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
    );
  }
}
