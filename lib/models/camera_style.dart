import 'package:flutter/material.dart';

/// Camera style
class CameraStyle {
  /// Camera close icon
  final Widget cameraCloseIcon;

  /// Take picture icon
  final Widget takePictureIcon;

  /// Choose camera icon
  final Widget chooseCameraIcon;

  /// Camera back button
  final Widget cameraBackButton;

  /// Camera add media button
  final Widget cameraAddMediaButton;

  /// Camera delete media button
  final Widget cameraDeleteMediaButton;

  /// Camera selected media button
  final Widget cameraSelectedMediaButton;

  /// Video icon
  final Widget videoIcon;

  /// Flip camera icon
  final Widget flipCameraIcon;

  /// Finish button title
  final String finishButtonTitle;

  /// Finish button style
  final TextStyle finishButtonStyle;

  /// Finish button padding
  final EdgeInsets finishButtonPadding;

  /// Basic camera view border radius
  final double basicCameraViewBorderRadius;

  /// Basic camera crop container height
  final double basicCameraCropContainerHeight;

  /// Basic camera crop container border radius
  final double basicCameraCropContainerBorderRadius;

  /// Basic camera crop container border color
  final Color basicCameraCropContainerBorderColor;

  /// Basic camera flash icon
  final Widget basicCameraFlashIcon;

  /// Basic camera flash auto icon
  final Widget basicCameraFlashAutoIcon;

  /// Basic camera flash off icon
  final Widget basicCameraFlashOffIcon;

  /// Basic camera takePhoto button
  final Widget? basicCameraTakePhotoButton;

  /// Basic camera camera style
  final bool showBasicCamera;

  /// Camera style
  CameraStyle({
    this.cameraCloseIcon = const Icon(
      Icons.close,
      color: Colors.white,
    ),
    this.takePictureIcon = const Icon(
      Icons.camera,
      color: Colors.white,
    ),
    this.chooseCameraIcon = const Icon(
      Icons.camera_alt,
      color: Colors.white,
    ),
    this.cameraBackButton = const Icon(
      Icons.arrow_back_ios_new,
      color: Colors.white,
    ),
    this.cameraAddMediaButton = const Icon(
      Icons.add,
      color: Colors.white,
    ),
    this.cameraDeleteMediaButton = const Icon(
      Icons.delete,
      color: Colors.white,
    ),
    this.cameraSelectedMediaButton = const Icon(
      Icons.done,
      color: Colors.white,
    ),
    this.videoIcon = const Icon(
      Icons.video_call_rounded,
      color: Colors.white,
    ),
    this.flipCameraIcon = const Icon(
      Icons.flip_camera_ios,
      color: Colors.white,
    ),
    this.finishButtonTitle = 'Done',
    this.finishButtonStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
    ),
    this.finishButtonPadding = const EdgeInsets.only(bottom: 8.0),
    this.basicCameraViewBorderRadius = 34,
    this.basicCameraCropContainerHeight = 392,
    this.basicCameraCropContainerBorderRadius = 24,
    this.basicCameraCropContainerBorderColor = Colors.white,
    this.basicCameraFlashIcon = const Icon(Icons.flash_on, color: Colors.white),
    this.basicCameraFlashAutoIcon = const Icon(Icons.flash_auto, color: Colors.white),
    this.basicCameraFlashOffIcon = const Icon(Icons.flash_off, color: Colors.white),
    this.basicCameraTakePhotoButton,
    this.showBasicCamera = false,
  });
}
