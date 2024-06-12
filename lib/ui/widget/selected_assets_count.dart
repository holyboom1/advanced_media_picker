import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';
import '../../models/asset_model.dart';

class SelectedAssetsCount extends StatelessWidget {
  final EdgeInsets padding;
  final Size size;

  const SelectedAssetsCount({
    super.key,
    this.padding = const EdgeInsets.only(right: 16, bottom: 16),
        this.size = const Size(35, 35),
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AssetModel>>(
      valueListenable: dataStore.selectedAssets,
      builder: (BuildContext context, List<AssetModel> value, Widget? child) {
        return GestureDetector(
          onTap: () {
            dataStore.isPreviewOpen.value = !dataStore.isPreviewOpen.value;
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: padding,
              child: Visibility(
                visible: dataStore.selectedAssets.value.isNotEmpty,
                child: Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: dataStore.isPreviewOpen,
                    builder: (BuildContext context, bool isPreviewOpen,
                        Widget? child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) =>
                                ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                        child: isPreviewOpen
                            ? const Icon(Icons.clear,
                                color: Colors.white, size: 20)
                            : Text(
                                dataStore.selectedAssets.value.length
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
