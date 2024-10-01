part of '../advanced_media_picker_impl.dart';

class AdvancedContentView extends StatefulWidget {
  const AdvancedContentView({super.key});

  @override
  State<AdvancedContentView> createState() => _AdvancedContentViewState();
}

class _AdvancedContentViewState extends State<AdvancedContentView> {
  final ScrollController scrollController = ScrollController();

  int getaditionPathItemCount(String pathId) {
    if (dataStore.totalEntitiesCount[pathId]! % 4 == 0) {
      return 2;
    } else {
      return 4 - (dataStore.totalEntitiesCount[pathId]! % 4) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: <Widget>[
        dataStore.style.hasPermissionToCamera
            ? SliverPadding(
                padding: dataStore.style.cameraPreviewPadding,
                sliver: const SliverToBoxAdapter(
                  child: CameraView(height: 180),
                ),
              )
            : SliverToBoxAdapter(child: dataStore.style.cameraUnavailableContent),
        ValueListenableBuilder<AssetPathEntity?>(
          valueListenable: dataStore.selectedPath,
          key: const ValueKey<String>('content_view_selected_path'),
          builder: (BuildContext context, AssetPathEntity? pathValue, Widget? child) {
            if (pathValue == null && dataStore.style.hasPermissionToGallery) {
              return const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              );
            }
            return dataStore.style.hasPermissionToGallery && pathValue != null
                ? ValueListenableBuilder<List<AssetEntity>>(
                    valueListenable: dataStore.pathData[pathValue.id]!,
                    key: const ValueKey<String>('content_view_assets'),
                    builder: (BuildContext context, List<AssetEntity> assetValue, Widget? child) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final int newIndex = index;
                              if (newIndex >= assetValue.length &&
                                  !dataStore.hasMoreToLoad[pathValue.id]!) {
                                return const SizedBox.shrink();
                              }
                              if (newIndex == assetValue.length &&
                                  dataStore.hasMoreToLoad[pathValue.id]!) {
                                assetsService.loadMoreAsset(path: pathValue);
                              }
                              if (newIndex < assetValue.length) {
                                final AssetEntity asset = assetValue[newIndex];

                                return AssetWidget(
                                  key: ValueKey<int>(asset.hashCode),
                                  asset: asset,
                                  isAdvancedMediaPicker: true,
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            childCount: assetValue.length + getaditionPathItemCount(pathValue.id),
                          ),
                          key: const ValueKey<String>('content'),
                        ),
                      );
                    },
                  )
                : SliverToBoxAdapter(child: dataStore.style.galleryUnavailableContent);
          },
        ),
      ],
    );
  }
}
