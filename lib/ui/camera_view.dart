part of '../advanced_media_picker_impl.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    dataStore.cameras = await availableCameras();
    dataStore.cameraController = CameraController(
      dataStore.cameras.first,
      ResolutionPreset.medium,
    );
    await dataStore.cameraController?.initialize();
    await dataStore.cameraController?.setFocusMode(FocusMode.auto);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dataStore.cameraController == null) {
      return Container();
    }
    if (!dataStore.cameraController!.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
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
                child: const CameraScreen(),
              );
            },
            opaque: false,
            fullscreenDialog: true,
            barrierDismissible: true,
            pageBuilder: (_, __, ___) => const CameraScreen(),
          ),
        );
      },
      child: Container(
        decoration: dataStore.style.cameraContainerDecoration,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CameraPreview(dataStore.cameraController!),
            ),
            Positioned.fill(
              child: Center(
                child: dataStore.style.cameraIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
