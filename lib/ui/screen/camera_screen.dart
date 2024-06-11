part of '../../advanced_media_picker_impl.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    super.key,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Future<void> navigateToMediaScreen(String filePath, [bool? isLimitReached]) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MediaScreen(
          filePath: filePath,
          isLimitReached: isLimitReached ?? false,
        ),
      ),
    );
  }

  Future<void> takePicture() async {
    if (dataStore.limitToSelection != -1 &&
        dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      return;
    }
    final XFile file;
    if (!dataStore.isRecording.value) {
      file = await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].takePicture();
    } else {
      file = await dataStore.cameraControllers[dataStore.selectedCameraIndex.value]
          .stopVideoRecording();
      dataStore.isRecording.value = false;
    }
    dataStore.selectedAssets.addAsset(AssetModel.fromXFile(file));
    if (dataStore.selectedAssets.value.length == 1) {
      await navigateToMediaScreen(file.path);
    }

    if (dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      await navigateToMediaScreen(file.path, true);
    }
  }

  Future<void> takeVideo() async {
    if (dataStore.limitToSelection != -1 &&
        dataStore.selectedAssets.value.length >= dataStore.limitToSelection) {
      return;
    }
    if (dataStore.isRecording.value) {
      final XFile file = await dataStore.cameraControllers[dataStore.selectedCameraIndex.value]
          .stopVideoRecording();
      dataStore.isRecording.value = false;
      dataStore.selectedAssets.addAsset(AssetModel.fromXFile(file));
    } else {
      dataStore.isRecording.value = true;
      await dataStore.cameraControllers[dataStore.selectedCameraIndex.value]
          .prepareForVideoRecording();
      await dataStore.cameraControllers[dataStore.selectedCameraIndex.value].startVideoRecording();
    }
  }

  void flipCamera() {
    if (dataStore
            .cameraControllers[dataStore.selectedCameraIndex.value].description.lensDirection ==
        CameraLensDirection.front) {
      final CameraDescription backCamera = dataStore.cameras.firstWhere(
        (CameraDescription element) {
          return element.lensDirection == CameraLensDirection.back;
        },
      );
      final int index = dataStore.cameras.indexOf(backCamera);
      dataStore.selectedCameraIndex.value = index;
    } else {
      final CameraDescription backCamera = dataStore.cameras.firstWhere(
        (CameraDescription element) {
          return element.lensDirection == CameraLensDirection.front;
        },
      );
      final int index = dataStore.cameras.indexOf(backCamera);
      dataStore.selectedCameraIndex.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          const CameraPreviewWidget(),
          const MediaPreviewList(),
          ValueListenableBuilder<int>(
            valueListenable: dataStore.selectedCameraIndex,
            builder: (BuildContext context, int value, Widget? child) {
              if (dataStore.cameraControllers[value].description.lensDirection !=
                      CameraLensDirection.front &&
                  dataStore.cameras.length > 2) {
                const SelectCameraLens();
              }
              return const SizedBox();
            },
          ),
          const SelectedAssetsCount(),
          Positioned(
            bottom: 42,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const FlashModeButton(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: dataStore.isRecording,
                    builder: (_, bool isRecordingValue, __) {
                      return GestureDetector(
                        onTap: takePicture,
                        onLongPress: takeVideo,
                        child: Icon(
                          isRecordingValue ? Icons.stop : Icons.fiber_manual_record,
                          color: isRecordingValue ? Colors.red : Colors.white,
                          size: 90,
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: dataStore.cameraStyle.flipCameraIcon,
                  onPressed: flipCamera,
                ),
              ],
            ),
          ),
          Positioned(
            top: 42,
            right: 22,
            child: IconButton(
              icon: dataStore.cameraStyle.cameraCloseIcon,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
