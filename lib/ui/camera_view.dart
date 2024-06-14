part of '../advanced_media_picker_impl.dart';

class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                child: CameraScreen(),
              );
            },
            opaque: false,
            fullscreenDialog: true,
            barrierDismissible: true,
            pageBuilder: (_, __, ___) => CameraScreen(),
          ),
        );
      },
      child: Container(
        decoration: dataStore.style.cameraContainerDecoration,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ValueListenableBuilder<bool>(
                valueListenable: dataStore.isPreviewCameraReady,
                builder: (BuildContext context, bool value, Widget? child) {
                  if (!value) {
                    return Container();
                  }
                  return CameraPreview(dataStore.cameraController);
                },
              ),
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
