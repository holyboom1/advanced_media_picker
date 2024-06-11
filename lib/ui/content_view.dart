part of '../advanced_media_picker_impl.dart';

class ContentView extends StatelessWidget {
  const ContentView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AssetPathEntity?>(
      valueListenable: dataStore.selectedPath,
      key: const ValueKey<String>('content_view_selected_path'),
      builder: (BuildContext context, AssetPathEntity? pathValue, Widget? child) {
        if (pathValue == null) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }
        return ValueListenableBuilder<List<AssetEntity>>(
          valueListenable: dataStore.pathData[pathValue.id]!,
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
                    return  CameraView();
                  }
                  final AssetEntity asset = assetValue[index - 1];
                  if (index == assetValue.length - 1 && dataStore.hasMoreToLoad[pathValue.id]!) {
                    assetsService.loadMoreAsset(path: pathValue);
                  }
                  return AssetWidget(
                    key: ValueKey<int>(asset.hashCode),
                    asset: asset,
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
