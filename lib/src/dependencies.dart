import 'package:get_it/get_it.dart';
import 'appwrite/appwrite.dart';
import 'themes/themes.dart';

void initDependencies() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => Appwrite());
  getIt.registerLazySingleton(() => AppThemes());
}
