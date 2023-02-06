import 'dart:convert';

import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/cart_itemmodel.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/models/order_model.dart';
import 'package:dartt_shop/src/models/pagamento_model.dart';
import 'package:dartt_shop/src/models/user_model.dart';
import 'package:dartt_shop/src/pages/cart/result/cart_result.dart';
import 'package:dartt_shop/src/pages/profile/result/address_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';
import 'package:http/http.dart' as http;

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
    required EnderecoModel enderecoModel,
    required EnderecoModel entrega,
  });
  Future<bool> changeItemQuantity(
      {required String token,
      required String cartItemId,
      required int quantity});
  Future<Map<String, dynamic>> fecthCep({required String cep});
  Future<AddressResult<String>> saveAddressDelivery(
      {required String token, required EnderecoModel address});
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
    required EnderecoModel enderecoModel,
    required EnderecoModel entrega,
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
          cep: enderecoModel.cep,
          logradouro: enderecoModel.logradouro,
          numero: enderecoModel.numero,
          bairro: enderecoModel.bairro,
          cidade: enderecoModel.cidade,
          estado: enderecoModel.estado,
          codigoIBGE: enderecoModel.codigoIBGE,
          referencia: enderecoModel.referencia,
          complemento: enderecoModel.complemento);
      cliente.entrega = EnderecoModel(
          cep: entrega.cep,
          logradouro: entrega.logradouro,
          numero: entrega.numero,
          bairro: entrega.bairro,
          cidade: entrega.cidade,
          estado: entrega.estado,
          codigoIBGE: entrega.codigoIBGE,
          referencia: entrega.referencia,
          complemento: entrega.complemento);
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
        "documento": cliente.cpf ?? cliente.cnpj,
        "email": cliente.email,
        "inscricaoEstadual": '',
        "nomeDoCliente": cliente.name,
        "nomeFantasia": ''
      },
      "enderecoDeCobranca": {
        "bairro": endereco.bairro,
        "cep": endereco.cep,
        "codigoIbge": int.parse(endereco.codigoIBGE!),
        "complemento": endereco.complemento,
        "logradouro": endereco.logradouro,
        "numero": endereco.numero
      },
      "enderecoDeEntrega": {
        "bairro": entrega.bairro,
        "cep": entrega.cep,
        "codigoIbge": int.parse(entrega.codigoIBGE!),
        "complemento": entrega.complemento,
        "logradouro": entrega.logradouro,
        "numero": entrega.numero
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

  @override
  Future<Map<String, dynamic>> fecthCep({required String cep}) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final notCNPJ = jsonEncode({"erro": true});
        return json.decode(notCNPJ);
        // throw Exception('Não foi possível buscar o Cep!');
      }
    } catch (e) {
      final notCNPJ = jsonEncode({"erro": true});
      return json.decode(notCNPJ);
    }
  }

  @override
  Future<AddressResult<String>> saveAddressDelivery(
      {required String token, required EnderecoModel address}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.saveAddress,
      method: HttpMethods.post,
      body: address.toJson(),
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      final addressId = result['result']['id'];
      final resultAddress = await _httpManager.restRequest(
        url: Endpoints.updateUserDelivery,
        method: HttpMethods.post,
        body: {"addressDelivery": addressId},
        headers: {
          'X-Parse-Session-Token': token,
        },
      );
      if (resultAddress['result'] == null) {
        return AddressResult.error("Erro ao vincular usuario no endereço!");
      }
      return AddressResult.success(result['result']['id']);
    } else {
      return AddressResult.error("Não foi possível salvar o endereço!");
    }
  }
}
