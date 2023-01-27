import 'dart:convert';

import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:dartt_shop/src/pages/profile/result/address_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';
import 'package:http/http.dart' as http;

abstract class AddressRepository {
  Future<Map<String, dynamic>> fecthCep({required String cep});
  Future<AddressResult<String>> saveAddress(
      {required String token, required EnderecoModel address});
}

class AddressRepositoryImpl implements AddressRepository {
  final HttpManager _httpManager;

  AddressRepositoryImpl(this._httpManager);

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
  Future<AddressResult<String>> saveAddress(
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
        url: Endpoints.updateUser,
        method: HttpMethods.post,
        body: {"addressBilling": addressId},
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
