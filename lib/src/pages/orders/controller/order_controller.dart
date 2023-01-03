import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/orders/repository/orders_repository.dart';
import 'package:dartt_shop/src/pages/orders/result/orders_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  OrderModel order;

  OrderController(this.order);

  final OrdersRepository orderRepository =
      OrdersRepositoryImpl(HttpManagerImpl());

  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOrderItems() async {
    setLoading(true);
    final OrdersResult<List<CartItemModel>> result = await orderRepository
        .getOrderItems(token: authController.user.token!, orderId: order.id);
    setLoading(false);
    result.when(success: (items) {
      order.items = items;
      update();
    }, error: (error) {
      utilsServices.showToast(message: error, isError: true);
    });
  }
}
