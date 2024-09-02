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
              if (dataStore.selectedAssets.value.length >=
                  dataStore.limitToSelection) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return MediaScreen(
                        filePath: dataStore.selectedAssets.value.last.file.path,
                        isMediaFromPreview: true,
                      );
                    },
                  ),
                );
                return;
              }
              switch ((event.status, event.isPicture, event.isVideo)) {
                case (MediaCaptureStatus.capturing, true, false):
                  debugPrint('Capturing picture...');
                case (MediaCaptureStatus.success, true, false):
                  event.captureRequest.when(
                    single: (SingleCaptureRequest single) {
                      if (single.file != null) {
                        dataStore.selectedAssets
                            .addAsset(AssetModel.fromXFile(single.file!));
                      }
                    },
                    multiple: (MultipleCaptureRequest multiple) {
                      multiple.fileBySensor.forEach((Sensor key, XFile? value) {
                        if (value != null) {
                          dataStore.selectedAssets
                              .addAsset(AssetModel.fromXFile(value));
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
                        dataStore.selectedAssets
                            .addAsset(AssetModel.fromXFile(single.file!));
                      }
                    },
                    multiple: (MultipleCaptureRequest multiple) {
                      multiple.fileBySensor.forEach((Sensor key, XFile? value) {
                        if (value != null) {
                          dataStore.selectedAssets
                              .addAsset(AssetModel.fromXFile(value));
                        }
                      });
                    },
                  );
                case (MediaCaptureStatus.failure, false, true):
                  debugPrint('Failed to capture video: ${event.exception}');
                default:
                  debugPrint('Unknown event: $event');
              }

              if (dataStore.selectedAssets.value.length >=
                  dataStore.limitToSelection) {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return MediaScreen(
                        filePath: dataStore.selectedAssets.value.last.file.path,
                        isMediaFromPreview: true,
                      );
                    },
                  ),
                );
              }
            },
            saveConfig: (dataStore.isNeedToTakeVideo)
                ? SaveConfig.photoAndVideo(
                    exifPreferences: ExifPreferences(saveGPSLocation: false),
                    videoOptions: VideoOptions(
                      quality: VideoRecordingQuality.fhd,
                      enableAudio: true,
                    ),
                  )
                : SaveConfig.photo(
                    exifPreferences: ExifPreferences(saveGPSLocation: false),
                  ),
            topActionsBuilder: (CameraState state) {
              return AwesomeTopActions(
                state: state,
                children: (state is VideoRecordingCameraState
                    ? <Widget>[const SizedBox.shrink()]
                    : <Widget>[
                        AwesomeFlashButton(state: state),
                        if (state is PhotoCameraState)
                          AwesomeAspectRatioButton(state: state),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: AwesomeCircleWidget(
                            child: Center(
                              child: SizedBox(
                                child: FittedBox(
                                  child: Builder(
                                    builder: (BuildContext context) =>
                                        const Icon(
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
