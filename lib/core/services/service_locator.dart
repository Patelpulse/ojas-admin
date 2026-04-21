import 'package:get_it/get_it.dart';
import 'package:ojas_admin/core/services/api_service.dart';
import 'package:ojas_admin/features/vendors/data/services/vendor_service.dart';
import 'package:ojas_admin/features/banners/data/services/banner_service.dart';
import 'package:ojas_admin/features/categories/data/services/category_service.dart';
import 'package:ojas_admin/features/users/data/services/user_service.dart';
import 'package:ojas_admin/core/services/product_service.dart';
import 'package:ojas_admin/features/auth/data/services/auth_service.dart';
import 'package:ojas_admin/features/subcategories/data/services/subcategory_service.dart';
import 'package:ojas_admin/features/dashboard/data/services/dashboard_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  if (!sl.isRegistered<ApiService>()) {
    sl.registerLazySingleton(() => ApiService());
  }
  
  if (!sl.isRegistered<AuthService>()) {
    sl.registerLazySingleton(() => AuthService(sl()));
  }

  if (!sl.isRegistered<VendorService>()) {
    sl.registerLazySingleton(() => VendorService(sl()));
  }
  
  if (!sl.isRegistered<UserService>()) {
    sl.registerLazySingleton(() => UserService(sl()));
  }
  
  if (!sl.isRegistered<BannerService>()) {
    sl.registerLazySingleton(() => BannerService(sl()));
  }
  
  if (!sl.isRegistered<CategoryService>()) {
    sl.registerLazySingleton(() => CategoryService());
  }

  if (!sl.isRegistered<SubcategoryService>()) {
    sl.registerLazySingleton(() => SubcategoryService());
  }

  if (!sl.isRegistered<ProductService>()) {
    sl.registerLazySingleton(() => ProductService(sl()));
  }

  if (!sl.isRegistered<DashboardService>()) {
    sl.registerLazySingleton(() => DashboardService(sl()));
  }
}
