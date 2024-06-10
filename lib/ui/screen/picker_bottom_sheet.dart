part of '../../advanced_media_picker_impl.dart';

class PickerBottomSheet extends StatefulWidget {
  final PickerController? controller;

  const PickerBottomSheet({
    super.key,
    this.controller,
  });

  @override
  State<PickerBottomSheet> createState() => _PickerBottomSheetState();
}

class _PickerBottomSheetState extends State<PickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    dataStore.pickerController.addListener(_onChanged);
  }

  bool isNeedToShowDirectories = false;
  bool isPopped = false;

  void _onChanged() {
    final double currentSize = dataStore.pickerController.size;
    if (dataStore.pickerController.size > 0.7) {
      setState(() {
        isNeedToShowDirectories = true;
      });
    } else if (isNeedToShowDirectories) {
      setState(() {
        isNeedToShowDirectories = false;
      });
    }

    if (currentSize < 0.3 && dataStore.selectedAssets.value.isNotEmpty) {
      dataStore.pickerController.tryToHide();
    }

    if (dataStore.pickerController.size <= 0.01 && !isPopped) {
      isPopped = true;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    dataStore.pickerController.dispose();
  }

  DraggableScrollableSheet get sheet =>
      dataStore.pickerController.sheet.currentWidget!
          as DraggableScrollableSheet;

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
              child: DecoratedBox(
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
                              color: dataStore.style.backgroundColor,
                              child: Column(
                                children: <Widget>[
                                  if (dataStore.style.isNeedDragIndicator)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 40,
                                          height: 4,
                                          margin: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                            color: dataStore
                                                .style.dragIndicatorColor,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  AnimatedOpacity(
                                    duration: kThemeAnimationDuration,
                                    opacity: isNeedToShowDirectories ? 1 : 0,
                                    child: AnimatedSize(
                                      duration: kThemeAnimationDuration,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        height:
                                            isNeedToShowDirectories ? 100 : 0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:
                                              dataStore.style.backgroundColor,
                                          border: isNeedToShowDirectories
                                              ? Border(
                                                  bottom: BorderSide(
                                                    color: dataStore
                                                        .style.dividerColor,
                                                    width: 0.5,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          children:
                                              dataStore.availablePath.value.map(
                                            (AssetPathEntity e) {
                                              return DirectoryWidget(
                                                key: ValueKey<String>(e.id),
                                                path: e,
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            sliver: SliverPadding(
                              padding: dataStore.style.mainPadding,
                              sliver: const ContentView(),
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

Future<bool> showCloseAlertDialog({
  required CloseAlertStyle style,
  required BuildContext context,
}) async {
  bool isClose = false;
  await showDialog(
    barrierColor: Colors.black.withOpacity(0.4),
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: style.containerDecoration,
        padding: const EdgeInsets.only(top: 10, bottom: 6, left: 8, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              style.title,
              style: style.titleTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              style.message,
              style: style.messageTextStyle,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      style.negativeButtonText,
                      style: style.negativeButtonTextStyle,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((Route route) => route.isFirst);
                      isClose = true;
                    },
                    child: Text(
                      style.positiveButtonText,
                      style: style.positiveButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  return isClose;
}
