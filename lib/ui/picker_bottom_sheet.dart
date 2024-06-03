part of '../advanced_media_picker_impl.dart';

class PickerBottomSheet extends StatefulWidget {
  final PickerStyle style;
  final CameraStyle cameraStyle;

  const PickerBottomSheet({
    super.key,
    required this.style,
    required this.cameraStyle,
  });

  @override
  State<PickerBottomSheet> createState() => _PickerBottomSheetState();
}

class _PickerBottomSheetState extends State<PickerBottomSheet> {
  final GlobalKey<State<StatefulWidget>> _sheet = GlobalKey();
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  bool isNeedToShowDirectories = false;

  bool isPopped = false;

  void _onChanged() {
    final double currentSize = _controller.size;
    if (_controller.size > 0.7) {
      setState(() {
        isNeedToShowDirectories = true;
      });
    } else if (isNeedToShowDirectories) {
      setState(() {
        isNeedToShowDirectories = false;
      });
    }
    if (currentSize <= 0.2) {
      _hide();
    }
    if (_controller.size <= 0.01 && !isPopped) {
      isPopped = true;
      Navigator.pop(context);
    }
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  Future<void> _hide() async {
    await _animateSheet(sheet.minChildSize);
  }

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet => (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DraggableScrollableSheet(
          key: _sheet,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          minChildSize: 0,
          expand: true,
          snapSizes: <double>[
            60 / constraints.maxHeight,
            0.5,
          ],
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return Material(
              color: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.style.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: widget.style.borderRadius.topLeft,
                    topRight: widget.style.borderRadius.topRight,
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    SliverStickyHeader(
                      header: Container(
                        color: widget.style.backgroundColor,
                        child: Column(
                          children: <Widget>[
                            if (widget.style.isNeedDragIndicator)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                      color: widget.style.dragIndicatorColor,
                                      borderRadius: BorderRadius.circular(2),
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
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  height: isNeedToShowDirectories ? 100 : 0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: widget.style.backgroundColor,
                                    border: isNeedToShowDirectories
                                        ? Border(
                                            bottom: BorderSide(
                                              color: widget.style.dividerColor,
                                              width: 0.5,
                                            ),
                                          )
                                        : null,
                                  ),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.horizontal,
                                    children: _availablePath.value.map(
                                      (AssetPathEntity e) {
                                        return DirectoryWidget(
                                          key: ValueKey<String>(e.id),
                                          path: e,
                                          theme: widget.style,
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
                        padding: widget.style.mainPadding,
                        sliver: ContentView(
                          style: widget.style,
                          cameraStyle: widget.cameraStyle,
                        ),
                      ),
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
