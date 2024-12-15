
import 'package:get_it/get_it.dart';

import 'images_repository.dart';
import 'images_repository_impl.dart';

Future<void> injectDependencies() async {
  GetIt.I.registerLazySingleton<ImagesRepository>(
    () => ImagesRepositoryImpl(),
  );

}
