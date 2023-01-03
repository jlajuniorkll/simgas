import 'package:dartt_shop/src/pages/home/controller/home_controller.dart';
import 'package:dartt_shop/src/pages/home/repository/home_repository.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.put(HomeController(Get.find()));
  }
}
