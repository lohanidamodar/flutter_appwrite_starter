import 'package:flutter_appwrite_starter/src/app/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_constants.dart';

final configProvider = Provider<AppConfig>((ref) => AppConfig(
      appTitle: AppConstants.appName,
      buildFlavor: AppFlavor.prod,
    ));
