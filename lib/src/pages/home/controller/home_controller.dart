import 'package:dartt_shop/src/models/category_model.dart';
import 'package:dartt_shop/src/models/item_model.dart';
import 'package:dartt_shop/src/pages/home/repository/home_repository.dart';
import 'package:dartt_shop/src/pages/home/result/home_result.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:get/get.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  final HomeRepository homeRepository;
  HomeController(this.homeRepository);

  final utilservices = UtilsServices();

  List<CategoryModel> allCategories = [];
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  RxString searchTitle = ''.obs;

  bool get isLastPage {
    if (currentCategory!.items.length < itemsPerPage) return true;
    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override
  void onInit() {
    super.onInit();
    // função do getx
    debounce(searchTitle, (_) => filterByTitle(),
        time: const Duration(milliseconds: 600));

    getAllCategories();
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

  CategoryModel? currentCategory;
  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
    if (currentCategory!.items.isNotEmpty) return;
    getAllProducts();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);

        if (allCategories.isEmpty) return;
        selectCategory(allCategories.first);
      },
      error: (message) {
        utilservices.showToast(message: message, isError: true);
      },
    );

    setLoading(false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage
    };

    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;
      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }
    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);
    result.when(
      success: (data) {
        currentCategory!.items.addAll(data);
      },
      error: (message) {
        utilservices.showToast(message: message, isError: true);
      },
    );

    setLoading(false, isProduct: true);
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;
    getAllProducts(canLoad: false);
  }

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        final allProductsCategory =
            CategoryModel(items: [], title: 'Todos', id: '', pagination: 0);

        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }
    currentCategory = allCategories.first;
    update();
    getAllProducts();
  }
}
