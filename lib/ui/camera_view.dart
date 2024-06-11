part of '../advanced_media_picker_impl.dart';

class CameraView extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    if (dataStore.cameraControllers.isEmpty) {
      return Container();
    }

    return ValueListenableBuilder(valueListenable: dataStore.cameraControllers.first, builder: (BuildContext context, CameraValue controller, Widget? child) {
      if (!controller.isInitialized) {
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
                child: CameraPreview(dataStore.cameraControllers.first),
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
    },);

  }
}
