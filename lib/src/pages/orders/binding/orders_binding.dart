import 'package:dartt_shop/src/pages/orders/controller/orders_controller.dart';
import 'package:dartt_shop/src/pages/orders/repository/orders_repository.dart';
import 'package:get/get.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersRepository>(
      () => OrdersRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.put(AllOrdersController(Get.find()));
  }
}
