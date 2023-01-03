import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/base/controller/navigation_controller.dart';
import 'package:dartt_shop/src/pages/cart/view/cart_tab.dart';
import 'package:dartt_shop/src/pages/home/view/home_tab.dart';
import 'package:dartt_shop/src/pages/orders/view/orders_tab.dart';
import 'package:dartt_shop/src/pages/profile/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final navigatioController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: navigatioController.pageController,
          children: const [
            HomeTab(),
            CartTab(),
            OrderTab(),
            ProfileTab(),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              currentIndex: navigatioController.currentIndex,
              onTap: (index) {
                navigatioController.navigatePageView(index);
                // pageController.jumpToPage(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: colorPrimaryClient,
              selectedItemColor: colorSelectedClient,
              unselectedItemColor: colorUnSelectedClient,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: "Carrinho"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: "Pedidos"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), label: "Perfil"),
              ]),
        ));
  }
}
