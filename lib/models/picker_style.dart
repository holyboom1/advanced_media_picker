import 'package:flutter/material.dart';

import 'close_alert_style.dart';

/// Picker style
class PickerStyle {
  /// Sheet Border radius
  final BorderRadius borderRadius;

  /// Items border radius
  final BorderRadius itemsBorderRadius;

  /// Background color
  final Color backgroundColor;

  /// Text color
  final Color textColor;

  /// Select icon background color
  final Color selectIconBackgroundColor;

  /// Select icon border
  final Border selectIconBorder;

  /// Select icon
  final Widget selectIcon;

  /// Camera icon
  final Widget cameraIcon;

  /// Is need drag indicator
  final bool isNeedDragIndicator;

  /// Drag indicator color
  final Color dragIndicatorColor;

  /// Main padding
  final EdgeInsets mainPadding;

  /// Shimmer base color
  final Color shimmerBaseColor;

  /// Shimmer highlight color
  final Color shimmerHighlightColor;

  /// Divider color
  final Color dividerColor;

  /// Select icon alignment
  final Alignment selectIconAlignment;

  /// Selected folder decoration
  final BoxDecoration selectedFolderDecoration;

  ///  Unselected folder decoration
  final BoxDecoration unselectedFolderDecoration;

  /// Camera container decoration
  final BoxDecoration cameraContainerDecoration;

  ///  Selected folder text color
  final Color selectedFolderTextColor;

  /// Unselected folder text color
  final Color unselectedFolderTextColor;

  /// Close alert style
  final CloseAlertStyle _closeAlertStyle;

  /// Close alert style
  CloseAlertStyle get closeAlertStyle => _closeAlertStyle;

  /// A function that returns a boolean value from your custom alert dialog.
  final bool Function()? showCustomAlert;

  /// Complete widget for the picker (shown at the bottom of the picker when the user has selected media)
  final Widget? completeWidget;

  /// Type selection widget for the picker (shown at the bottom of the picker when the user dont selected media)
  final Widget? typeSelectionWidget;

  /// Bottom padding
  final double bottomPadding;

  /// Folder divider
  final Widget folderDivider;

  /// Picker title widget
  final Widget titleWidget;

  /// Picker style
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
      color: Colors.white,
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
    this.folderDivider = const Divider(),
    this.titleWidget = const Text('Select media'),
  }) : _closeAlertStyle = closeAlertStyle ??
            CloseAlertStyle(
              title: 'Close',
              message: 'Are you sure you want to close?',
              positiveButtonText: 'Yes',
              negativeButtonText: 'No',
            );
}
