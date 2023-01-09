import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/models/pagamento_model.dart';
import 'package:dartt_shop/src/models/user_model.dart';
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
  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
    required UserModel cliente,
    required List<CartItemModelHiper> items,
    required List<MeiosPagamentoModel> meiosPagamento,
  });
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
  Future<CartResult<OrderModel>> checkoutCart({
    required String token,
    required double total,
    required UserModel cliente,
    required List<CartItemModelHiper> items,
    required List<MeiosPagamentoModel> meiosPagamento,
  }) async {
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
      cliente.endereco = EnderecoModel(
          cep: "95088530",
          logradouro: "Rua Giovani Batastini",
          numero: "1115",
          bairro: "São Victor Cohab",
          codigoIBGE: "4305108");
      cliente.entrega = cliente.endereco;
      await postPedidoDeVendaHiper(
          tokenHiper: cliente.tokenHiper!,
          cliente: cliente,
          endereco: cliente.endereco!,
          entrega: cliente.entrega!,
          itens: items,
          meiosPagamento: meiosPagamento,
          pedidoVenda: order.numeroPedidoDeVenda,
          observacao: order.observacaoDoPedidoDeVenda,
          valorFrete: order.valorDoFrete);
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

  Future<bool> postPedidoDeVendaHiper(
      {required String tokenHiper,
      required UserModel cliente,
      required EnderecoModel endereco,
      required EnderecoModel entrega,
      required List<CartItemModelHiper> itens,
      required List<MeiosPagamentoModel> meiosPagamento,
      required String pedidoVenda,
      required String observacao,
      required double valorFrete}) async {
    final bodyReq = {
      "cliente": {
        "documento": cliente.cpf,
        "email": cliente.email,
        "inscricaoEstadual": '',
        "nomeDoCliente": cliente.name,
        "nomeFantasia": ''
      },
      "enderecoDeCobranca": {
        "bairro": endereco.bairro,
        "cep": endereco.cep,
        "codigoIbge": int.parse(endereco.codigoIBGE),
        "complemento": endereco.complemento,
        "logradouro": endereco.logradouro,
        "numero": endereco.numero
      },
      "enderecoDeEntrega": {
        "bairro": endereco.bairro,
        "cep": endereco.cep,
        "codigoIbge": int.parse(endereco.codigoIBGE),
        "complemento": endereco.complemento,
        "logradouro": endereco.logradouro,
        "numero": endereco.numero
      },
      "numeroPedidoDeVenda": pedidoVenda,
      "observacaoDoPedidoDeVenda": observacao,
      "valorDoFrete": valorFrete,
      "itens": itens
          .map((e) => {
                "produtoId": e.produtoId,
                "quantidade": e.quantidade,
                "precoUnitarioBruto": e.precoUnitarioBruto,
                "precoUnitarioLiquido": e.precoUnitarioLiquido
              })
          .toList(),
      "meiosDePagamento": meiosPagamento
          .map((e) => {
                "idMeioDePagamento": e.idMeioPagamento,
                "parcelas": e.parcelas,
                "valor": e.valor
              })
          .toList(),
    };
    final result = await _httpManager.restRequest(
        url: Endpoints.postPedidoDeVenda,
        method: HttpMethods.post,
        headers: {"Authorization": "Bearer $tokenHiper"},
        body: bodyReq);
    if (result['menssagem'] != null) {
      return true;
    } else {
      return false;
    }
  }
}
