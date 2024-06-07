import 'package:flutter/material.dart';

import '../../advanced_media_picker.dart';
import '../../advanced_media_picker_impl.dart';
import '../../models/asset_model.dart';
import 'type_selection_widget.dart';

class CompleteWidget extends StatelessWidget {
  const CompleteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AssetModel>>(
      valueListenable: dataStore.selectedAssets,
      builder: (BuildContext context, List<AssetModel> value, Widget? child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: value.isEmpty
              ? const TypeSelectionWidget()
              : dataStore.style.completeWidget ??
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: assetsService.onClose,
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
