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
  void selectCategory(String category) async {
    currentCategory = category;
    allProductsFiltered.clear();

    if (currentCategory != 'Todos') {
      allProductsFiltered.addAll(
          allProducts.where((x) => x.categoria.contains(currentCategory!)));
    } else {
      allProductsFiltered.addAll(allProducts);
    }
    update();
    if (currentCategory == null) {
      await getAllProductsHiper();
    }
  }

  Future<void> getAllCategoriesHiper() async {
    setLoading(true);
    await getAllProductsHiper();
    var newMap = groupBy(allProducts, (ItemModel obj) => obj.categoria)
        .map((k, v) => MapEntry(
            k,
            v.map((item) {
              return item;
            }).toList()));
    for (var i in newMap.keys) {
      categoriesHiper.add(i);
    }
    setLoading(false);
  }

  void filterByTitle() {
    selectCategory('Todos');
    allProductsFiltered.clear();
    if (searchTitle.value.isNotEmpty) {
      allProductsFiltered.addAll(allProducts.where((e) =>
          e.itemName.toUpperCase().contains(searchTitle.value.toUpperCase())));
    } else {
      allProductsFiltered.addAll(allProducts);
    }
    update();
  }

  Future<void> getAllProductsHiper({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    HomeResult<ItemModel> result = await homeRepository.getAllProductsHiper(
        tokenHiper: authController.user.tokenHiper!);
    result.when(
      success: (data) {
        allProducts.clear();
        allProducts.addAll(data);
      },
      error: (message) {
        utilservices.showToast(message: message, isError: true);
      },
    );
    setLoading(false, isProduct: true);
  }
}
