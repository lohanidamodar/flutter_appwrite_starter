import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'app/app_config.dart';
import 'app/app_constants.dart';
import 'appwrite/appwrite.dart';
import 'auth_notifier/auth_notifier.dart';
import 'auth_notifier/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(GetIt.I.get<Appwrite>().account),
);

final configProvider = Provider<AppConfig>((ref) => AppConfig(
      appTitle: AppConstants.appName,
      buildFlavor: AppFlavor.prod,
    ));
