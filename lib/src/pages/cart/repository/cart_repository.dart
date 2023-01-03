import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/pages/cart/result/cart_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';

abstract class CartRepository {
  Future<CartResult<List<CartItemModel>>> getCartItems(
      {required String token, required String userId});
  Future<CartResult<String>> addItemToCart(
      {required String userId,
      required String token,
      required String productId,
      required int quantity});
  Future<CartResult<OrderModel>> checkoutCart(
      {required String token, required double total});
  Future<bool> changeItemQuantity(
      {required String token,
      required String cartItemId,
      required int quantity});
}

class CartRepositoryImpl implements CartRepository {
  final HttpManager _httpManager;

  CartRepositoryImpl(this._httpManager);

  @override
  Future<CartResult<List<CartItemModel>>> getCartItems(
      {required String token, required String userId}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getCartItems,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'user': userId,
        });

    if (result['result'] != null) {
      List<CartItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();

      return CartResult<List<CartItemModel>>.success(data);
    } else {
      return CartResult<List<CartItemModel>>.error(
          "Ocorreu um erro ao recuperar os itens do carrinho");
    }
  }

  @override
  Future<CartResult<String>> addItemToCart(
      {required String userId,
      required String token,
      required String productId,
      required int quantity}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.addItemToCart,
        method: HttpMethods.post,
        body: {
          'user': userId,
          'quantity': quantity,
          'productId': productId,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });

    if (result['result'] != null) {
      return CartResult.success(result['result']['id']);
    } else {
      return CartResult.error("Não foi possível adicionar o item no carrinho!");
    }
  }

  @override
  Future<CartResult<OrderModel>> checkoutCart(
      {required String token, required double total}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.checkout,
      method: HttpMethods.post,
      body: {'total': total},
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      final order = OrderModel.fromJson(result['result']);
      return CartResult<OrderModel>.success(order);
    } else {
      return CartResult.error('Não foi possível finalizar o pedido');
    }
  }

  @override
  Future<bool> changeItemQuantity(
      {required String token,
      required String cartItemId,
      required int quantity}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changeItemQuantity,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'cartItemId': cartItemId,
          'quantity': quantity
        });

    return result.isEmpty;
  }
}
