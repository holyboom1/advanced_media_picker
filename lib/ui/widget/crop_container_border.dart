import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';

class CropContainerBorder extends StatelessWidget {
  const CropContainerBorder({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 80),
          height: dataStore.cameraStyle.basicCameraCropContainerHeight,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(dataStore.cameraStyle.basicCameraCropContainerBorderRadius),
              ),
              border: Border(
                bottom:
                    BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
                left: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
              ),
            ),
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight:
                    Radius.circular(dataStore.cameraStyle.basicCameraCropContainerBorderRadius),
              ),
              border: Border(
                bottom:
                    BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
                right: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
              ),
            ),
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
        Positioned(
          top: 80,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(dataStore.cameraStyle.basicCameraCropContainerBorderRadius),
              ),
              border: Border(
                top: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
                left: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
              ),
            ),
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
        Positioned(
          top: 80,
          right: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight:
                    Radius.circular(dataStore.cameraStyle.basicCameraCropContainerBorderRadius),
              ),
              border: Border(
                top: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
                right: BorderSide(color: dataStore.cameraStyle.basicCameraCropContainerBorderColor),
              ),
            ),
            child: const SizedBox(
              width: 100,
              height: 100,
            ),
          ),
        ),
      ],
    );
  }
}
