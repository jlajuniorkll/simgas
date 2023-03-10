import 'package:dartt_shop/src/constants/keys.dart';
import 'package:dio/dio.dart';

abstract class HttpMethods {
  static const String post = 'post';
  static const String get = 'get';
  static const String put = 'put';
  static const String patch = 'patch';
  static const String delete = 'delete';
}

abstract class HttpManager {
  Future<Map> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  });
}

class HttpManagerImpl implements HttpManager {
  @override
  Future<Map> restRequest({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    // se vir igual a nulo o valor é substituido por {} e sempre pega os valores do header e adiciona o restante ..addAll
    /* final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': 'g1Oui3JqxnY4S1ykpQWHwEKGOe0dRYCPvPF4iykc',
        'X-Parse-REST-API-Key': 'rFBKU8tk0m5ZlKES2CGieOaoYz6TgKxVMv8jRIsN',
      });*/

    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': xParseId,
        'X-Parse-REST-API-Key': xRestApiKey,
      });

    Dio dio = Dio();

    try {
      Response response = await dio.request(
        url,
        options: Options(headers: defaultHeaders, method: method),
        data: body,
      );
      // retorno resultado do server
      return response.data;
    } on DioError catch (error) {
      // retorno erro do server
      return error.response?.data ?? {};
    } catch (error) {
      // retorno erro geral
      return {};
    }
  }
}
