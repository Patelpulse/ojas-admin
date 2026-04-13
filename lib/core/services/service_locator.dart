import 'package:get_it/get_it.dart';
import 'package:ojas_admin/core/services/api_service.dart';
import 'package:ojas_admin/features/vendors/data/services/vendor_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => VendorService(sl()));
}
