import 'package:badges/badges.dart' as badges;
import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/cart/view/components/alert_adress.dart';
import 'package:dartt_shop/src/pages/cart/view/components/alert_payment.dart';
import 'package:dartt_shop/src/pages/cart/view/components/cart_tile.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const percentScreen = 0.6;
    return Scaffold(
      appBar: AppBar(title: const Text("Carrinho")),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: size.height,
              width: size.width < 800 ? size.width : size.width * percentScreen,
              child: Column(
                children: [
                  Expanded(child: GetBuilder<CartController>(
                    builder: (controller) {
                      if (controller.cartItems.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.remove_shopping_cart,
                                size: 40,
                                color: CustomColors.customSwatchColor),
                            const Text("Não há itens no carrinho")
                          ],
                        );
                      }
                      return ListView.builder(
                        itemCount: controller.cartItems.length,
                        itemBuilder: (_, index) {
                          return CartTile(
                              cartItem: controller.cartItems[index]);
                        },
                      );
                    },
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 3,
                              spreadRadius: 2)
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Total de Produtos",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        GetBuilder<CartController>(
                          builder: (controller) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                utilsServices.priceToCurrency(
                                    controller.cartTotalPrice()),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: CustomColors.customSwatchColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        GetBuilder<CartController>(
                          builder: (controller) {
                            return TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: () async {
                                await pagamentoConfirmation();
                              },
                              child: controller.meiosPagamento.isEmpty
                                  ? Row(children: [
                                      const Text('Definir Pagamento'),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: SizedBox(
                                          height: 17,
                                          width: 17,
                                          child: badges.Badge(
                                            badgeStyle: badges.BadgeStyle(
                                              padding: EdgeInsets.zero,
                                              badgeColor: CustomColors
                                                  .customContrastColor,
                                            ),
                                            badgeContent: const Icon(
                                              Icons.warning,
                                              color: Colors.white,
                                              size: 10,
                                            ),
                                          ),
                                        ),
                                      )
                                    ])
                                  : Row(
                                      children: [
                                        Text(
                                            'R\$${controller.meiosPagamento.first.valor} - ${controller.dropdownValue.nome} - ${controller.meiosPagamento.first.parcelas}x'),
                                      ],
                                    ),
                            );
                          },
                        ),
                        GetBuilder<CartController>(
                          builder: (controller) {
                            return TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18))),
                                onPressed: () async {
                                  final positionEncontrada =
                                      await controller.getPosition();
                                  if (positionEncontrada) {
                                    controller.setTypeAdress(0);
                                    await enderecoConfirmation();
                                  } else {
                                    utilsServices.showToast(
                                        message:
                                            "Habilite sua localização neste dispositivo!");
                                  }
                                },
                                child: controller.entrega.cep != null &&
                                        controller.entrega.numero!.isNotEmpty
                                    ? Row(
                                        children: [
                                          Text(
                                              '${controller.entrega.logradouro}, ${controller.entrega.numero}'),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          controller.isLoading
                                              ? const SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator())
                                              : const Text('Definir Endereço'),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                              height: 17,
                                              width: 17,
                                              child: badges.Badge(
                                                badgeStyle: badges.BadgeStyle(
                                                  padding: EdgeInsets.zero,
                                                  badgeColor: CustomColors
                                                      .customContrastColor,
                                                ),
                                                badgeContent: const Icon(
                                                  Icons.warning,
                                                  color: Colors.white,
                                                  size: 10,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ));
                          },
                        ),
                        SizedBox(
                          height: 50,
                          child:
                              GetBuilder<CartController>(builder: (controller) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomColors.customSwatchColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: (controller.isCheckoutLoading ||
                                      controller.cartItems.isEmpty)
                                  ? null
                                  : () async {
                                      bool? result =
                                          await showOrderConfirmation();
                                      if (result == true) {
                                        if (cartController.entrega.logradouro!
                                                .isNotEmpty &&
                                            cartController
                                                .entrega.numero!.isNotEmpty) {
                                          if (cartController
                                              .meiosPagamento.isNotEmpty) {
                                            cartController.checkoutCart();
                                          } else {
                                            utilsServices.showToast(
                                                message:
                                                    'Defina a forma de pagamento!');
                                          }
                                        } else {
                                          utilsServices.showToast(
                                              message:
                                                  'Defina um endereço de entrega!');
                                        }
                                      } else {
                                        utilsServices.showToast(
                                            message: 'Pedido não confirmado!');
                                      }
                                    },
                              child: controller.isCheckoutLoading
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      "Concluir pedido",
                                      style: TextStyle(fontSize: 18),
                                    ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("Confirmação"),
            content: const Text("Deseja realmente confirmar o pedido?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Não")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Sim"))
            ],
          );
        });
  }

  Future<bool?> pagamentoConfirmation() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          final controller = Get.find<CartController>();
          return AlertPayment(valorTotal: controller.cartTotalPrice());
        });
  }

  Future<bool?> enderecoConfirmation() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return const AlertAdress();
        });
  }
}
