import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/auth/repository/auth_repository.dart';
import 'package:dartt_shop/src/services/http_manager.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HttpManager>(
      () => HttpManagerImpl(),
      fenix: true,
    );

    // injeção de dependência Getx
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.put(AuthController(Get.find()));
  }
}
