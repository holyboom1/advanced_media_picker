part of '../flutter_media_picker_impl.dart';

class ContentView extends StatelessWidget {
  final PickerStyle style;
  final CameraStyle cameraStyle;

  const ContentView({
    super.key,
    required this.style,
    required this.cameraStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AssetPathEntity?>(
      valueListenable: _selectedPath,
      key: const ValueKey<String>('content_view_selected_path'),
      builder: (BuildContext context, AssetPathEntity? pathValue, Widget? child) {
        if (pathValue == null) {
          return const SizedBox();
        }
        return ValueListenableBuilder<List<AssetEntity>>(
          valueListenable: pathData[pathValue.id]!,
          key: const ValueKey<String>('content_view_assets'),
          builder: (BuildContext context, List<AssetEntity> assetValue, Widget? child) {
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return CameraView(
                      key: const ValueKey<String>('camera'),
                      style: style,
                      cameraStyle: cameraStyle,
                    );
                  }
                  final AssetEntity asset = assetValue[index - 1];
                  if (index == assetValue.length - 1 && _hasMoreToLoad[pathValue.id]!) {
                    loadMoreAsset(path: pathValue);
                  }
                  return AssetWidget(
                    key: ValueKey<int>(asset.hashCode),
                    asset: asset,
                    theme: style,
                  );
                },
                childCount: assetValue.length + 1,
              ),
              key: const ValueKey<String>('content'),
            );
          },
        );
      },
    );
  }
}
