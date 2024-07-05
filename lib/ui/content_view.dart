part of '../advanced_media_picker_impl.dart';

class ContentView extends StatelessWidget {
  const ContentView({
    super.key,
  });

  int getaditionPathItemCount(String pathId) {
    if (dataStore.totalEntitiesCount[pathId]! % 4 == 0) {
      return 1;
    } else {
      return 4 - (dataStore.totalEntitiesCount[pathId]! % 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AssetPathEntity?>(
      valueListenable: dataStore.selectedPath,
      key: const ValueKey<String>('content_view_selected_path'),
      builder:
          (BuildContext context, AssetPathEntity? pathValue, Widget? child) {
        if (pathValue == null) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }
        return ValueListenableBuilder<List<AssetEntity>>(
          valueListenable: dataStore.pathData[pathValue.id]!,
          key: const ValueKey<String>('content_view_assets'),
          builder: (BuildContext context, List<AssetEntity> assetValue,
              Widget? child) {
            return SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == 0) {
                    return CameraView();
                  }
                  if (index == assetValue.length + 1 &&
                      !dataStore.hasMoreToLoad[pathValue.id]!) {
                    if (index % 4 == 0) {
                      return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  }

                  if (index == assetValue.length - 1 &&
                      dataStore.hasMoreToLoad[pathValue.id]!) {
                    assetsService.loadMoreAsset(path: pathValue);
                  }

                  if (index - 1 < assetValue.length) {
                    final AssetEntity asset = assetValue[index - 1];

                    return AssetWidget(
                      key: ValueKey<int>(asset.hashCode),
                      asset: asset,
                    );
                  }

                  return const SizedBox.shrink();
                },
                childCount: assetValue.length +
                    1 +
                    getaditionPathItemCount(pathValue.id),
              ),
              key: const ValueKey<String>('content'),
            );
          },
        );
      },
    );
  }
}
