part of '../../advanced_media_picker_impl.dart';

class AdvancedPickerBottomSheet extends StatefulWidget {
  final PickerController? controller;

  const AdvancedPickerBottomSheet({
    this.controller,
    super.key,
  });

  @override
  State<AdvancedPickerBottomSheet> createState() => _AdvancedPickerBottomSheetState();
}

class _AdvancedPickerBottomSheetState extends State<AdvancedPickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    dataStore.pickerController.addListener(_onChanged);
  }

  bool isPopped = false;

  void _onChanged() {
    if (dataStore.pickerController.size <= 0.01 && !isPopped) {
      isPopped = true;
      Navigator.pop(context);
    }
  }

  DraggableScrollableSheet get sheet =>
      dataStore.pickerController.sheet.currentWidget! as DraggableScrollableSheet;

  @override
  void dispose() {
    dataStore.pickerController.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const ValueKey<String>('picker_visibility'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0 && dataStore.pickerController.isAttached) {
          dataStore.pickerController.hide();
          isPopped = true;
          final ModalRoute<Object?>? currentRoute = ModalRoute.of(context);
          Future<void>.delayed(
            const Duration(milliseconds: 500),
            () {
              if (currentRoute != null) {
                Navigator.removeRoute(context, currentRoute);
              }
            },
          );
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return DraggableScrollableSheet(
            shouldCloseOnMinExtent: false,
            key: dataStore.pickerController.sheet,
            maxChildSize: dataStore.pickerController.maxChildSize,
            minChildSize: dataStore.pickerController.minChildSize,
            initialChildSize: dataStore.pickerController.maxChildSize,
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
                  child: Padding(
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
                                dataStore.style.titleWidget,
                              ],
                            ),
                          ),
                          sliver: SliverPadding(
                            padding: dataStore.style.mainPadding,
                            sliver: !dataStore.style.hasPermissionToCamera &&
                                    !dataStore.style.hasPermissionToGallery
                                ? SliverToBoxAdapter(
                                    child: dataStore.style.cameraAndGalleryUnavailableContent)
                                : const AdvancedContentView(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
