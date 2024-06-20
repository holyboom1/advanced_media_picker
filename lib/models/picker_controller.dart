import 'dart:async';

import 'package:flutter/material.dart';

import '../advanced_media_picker_impl.dart';

/// Picker controller
class PickerController extends DraggableScrollableController {
  /// Key of the sheet
  final GlobalKey<State<StatefulWidget>> sheet = GlobalKey();

  /// Initial child size
  final double initialChildSize;

  /// Minimum child size
  final double minChildSize;

  /// Maximum child size
  final double maxChildSize;

  /// Snap
  final List<double> snap;

  /// Constructor
  PickerController({
    this.initialChildSize = 0.5,
    this.minChildSize = 0,
    this.maxChildSize = 0.9,
    this.snap = const <double>[],
  });

  /// Animate sheet to a specific size
  Future<void> animateSheet(double size) async {
    await animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  bool _isAlertOpen = false;

  /// Try to hide the sheet if there are selected assets
  Future<void> tryToHide() async {
    if (dataStore.selectedAssets.value.isNotEmpty) {
      if (!_isAlertOpen) {
        _isAlertOpen = true;
        unawaited(animateSheet(0.3));
        final bool isClose = await dataStore.style.showCustomAlert?.call() ??
            await showCloseAlertDialog(
              style: dataStore.style.closeAlertStyle,
              context: sheet.currentContext!,
            );

        if (!isClose) {
          unawaited(animateSheet(initialChildSize));
        } else {}
        _isAlertOpen = false;
      }
    } else {
      await animateSheet(minChildSize);
    }
  }

  /// Hide the sheet
  Future<void> hide() async {
    await animateSheet(0);
  }
}
