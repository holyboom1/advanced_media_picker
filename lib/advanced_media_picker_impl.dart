import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import 'advanced_media_picker.dart';
import 'models/asset_model.dart';
import 'ui/camera/camera_screen.dart';
import 'ui/media/media_preview.dart';
import 'ui/widget/complete_widget.dart';
import 'ui/widget/selected_assets_count.dart';
import 'ui/widget/shimmer.dart';
import 'utils/extensions.dart';
import 'utils/video_file_formatter.dart';

part 'models/assets_type.dart';
part 'ui/camera_view.dart';
part 'ui/content_view.dart';
part 'ui/media/media_preview_list.dart';
part 'ui/screen/media_screen.dart';
part 'ui/screen/picker_bottom_sheet.dart';
part 'ui/widget/asset_widget.dart';
part 'ui/widget/directory_widget.dart';
part 'utils/assets_service.dart';
part 'utils/data_store.dart';

/// plugin data store
late DataStore dataStore;

/// plugin assets service
late AssetsService assetsService;
