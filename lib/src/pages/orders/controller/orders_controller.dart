import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/orders/repository/orders_repository.dart';
import 'package:dartt_shop/src/pages/orders/result/orders_result.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:get/get.dart';

class AllOrdersController extends GetxController {
  final OrdersRepository ordersRepository;
  AllOrdersController(this.ordersRepository);

  List<OrderModel> allOrders = [];
  final authController = Get.find<AuthController>();
  final utilsServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
        token: authController.user.token!, userId: authController.user.token!);

    result.when(success: (orders) {
      allOrders = orders
        ..sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
      update();
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }
}
