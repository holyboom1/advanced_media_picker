import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../advanced_media_picker_impl.dart';

class FlashModeButton extends StatefulWidget {
  const FlashModeButton({super.key});

  @override
  State<FlashModeButton> createState() => _FlashModeButtonState();
}

class _FlashModeButtonState extends State<FlashModeButton> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isOpen ? 150 : 50,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: isOpen ? Colors.white.withOpacity(0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (isOpen) ...<Widget>[
              if (dataStore.flashModeNotifier.value != FlashMode.off)
                IconButton(
                  icon: const Icon(
                    Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    dataStore.flashModeNotifier.value = FlashMode.off;
                    isOpen = false;
                    setState(() {});
                  },
                ),
              if (dataStore.flashModeNotifier.value != FlashMode.torch)
                IconButton(
                  icon: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    dataStore.flashModeNotifier.value = FlashMode.torch;
                    isOpen = false;
                    setState(() {});
                  },
                ),
              if (dataStore.flashModeNotifier.value != FlashMode.auto)
                IconButton(
                  icon: const Icon(
                    Icons.flash_auto,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    dataStore.flashModeNotifier.value = FlashMode.auto;
                    isOpen = false;
                    setState(() {});
                  },
                ),
            ] else
              const SizedBox(),
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: dataStore.flashModeNotifier.value == FlashMode.off
                    ? const Icon(
                        Icons.flash_off,
                        color: Colors.white,
                      )
                    : dataStore.flashModeNotifier.value == FlashMode.torch
                        ? const Icon(
                            Icons.flash_on,
                            color: Colors.white,
                          )
                        : dataStore.flashModeNotifier.value == FlashMode.auto
                            ? const Icon(
                                Icons.flash_auto,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.flash_on_rounded,
                                color: Colors.white,
                              ),
              ),
              onPressed: () {
                isOpen = !isOpen;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
