import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';

import '../../advanced_media_picker.dart';
import '../../advanced_media_picker_impl.dart';
import '../../models/asset_model.dart';
import '../../utils/extensions.dart';
import '../widget/blur_button_container.dart';
import '../widget/crop_container_border.dart';

/// Camera screen with basic functionality
class BasicCameraScreen extends StatelessWidget {
  const BasicCameraScreen({super.key});

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
                child: CameraAwesomeBuilder.custom(
                  onMediaCaptureEvent: (MediaCapture event) {
                    event.captureRequest.when(
                      single: (SingleCaptureRequest single) {
                        if (single.file != null) {
                          dataStore.selectedAssets.value.clear();
                          dataStore.selectedAssets.addAsset(AssetModel.fromXFile(single.file!));
                        }
                      },
                      multiple: (MultipleCaptureRequest multiple) {
                        multiple.fileBySensor.forEach(
                          (Sensor key, XFile? value) {
                            if (value != null) {
                              dataStore.selectedAssets.addAsset(AssetModel.fromXFile(value));
                            }
                          },
                        );
                      },
                    );
                  },
                  saveConfig: SaveConfig.photo(
                    exifPreferences: ExifPreferences(saveGPSLocation: false),
                  ),
                  builder: (CameraState state, Preview preview) {
                    return Stack(
                      children: <Widget>[
                        OverlayWithRectangleClipping(),
                        const CropContainerBorder(),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: GestureDetector(
                            onTap: () {
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
                              AwesomeFlashButton(
                                state: state,
                                iconBuilder: (FlashMode mode) {
                                  switch (mode) {
                                    case FlashMode.auto:
                                      return BlurButtonContainer(
                                        child: dataStore.cameraStyle.basicCameraFlashAutoIcon,
                                      );
                                    case FlashMode.always:
                                      return BlurButtonContainer(
                                        child: dataStore.cameraStyle.basicCameraFlashIcon,
                                      );
                                    case FlashMode.none:
                                      return BlurButtonContainer(
                                        child: dataStore.cameraStyle.basicCameraFlashOffIcon,
                                      );
                                    default:
                                      return BlurButtonContainer(
                                        child: dataStore.cameraStyle.basicCameraFlashOffIcon,
                                      );
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              AwesomeCameraSwitchButton(
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
                                  await state.takePhoto();
                                  await assetsService.onTakePhoto();
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
