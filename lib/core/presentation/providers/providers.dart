import 'package:flutter_appwrite_starter/core/res/app_config.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:flutter_appwrite_starter/features/auth/data/model/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userRepoProvider = ChangeNotifierProvider<UserRepository>((ref) {
 return UserRepository.instance();
});
final configProvider = Provider<AppConfig>((ref) => AppConfig(
      appTitle: AppConstants.appName,
      buildFlavor: AppFlavor.prod,
    ));
