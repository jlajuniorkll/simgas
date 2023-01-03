import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/pages/orders/result/orders_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';

abstract class OrdersRepository {
  Future<OrdersResult<List<OrderModel>>> getAllOrders(
      {required String token, required String userId});
  Future<OrdersResult<List<CartItemModel>>> getOrderItems(
      {required String token, required String orderId});
}

class OrdersRepositoryImpl implements OrdersRepository {
  final HttpManager _httpManager;

  OrdersRepositoryImpl(this._httpManager);

  @override
  Future<OrdersResult<List<OrderModel>>> getAllOrders(
      {required String token, required String userId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllOrders,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'user': userId
        });

    if (result['result'] != null) {
      List<OrderModel> orders =
          List<Map<String, dynamic>>.from(result['result'])
              .map(OrderModel.fromJson)
              .toList();
      return OrdersResult<List<OrderModel>>.success(orders);
    } else {
      return OrdersResult.error("Não foi possível recuperar os pedidos");
    }
  }

  @override
  Future<OrdersResult<List<CartItemModel>>> getOrderItems(
      {required String token, required String orderId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getOrderItems,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'orderId': orderId
        });

    if (result['result'] != null) {
      List<CartItemModel> items =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();
      return OrdersResult<List<CartItemModel>>.success(items);
    } else {
      return OrdersResult.error("Não foi possível recuperar os produtos");
    }
  }
}
