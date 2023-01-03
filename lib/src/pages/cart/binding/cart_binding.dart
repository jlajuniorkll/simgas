import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/cart/repository/cart_repository.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartRepository>(
      () => CartRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.put(CartController(Get.find()));
  }
}
