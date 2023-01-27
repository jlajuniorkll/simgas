import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart' as badges;
import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/base/controller/navigation_controller.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/commons/appname_widget.dart';
import 'package:dartt_shop/src/pages/commons/custom_shimmer.dart';
import 'package:dartt_shop/src/pages/home/controller/home_controller.dart';
import 'package:dartt_shop/src/pages/home/view/components/categorytile.dart';
import 'package:dartt_shop/src/pages/home/view/components/producttile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();

  late Function(GlobalKey) runAddToCardAnimation;
  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const percentScreen = 0.6;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 20.0),
            child: GestureDetector(onTap: () {
              navigationController.navigatePageView(NavigationTabs.cart);
            }, child: GetBuilder<CartController>(builder: (controller) {
              return badges.Badge(
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: CustomColors.customContrastColor,
                  ),
                  badgeContent: Text(
                    controller.getCartTotalItems().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                  child: AddToCartIcon(
                    key: globalKeyCartItems,
                    icon: Icon(
                      Icons.shopping_cart,
                      color: CustomColors.customSwatchColor,
                    ),
                  ));
            })),
          )
        ],
      ),
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCardAnimation = addToCardAnimationMethod;
        },
        child: Center(
          child: SizedBox(
            height: size.height,
            width: size.width < 800 ? size.width : size.width * percentScreen,
            child: Column(
              children: [
                GetBuilder<HomeController>(
                  builder: (controller) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          controller.searchTitle.value = value;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            hintText: 'Pesquise aqui...',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14.0),
                            suffixIcon: controller.searchTitle.value.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      controller.searchTitle.value = '';
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: CustomColors.customContrastColor,
                                      size: 21,
                                    ),
                                  )
                                : null,
                            prefixIcon: Icon(
                              Icons.search,
                              color: CustomColors.customContrastColor,
                              size: 21,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(60),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none))),
                      ),
                    );
                  },
                ),
                GetBuilder<HomeController>(builder: (controller) {
                  return Container(
                    padding: const EdgeInsets.only(left: 16),
                    height: 40,
                    child: !controller.isCategoryLoading
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return CategoryTile(
                                category: controller.categoriesHiper[index],
                                isSelected: controller.categoriesHiper[index] ==
                                    controller.currentCategory,
                                onPressed: () {
                                  controller.selectCategory(
                                      controller.categoriesHiper[index]);
                                },
                              );
                            },
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 10),
                            itemCount: controller.categoriesHiper.length)
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                10,
                                (index) => Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      alignment: Alignment.center,
                                      child: CustomShimmer(
                                        height: 20,
                                        width: 80,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                          ),
                  );
                }),
                GetBuilder<HomeController>(builder: (controller) {
                  return Expanded(
                      child: !controller.isProductLoading
                          ? Visibility(
                              visible:
                                  (controller.allProductsFiltered).isNotEmpty,
                              replacement: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 40,
                                    color: CustomColors.customSwatchColor,
                                  ),
                                  const Text("Não há itens para apresentar")
                                ],
                              ),
                              child: GridView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  // childAspectRatio: 9 / 11.5,
                                  childAspectRatio: size.width < 800
                                      ? 9 / 11.5
                                      : MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.2),
                                ),
                                itemCount:
                                    controller.allProductsFiltered.length,
                                itemBuilder: (_, index) {
                                  //if ((index + 1) ==
                                  //    controller.allProducts.length) {
                                  //if (!controller.isLastPage) {
                                  //  controller.loadMoreProducts();
                                  //}
                                  //}
                                  return ProductTile(
                                    item: controller.allProductsFiltered[index],
                                    cartAnimationMethod:
                                        itemSelectedCartAnimations,
                                  );
                                },
                              ),
                            )
                          : GridView.count(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: size.width < 800
                                  ? 9 / 11.5
                                  : MediaQuery.of(context).size.width /
                                      (MediaQuery.of(context).size.height /
                                          1.2),
                              children: List.generate(
                                  10,
                                  (index) => CustomShimmer(
                                        height: double.infinity,
                                        width: double.infinity,
                                        borderRadius: BorderRadius.circular(20),
                                      )),
                            ));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
