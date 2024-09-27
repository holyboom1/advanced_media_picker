part of '../advanced_media_picker_impl.dart';

class CameraView extends StatelessWidget {
  final double? height;

  const CameraView({
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: dataStore.isPreviewCameraReady,
      builder: (BuildContext context, bool value, Widget? child) {
        return GestureDetector(
          onTap: value
              ? () {
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
                }
              : () => dataStore.onCameraPermissionDeniedCallback(),
          child: Container(
            height: height,
            decoration: dataStore.style.cameraContainerDecoration,
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: !value ? Container() : CameraPreview(dataStore.cameraController),
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
      },
    );
  }
}
