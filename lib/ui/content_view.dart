part of '../advanced_media_picker_impl.dart';

class ContentView extends StatelessWidget {
  const ContentView({
    super.key,
  });

  int getaditionPathItemCount(String pathId) {
    if (dataStore.totalEntitiesCount[pathId]! % 4 == 0) {
      return 2;
    } else {
      return 4 - (dataStore.totalEntitiesCount[pathId]! % 4) + 1;
    }
  }

  int isCameraNeedToShow() {
    return dataStore.isNeedToShowCamera ? 1 : 0;
  }

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
                  int newIndex = index;
                  if (index == 0 && dataStore.isNeedToShowCamera) {
                    return const CameraView();
                  }
                  if (dataStore.isNeedToShowCamera) {
                    newIndex = index - 1;
                  }
                  if (newIndex >= assetValue.length && !dataStore.hasMoreToLoad[pathValue.id]!) {
                    return const SizedBox.shrink();
                  }
                  if (newIndex == assetValue.length && dataStore.hasMoreToLoad[pathValue.id]!) {
                    assetsService.loadMoreAsset(path: pathValue);
                  }
                  if (newIndex < assetValue.length) {
                    final AssetEntity asset = assetValue[newIndex];

                    return AssetWidget(
                      key: ValueKey<int>(asset.hashCode),
                      asset: asset,
                    );
                  }
                  return const SizedBox.shrink();
                },
                childCount: assetValue.length + getaditionPathItemCount(pathValue.id),
              ),
              key: const ValueKey<String>('content'),
            );
          },
        );
      },
    );
  }
}
