import 'dart:async';

import 'package:flutter/material.dart';

import '../advanced_media_picker.dart';
import '../advanced_media_picker_impl.dart';

class PickerController extends DraggableScrollableController {
  final GlobalKey<State<StatefulWidget>> sheet = GlobalKey();
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double> snap;

  PickerController({
    this.initialChildSize = 0.5,
    this.minChildSize = 0,
    this.maxChildSize = 0.9,
    this.snap = const <double>[],
  });

  Future<void> animateSheet(double size) async {
    await animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  bool _isAlertOpen = false;

  Future<void> tryToHide() async {
    if (dataStore.selectedAssets.value.isNotEmpty) {
      if (!_isAlertOpen) {
        _isAlertOpen = true;
        unawaited(animateSheet(0.3));
        final bool isClose = dataStore.style.showCustomAlert?.call() ??
            await showCloseAlertDialog(
              style: dataStore.style.closeAlertStyle,
              context: sheet.currentContext!,
            );
        if (!isClose) {
          unawaited(animateSheet(initialChildSize));
        }
        _isAlertOpen = false;
      }
    } else {
      await animateSheet(minChildSize);
    }
  }

  Future<void> hide() async {
    await animateSheet(0);
  }
}
