import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/category_model.dart';
import 'package:dartt_shop/src/models/item_model.dart';
import 'package:dartt_shop/src/pages/home/result/home_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';

abstract class HomeRepository {
  Future<HomeResult<CategoryModel>> getAllCategories();
  Future<HomeResult<ItemModel>> getAllProducts(Map<String, dynamic> body);
  Future<HomeResult<ItemModel>> getAllProductsHiper(
      {required String tokenHiper});
}

class HomeRepositoryImpl implements HomeRepository {
  final HttpManager _httpManager;

  HomeRepositoryImpl(this._httpManager);

  @override
  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await _httpManager.restRequest(
        url: Endpoints.getAllCategories, method: HttpMethods.post);

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult<CategoryModel>.success(data);
    } else {
      return HomeResult.error("Ocorreu um erro ao recuperar as categorias!");
    }
  }

  @override
  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllProducts,
      method: HttpMethods.post,
      body: body,
    );

    if (result['result'] != null) {
      List<ItemModel> data = (List<Map<String, dynamic>>.from(result['result']))
          .map(ItemModel.fromJson)
          .toList();

      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error("Ocorreu um erro ao recuperar os produtos!");
    }
  }

  @override
  Future<HomeResult<ItemModel>> getAllProductsHiper(
      {required String tokenHiper}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getProductsHiper,
      method: HttpMethods.get,
      headers: {"Authorization": "Bearer $tokenHiper"},
    );

    if (result['menssagem'] == null) {
      List<ItemModel> data =
          (List<Map<String, dynamic>>.from(result['produtos']))
              .map(ItemModel.fromJson)
              .toList();

      return HomeResult<ItemModel>.success(data);
    } else {
      return HomeResult.error("Ocorreu um erro ao recuperar os produtos!");
    }
  }
}
