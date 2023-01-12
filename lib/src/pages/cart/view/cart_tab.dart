import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/models/pagamento_model.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/cart/view/components/cart_tile.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/pagamento_helper.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:dartt_shop/src/services/validators.dart';
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
      body: Center(
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
                            size: 40, color: CustomColors.customSwatchColor),
                        const Text("Não há itens no carrinho")
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.cartItems.length,
                    itemBuilder: (_, index) {
                      return CartTile(cartItem: controller.cartItems[index]);
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 3,
                          spreadRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Total de Produtos",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    GetBuilder<CartController>(
                      builder: (controller) {
                        return Text(
                          utilsServices
                              .priceToCurrency(controller.cartTotalPrice()),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: CustomColors.customSwatchColor,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    GetBuilder<CartController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: () async {
                                await pagamentoConfirmation();
                              },
                              child: const Text('Definir Pagamento')),
                        );
                      },
                    ),
                    GetBuilder<CartController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: () async {
                                await enderecoConfirmation();
                              },
                              child: const Text('Definir Endereço')),
                        );
                      },
                    ),
                    SizedBox(
                      height: 50,
                      child: GetBuilder<CartController>(builder: (controller) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: CustomColors.customSwatchColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          onPressed: (controller.isCheckoutLoading ||
                                  controller.cartItems.isEmpty)
                              ? null
                              : () async {
                                  bool? result = await showOrderConfirmation();
                                  if (result == true) {
                                    cartController.checkoutCart();
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

// ignore: must_be_immutable
class AlertPayment extends StatefulWidget {
  AlertPayment({
    Key? key,
    required this.valorTotal,
  }) : super(key: key);

  final double valorTotal;
  late FormaPagamento dropdownValue;
  late bool condictions;
  late int meioPagamento;
  late int nParcelas;
  @override
  State<AlertPayment> createState() => _AlertPaymentState();
}

class _AlertPaymentState extends State<AlertPayment> {
  @override
  void initState() {
    super.initState();
    widget.dropdownValue = list.first;
    widget.condictions = false;
    widget.meioPagamento = 0;
    widget.nParcelas = 1;
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<CartController>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Formas de Pagamento"),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: DropdownButton<FormaPagamento>(
                  value: widget.dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: CustomColors.customSwatchColor,
                  ),
                  elevation: 16,
                  style: TextStyle(color: CustomColors.customSwatchColor),
                  underline: Container(
                    height: 2,
                    color: CustomColors.customSwatchColor,
                  ),
                  onChanged: (FormaPagamento? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      widget.dropdownValue = value!;
                      widget.meioPagamento = widget.dropdownValue.id;
                      switch (widget.dropdownValue.id) {
                        case 2:
                          widget.condictions = true;
                          break;
                        case 4:
                          widget.condictions = true;
                          break;
                        case 6:
                          widget.condictions = true;
                          break;
                        default:
                          widget.condictions = false;
                      }
                    });
                  },
                  items: list.map<DropdownMenuItem<FormaPagamento>>(
                      (FormaPagamento value) {
                    return DropdownMenuItem<FormaPagamento>(
                      value: value,
                      child: Text(value.nome),
                    );
                  }).toList(),
                ),
              ),
              if (widget.condictions == true)
                CustomTextField(
                  textInputType: TextInputType.number,
                  icon: Icons.credit_card,
                  label: "Número de parcelas",
                  validator: nParcelasValidator,
                  onSaved: (value) {
                    setState(() {
                      widget.nParcelas = int.parse(value!);
                    });
                  },
                ),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                controller.setMeiosPagamento(MeiosPagamentoModel(
                    idMeioPagamento: widget.meioPagamento,
                    parcelas: widget.nParcelas,
                    valor: widget.valorTotal));
                Navigator.of(context).pop(true);
              }
            },
            child: const Text("Confirma"))
      ],
    );
  }
}

class AlertAdress extends StatelessWidget {
  const AlertAdress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Endereço"),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                textInputType: TextInputType.number,
                icon: Icons.document_scanner,
                label: "CEP",
                validator: cepValidator,
                onSaved: (value) {},
              ),
              CustomTextField(
                textInputType: TextInputType.number,
                icon: Icons.document_scanner,
                label: "Rua",
                validator: logradouroValidator,
                onSaved: (value) {},
              ),
              CustomTextField(
                textInputType: TextInputType.number,
                icon: Icons.document_scanner,
                label: "Número",
                validator: numeroValidator,
                onSaved: (value) {},
              ),
              CustomTextField(
                textInputType: TextInputType.number,
                icon: Icons.document_scanner,
                label: "Bairro",
                validator: bairroValidator,
                onSaved: (value) {},
              ),
              CustomTextField(
                textInputType: TextInputType.number,
                icon: Icons.document_scanner,
                label: "Complemento",
                onSaved: (value) {},
              ),
            ],
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancelar")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.of(context).pop(true);
              }
            },
            child: const Text("Confirma"))
      ],
    );
  }
}
