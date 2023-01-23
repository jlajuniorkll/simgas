import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/models/pagamento_model.dart';
import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/pagamento_helper.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertPayment extends StatelessWidget {
  const AlertPayment({
    Key? key,
    required this.valorTotal,
  }) : super(key: key);

  final double valorTotal;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Formas de Pagamento"),
      content: Form(
          key: formKey,
          child: GetBuilder<CartController>(
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: DropdownButton<FormaPagamento>(
                      value: controller.dropdownValue,
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
                        controller.setDropDownButton(value!);
                        controller
                            .setMeioPagamento(controller.dropdownValue.id);
                        switch (controller.dropdownValue.id) {
                          case 2:
                            controller.setCondictions(true);
                            break;
                          case 4:
                            controller.setCondictions(true);
                            break;
                          case 6:
                            controller.setCondictions(true);
                            break;
                          default:
                            controller.setCondictions(false);
                            controller.setNParcelas(1);
                        }
                        controller.update();
                      },
                      items: list.map<DropdownMenuItem<FormaPagamento>>(
                          (FormaPagamento? value) {
                        return DropdownMenuItem<FormaPagamento>(
                          value: value,
                          child: Text(value!.nome),
                        );
                      }).toList(),
                    ),
                  ),
                  if (controller.condictions == true)
                    CustomTextField(
                      textInputType: TextInputType.number,
                      icon: Icons.credit_card,
                      label: "Número de parcelas",
                      validator: nParcelasValidator,
                      onSaved: (value) {
                        controller.setNParcelas(int.parse(value!));
                      },
                    ),
                ],
              );
            },
          )),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancelar")),
        GetBuilder<CartController>(builder: (controller) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  controller.setMeiosPagamento(MeiosPagamentoModel(
                      idMeioPagamento: controller.meioPagamento,
                      parcelas: controller.nParcelas,
                      valor: valorTotal));
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text("Confirma"));
        })
      ],
    );
  }
}
