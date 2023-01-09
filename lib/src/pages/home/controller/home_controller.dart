import 'package:collection/collection.dart';
import 'package:dartt_shop/src/models/item_model.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/home/repository/home_repository.dart';
import 'package:dartt_shop/src/pages/home/result/home_result.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:get/get.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final HomeRepository homeRepository;
  HomeController(this.homeRepository);

  final utilservices = UtilsServices();
  final authController = Get.find<AuthController>();

  List<ItemModel> allProducts = [];
  List<ItemModel> allProductsFiltered = [];
  List<String> categoriesHiper = [];

  RxString searchTitle = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    // função do getx
    debounce(searchTitle, (_) => filterByTitle(),
        time: const Duration(milliseconds: 600));

    // getAllProductsHiper();
    await getAllCategoriesHiper();
    categoriesHiper.insert(0, 'Todos');
    selectCategory('Todos');
  }

  bool isCategoryLoading = false;
  bool isProductLoading = true;

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    update();
  }

  String? currentCategory;
  void selectCategory(String category) {
    currentCategory = category;
    allProductsFiltered.clear();

    if (currentCategory != 'Todos') {
      allProductsFiltered.addAll(
          allProducts.where((x) => x.categoria.contains(currentCategory!)));
    } else {
      allProductsFiltered.addAll(allProducts);
    }

    update();
    if (currentCategory != null) return;
    getAllProductsHiper();
  }

  Future<void> getAllCategoriesHiper() async {
    setLoading(true);
    await getAllProductsHiper();
    update();
    var newMap = groupBy(allProducts, (ItemModel obj) => obj.categoria)
        .map((k, v) => MapEntry(
            k,
            v.map((item) {
              return item;
            }).toList()));
    for (var i in newMap.keys) {
      categoriesHiper.add(i);
    }
    update();
    setLoading(false);
  }

  void filterByTitle() {
    if (searchTitle.value.isNotEmpty) {
      selectCategory('Todos');
      allProductsFiltered.clear();
      allProductsFiltered.addAll(allProducts.where((e) =>
          e.itemName.toUpperCase().contains(searchTitle.value.toUpperCase())));
    } else {
      allProductsFiltered.clear();
      allProductsFiltered.addAll(allProducts);
    }
    update();
  }

  Future<void> getAllProductsHiper({bool canLoad = true}) async {
    allProducts.clear();
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    HomeResult<ItemModel> result = await homeRepository.getAllProductsHiper(
        tokenHiper: authController.user.tokenHiper!);
    result.when(
      success: (data) {
        allProducts.addAll(data);
      },
      error: (message) {
        utilservices.showToast(message: message, isError: true);
      },
    );

    setLoading(false, isProduct: true);
  }
}
