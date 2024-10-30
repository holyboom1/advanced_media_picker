part of '../../advanced_media_picker_impl.dart';

class AssetsPickerBottomSheet extends StatefulWidget {
  final PickerController? controller;

  AssetsPickerBottomSheet({
    super.key,
    this.controller,
  });

  @override
  State<AssetsPickerBottomSheet> createState() => _AssetsPickerBottomSheetState();
}

class _AssetsPickerBottomSheetState extends State<AssetsPickerBottomSheet> {
  @override
  void initState() {
    super.initState();

    dataStore.pickerController.addListener(_onChanged);
  }

  bool isPopped = false;

  void _onChanged() {
    final double currentSize = dataStore.pickerController.size;

    if (dataStore.isNeedToShowAlert) {
      if (currentSize < 0.3 && dataStore.selectedAssets.value.isNotEmpty) {
        dataStore.pickerController.tryToHide();
      }
    }

    if (dataStore.pickerController.size <= 0.01 && !isPopped) {
      isPopped = true;
      Navigator.pop(context);
    }
  }

  DraggableScrollableSheet get sheet =>
      dataStore.pickerController.sheet.currentWidget! as DraggableScrollableSheet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DraggableScrollableSheet(
          shouldCloseOnMinExtent: false,
          key: dataStore.pickerController.sheet,
          maxChildSize: dataStore.pickerController.maxChildSize,
          minChildSize: dataStore.pickerController.minChildSize,
          initialChildSize: dataStore.pickerController.initialChildSize,
          snapSizes: <double>[
            60 / constraints.maxHeight,
            0.5,
            ...dataStore.pickerController.snap,
          ],
          controller: dataStore.pickerController,
          builder: (BuildContext context, ScrollController scrollController) {
            return Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: dataStore.style.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: dataStore.style.borderRadius.topLeft,
                    topRight: dataStore.style.borderRadius.topRight,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: dataStore.style.bottomPadding,
                      ),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: <Widget>[
                          SliverStickyHeader(
                            header: Container(
                              decoration: BoxDecoration(
                                color: dataStore.style.backgroundColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: dataStore.style.borderRadius.topLeft,
                                  topRight: dataStore.style.borderRadius.topRight,
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  if (dataStore.style.isNeedDragIndicator)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                            color: dataStore.style.dragIndicatorColor,
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  dataStore.style.titleWidget,
                                ],
                              ),
                            ),
                            sliver: SliverPadding(
                              padding: dataStore.style.mainPadding,
                              sliver: !dataStore.style.hasPermissionToGallery ||
                                      !dataStore.style.hasPermissionToCamera
                                  ? SliverToBoxAdapter(
                                      child: dataStore.style.cameraAndGalleryUnavailableContent)
                                  : const ContentView(
                                      isAssetsMediaPicker: true,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      child: CompleteWidget(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
