import 'package:flappwrite_account_kit/flappwrite_account_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_starter/app.dart';
import 'package:flutter_appwrite_starter/core/data/service/api_service.dart';
import 'package:flutter_appwrite_starter/core/res/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/presentation/providers/providers.dart';
import 'core/res/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topEnd,
        message: "dev",
        textDirection: TextDirection.ltr,
        child: FlAppwriteAccountKit(
          client: ApiService.instance.client,
          child: ProviderScope(
            child: App(),
            overrides: [
              configProvider.overrideWithProvider(Provider(
                (ref) => AppConfig(
                  appTitle: AppConstants.appNameDev,
                  buildFlavor: AppFlavor.dev,
                ),
              ))
            ],
          ),
        ),
      ),
    ),
  );
}
