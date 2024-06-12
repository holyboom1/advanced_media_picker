// import 'dart:async';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// import '../../advanced_media_picker_impl.dart';
//
// /// Camera preview widget
// class CameraPreviewWidget extends StatefulWidget {
//   /// Constructor
//   const CameraPreviewWidget({super.key});
//
//   @override
//   State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
// }
//
// class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
//   Future<void> onTapSetFocus(TapUpDetails details) async {
//     showFocusCircle.value = false;
//
//     if (dataStore.cameraControllers[dataStore.selectedCameraIndex.value].value.isInitialized) {
//       focusX = details.localPosition.dx;
//       focusY = details.localPosition.dy;
//
//       final double fullWidth = MediaQuery.of(context).size.width;
//       final double cameraHeight =
//           fullWidth * dataStore.cameraControllers[dataStore.selectedCameraIndex.value].value.aspectRatio;
//
//       final double xp = focusX / fullWidth;
//       final double yp = focusY / cameraHeight;
//       showFocusCircle.value = true;
//
//       final Offset point = Offset(xp, yp);
//
//       await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].setFocusPoint(point);
//
//       unawaited(
//           Future<void>.delayed(const Duration(seconds: 2)).whenComplete(() {
//         showFocusCircle.value = false;
//       }));
//     }
//   }
//
//   ValueNotifier<bool> showFocusCircle = ValueNotifier<bool>(false);
//   double focusX = 0;
//   double focusY = 0;
//
//   Future<void> onZoom(double newScale) async {
//     double scale = newScale;
//     final double maxZoom =
//         await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].getMaxZoomLevel();
//     final double minZoom =
//         await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].getMinZoomLevel();
//     if (scale > maxZoom) {
//       scale = maxZoom;
//     } else if (scale < minZoom) {
//       scale = minZoom;
//     }
//     await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].setZoomLevel(scale);
//     }
//
//   double _scaleFactor = 1.0;
//   double _baseScaleFactor = 1.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned.fill(
//       child: Center(
//         child: GestureDetector(
//           onScaleStart: (ScaleStartDetails details) {
//             _baseScaleFactor = _scaleFactor;
//           },
//           onScaleUpdate: (ScaleUpdateDetails details) {
//             _scaleFactor = _baseScaleFactor * details.scale;
//             onZoom(_scaleFactor);
//           },
//           child: GestureDetector(
//             onTapUp: onTapSetFocus,
//             child: Stack(
//               children: <Widget>[
//                 CameraPreview(dataStore.cameraControllers[dataStore.selectedCameraIndex.value]),
//                 ValueListenableBuilder<bool>(
//                   valueListenable: showFocusCircle,
//                   builder:
//                       (BuildContext context, bool value, Widget? child) {
//                     if (value) {
//                       return Positioned(
//                         top: focusY - 20,
//                         left: focusX - 20,
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border:
//                             Border.all(color: Colors.white, width: 1.5),
//                           ),
//                         ),
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';
import '../../models/asset_model.dart';
import '../../utils/extensions.dart';
import '../widget/selected_assets_count.dart';

/// Camera preview widget
class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          CameraAwesomeBuilder.awesome(
            onMediaCaptureEvent: (MediaCapture event) {
              switch ((event.status, event.isPicture, event.isVideo)) {
                case (MediaCaptureStatus.capturing, true, false):
                  debugPrint('Capturing picture...');
                case (MediaCaptureStatus.success, true, false):
                  event.captureRequest.when(
                    single: (SingleCaptureRequest single) {
                      if (single.file != null) {
                        dataStore.selectedAssets.addAsset(AssetModel.fromXFile(single.file!));
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
                case (MediaCaptureStatus.failure, true, false):
                  debugPrint('Failed to capture picture: ${event.exception}');
                case (MediaCaptureStatus.capturing, false, true):
                  debugPrint('Capturing video...');
                case (MediaCaptureStatus.success, false, true):
                  event.captureRequest.when(
                    single: (SingleCaptureRequest single) {
                      if (single.file != null) {
                        dataStore.selectedAssets.addAsset(AssetModel.fromXFile(single.file!));
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
                case (MediaCaptureStatus.failure, false, true):
                  debugPrint('Failed to capture video: ${event.exception}');
                default:
                  debugPrint('Unknown event: $event');
              }
            },
            saveConfig: SaveConfig.photoAndVideo(
              exifPreferences: ExifPreferences(saveGPSLocation: false),
              videoOptions: VideoOptions(
                quality: VideoRecordingQuality.fhd,
                enableAudio: true,
              ),
            ),
            topActionsBuilder: (CameraState state) {
              return AwesomeTopActions(
                state: state,
                children: (state is VideoRecordingCameraState
                    ? <Widget>[const SizedBox.shrink()]
                    : <Widget>[
                        AwesomeFlashButton(state: state),
                        if (state is PhotoCameraState) AwesomeAspectRatioButton(state: state),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: AwesomeCircleWidget(
                            child: Center(
                              child: SizedBox(
                                child: FittedBox(
                                  child: Builder(
                                    builder: (BuildContext context) => const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
              );
            },
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
            ),
            bottomActionsBuilder: (CameraState state) {
              return AwesomeBottomActions(
                state: state,
                right: const SelectedAssetsCount(
                  size: Size(70, 70),
                  padding: EdgeInsets.only(right: 48),
                ),
              );
            },
            enablePhysicalButton: true,
            previewFit: CameraPreviewFit.contain,
            availableFilters: awesomePresetFiltersList,
          ),
          const MediaPreviewList(),
          // CameraPreview(dataStore.cameraControllers[dataStore.selectedCameraIndex.value]),
        ],
      ),
    );
  }
}
