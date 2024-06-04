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
  bool _isAlertOpen = false;
  final double _initialChildSize = 0.6;

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

    if (currentSize < 0.3 && _selectedAssets.value.isNotEmpty) {
      _hide();
    }

    if (_controller.size <= 0.01 && !isPopped) {
      isPopped = true;
      Navigator.pop(context);
    }
  }

  Future<void> _hide() async {
    if (_selectedAssets.value.isNotEmpty) {
      if (!_isAlertOpen) {
        _isAlertOpen = true;
        _animateSheet(0.3);
        await _showAlertDialog();
        _isAlertOpen = false;
      }
    } else {
      await _animateSheet(sheet.minChildSize);
    }
  }

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _showAlertDialog() async {
    await showDialog(
      barrierColor: Colors.black.withOpacity(0.4),
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.only(top: 10, bottom: 6, left: 8, right: 8),
          child: Column(
            children: <Widget>[
              Text(
                'Сancel selection?',
                style: TextStyle(
                  color: widget.style.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
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
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((Route route) => route.isFirst);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
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
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet => _sheet.currentWidget! as DraggableScrollableSheet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DraggableScrollableSheet(
          shouldCloseOnMinExtent: false,
          key: _sheet,
          maxChildSize: 0.9,
          minChildSize: 0,
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
