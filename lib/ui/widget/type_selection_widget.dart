import 'package:flutter/material.dart';

import '../../advanced_media_picker.dart';

class TypeSelectionWidget extends StatelessWidget {
  const TypeSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return dataStore.style.typeSelectionWidget ??
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.image),
              ),
              const IconButton(
                onPressed: AdvancedMediaPicker.selectFilesFromDevice,
                icon: Icon(Icons.file_copy),
              )
            ],
          ),
        );
  }
}
