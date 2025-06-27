import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../advanced_media_picker.dart';
import '../../advanced_media_picker_impl.dart';
import '../../utils/extensions.dart';
import '../widget/blur_button_container.dart';
import '../widget/crop_container_border.dart';

/// Camera screen with basic functionality
class BasicCameraScreen extends StatefulWidget {
  const BasicCameraScreen({super.key});

  @override
  State<BasicCameraScreen> createState() => _BasicCameraScreenState();
}

class _BasicCameraScreenState extends State<BasicCameraScreen> {
  late CameraState cameraState;
  FlashMode currentFlashMode = FlashMode.none;
  bool takePhotoFromFrontCamera = false;
  bool showFlashEffect = false;
  bool previousSensorPositionWasBack = false;
  bool isPopped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!ModalRoute.of(context)!.isCurrent && !isPopped) {
      isPopped = true;
      final ModalRoute<Object?>? currentRoute = ModalRoute.of(context);
      Future<void>.delayed(const Duration(milliseconds: 1000), () {
        if (currentRoute != null) {
          Navigator.removeRoute(context, currentRoute);
        }
      });
    }
  }

  @override
  void dispose() {
    CamerawesomePlugin.stop();
    super.dispose();
  }

  /// Toggle flash mode and set
  Future<void> toggleFlashMode() async {
    try {
      if (currentFlashMode == FlashMode.none &&
          cameraState.sensorConfig.sensors.first.position != SensorPosition.front) {
        await cameraState.sensorConfig.setFlashMode(FlashMode.on);
        currentFlashMode = FlashMode.on;
      } else if (currentFlashMode == FlashMode.on) {
        await cameraState.sensorConfig.setFlashMode(FlashMode.auto);
        currentFlashMode = FlashMode.auto;
      } else {
        await cameraState.sensorConfig.setFlashMode(FlashMode.none);
        currentFlashMode = FlashMode.none;
      }
    } on PlatformException catch (e) {
      if (e.message == "can't set flash for portrait mode") {
        if (currentFlashMode == FlashMode.none) {
          currentFlashMode = FlashMode.on;
          showFlashEffect = true;
        } else if (currentFlashMode == FlashMode.on) {
          currentFlashMode = FlashMode.auto;
          showFlashEffect = false;
        } else {
          currentFlashMode = FlashMode.none;
          showFlashEffect = false;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: SafeArea(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(dataStore.cameraStyle.basicCameraViewBorderRadius),
                child: isPopped
                    ? const SizedBox.shrink()
                    : CameraAwesomeBuilder.custom(
                        sensorConfig:
                            SensorConfig.single(sensor: Sensor.position(SensorPosition.front)),
                        onMediaCaptureEvent: (MediaCapture event) {
                          event.captureRequest.when(
                            single: (SingleCaptureRequest single) async {
                              takePhotoFromFrontCamera =
                                  cameraState.sensorConfig.sensors.first.position ==
                                      SensorPosition.front;

                              if (single.file != null) {
                                dataStore.selectedAssets.value.clear();
                                dataStore.selectedAssets
                                    .addAsset(AssetModel.fromXFile(single.file!));

                                if (event.status == MediaCaptureStatus.success) {
                                  await assetsService.onTakePhoto(
                                      needMirrorPhoto: takePhotoFromFrontCamera);
                                }
                              }
                            },
                            multiple: (MultipleCaptureRequest multiple) {
                              multiple.fileBySensor.forEach((Sensor key, XFile? value) {
                                if (value != null) {
                                  dataStore.selectedAssets.addAsset(AssetModel.fromXFile(value));
                                }
                              });
                            },
                          );
                        },
                        saveConfig: SaveConfig.photo(
                          exifPreferences: ExifPreferences(saveGPSLocation: false),
                        ),
                        builder: (CameraState state, AnalysisPreview preview) {
                          cameraState = state;
                          return Stack(
                            children: <Widget>[
                              OverlayWithRectangleClipping(),
                              const CropContainerBorder(),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    isPopped = true;
                                    Navigator.of(context).pop();
                                  },
                                  child: BlurButtonContainer(
                                    child: dataStore.cameraStyle.cameraCloseIcon,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Row(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: toggleFlashMode,
                                      child: BlurButtonContainer(
                                        child: getFlashIcon(currentFlashMode),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    AwesomeCameraSwitchButton(
                                      onSwitchTap: (CameraState state) async {
                                        if (previousSensorPositionWasBack) {
                                          await state.sensorConfig.setFlashMode(FlashMode.none);
                                          currentFlashMode = FlashMode.none;
                                        }
                                        previousSensorPositionWasBack =
                                            !previousSensorPositionWasBack;
                                        await state.switchCameraSensor();
                                        if (state.sensorConfig.sensors.first.position ==
                                            SensorPosition.back) {
                                          await state.sensorConfig.setFlashMode(FlashMode.none);
                                          currentFlashMode = FlashMode.none;
                                        }
                                      },
                                      state: state,
                                      iconBuilder: () {
                                        return BlurButtonContainer(
                                          child: dataStore.cameraStyle.flipCameraIcon,
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              if (state is PhotoCameraState)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (cameraState.sensorConfig.sensors.first.position ==
                                            SensorPosition.front) {
                                          if (currentFlashMode != FlashMode.none) {
                                            setState(() {
                                              takePhotoFromFrontCamera = true;
                                              showFlashEffect = true;
                                            });
                                            await Future<void>.delayed(const Duration(seconds: 1));
                                          }
                                        }
                                        await state.takePhoto();
                                        state.dispose();
                                        setState(() {
                                          showFlashEffect = false;
                                        });
                                      },
                                      child: dataStore.cameraStyle.basicCameraTakePhotoButton ??
                                          Container(
                                            width: 72,
                                            height: 72,
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFFE64036),
                                                  Color(0xFFFF8C01),
                                                ],
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black,
                                              ),
                                              child: Container(
                                                width: 58,
                                                height: 58,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ),
          if (showFlashEffect && takePhotoFromFrontCamera)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Align(
              child: Text(
                'PHOTO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFlashIcon(FlashMode mode) {
    switch (mode) {
      case FlashMode.auto:
        return dataStore.cameraStyle.basicCameraFlashAutoIcon;
      case FlashMode.on:
        return dataStore.cameraStyle.basicCameraFlashIcon;
      case FlashMode.none:
      default:
        return dataStore.cameraStyle.basicCameraFlashOffIcon;
    }
  }
}

class OverlayWithRectangleClipping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _getCustomPaintOverlay(context));
  }

  CustomPaint _getCustomPaintOverlay(BuildContext context) {
    return CustomPaint(size: MediaQuery.of(context).size, painter: RectanglePainter());
  }
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black.withOpacity(0.4);
    const double topOffset = 80;
    const double rectangleHeight = 392;

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(0, topOffset, size.width, rectangleHeight),
              const Radius.circular(24),
            ),
          ),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
