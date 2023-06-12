import 'package:appwrite_auth_kit/appwrite_auth_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:api_service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  ApiService.instance.init(
    endpoint: AppConstants.endpoint,
    projectId: AppConstants.projectId,
  );
  runApp(
    AppwriteAuthKit(
      client: ApiService.instance.client,
      child: const ProviderScope(
        child: App(),
      ),
    ),
  );
}
