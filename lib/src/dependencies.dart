import 'package:get_it/get_it.dart';
import 'appwrite/appwrite.dart';

void initDependencies() {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton(
      () => Appwrite());
}