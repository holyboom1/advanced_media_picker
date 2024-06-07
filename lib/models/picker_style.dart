import 'package:flutter/material.dart';

import 'close_alert_style.dart';

class PickerStyle {
  final BorderRadius borderRadius;
  final BorderRadius itemsBorderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color selectIconBackgroundColor;
  final Border selectIconBorder;
  final Widget selectIcon;

  final Widget cameraIcon;
  final bool isNeedDragIndicator;
  final Color dragIndicatorColor;
  final EdgeInsets mainPadding;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color dividerColor;
  final Alignment selectIconAlignment;

  final BoxDecoration selectedFolderDecoration;
  final BoxDecoration unselectedFolderDecoration;
  final BoxDecoration cameraContainerDecoration;
  final Color selectedFolderTextColor;
  final Color unselectedFolderTextColor;
  final CloseAlertStyle _closeAlertStyle;

  CloseAlertStyle get closeAlertStyle => _closeAlertStyle;

  /// A function that returns a boolean value from your custom alert dialog.
  final bool Function()? showCustomAlert;
  final Widget? completeWidget;
  final Widget? typeSelectionWidget;
  final double bottomPadding;

  PickerStyle({
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.selectIconBackgroundColor = Colors.white,
    this.selectIcon = const Icon(Icons.check, color: Colors.black),
    this.isNeedDragIndicator = true,
    this.selectIconBorder = const Border(),
    this.dragIndicatorColor = Colors.grey,
    this.mainPadding = const EdgeInsets.all(10),
    this.itemsBorderRadius = const BorderRadius.all(Radius.circular(10)),
    this.shimmerBaseColor = Colors.grey,
    this.shimmerHighlightColor = Colors.white,
    this.selectIconAlignment = Alignment.topRight,
    this.dividerColor = Colors.grey,
    this.selectedFolderTextColor = Colors.white,
    this.unselectedFolderTextColor = Colors.black,
    this.selectedFolderDecoration = const BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    this.unselectedFolderDecoration = const BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    this.cameraContainerDecoration = const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.all(Radius.circular(
        10,
      )),
    ),
    this.cameraIcon = const Icon(
      Icons.camera_alt,
      color: Colors.white,
    ),
    this.completeWidget,
    CloseAlertStyle? closeAlertStyle,
    this.showCustomAlert,
    this.typeSelectionWidget,
    this.bottomPadding = 0,
  }) : _closeAlertStyle = closeAlertStyle ??
            CloseAlertStyle(
              title: 'Close',
              message: 'Are you sure you want to close?',
              positiveButtonText: 'Yes',
              negativeButtonText: 'No',
            );
}
