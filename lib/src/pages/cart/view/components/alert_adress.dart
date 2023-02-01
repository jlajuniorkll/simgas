import 'package:dartt_shop/src/pages/cart/controller/cart_controller.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/formatters.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertAdress extends StatelessWidget {
  const AlertAdress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final UtilsServices utilsServices = UtilsServices();
    return GetBuilder<CartController>(builder: (controller) {
      final topPadding = controller.typeAdress == 0 ? 12.0 : 4.0;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Form(
                key: formKey,
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Selecione uma das opções abaixo: ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0, 0, topPadding),
                            child: ElevatedButton(
                                onPressed: controller.typeAdress != 1
                                    ? () async {
                                        controller.setTypeAdress(1);
                                        final positionEncontrada =
                                            await controller.getPosition();
                                        if (!positionEncontrada) {
                                          utilsServices.showToast(
                                              message:
                                                  "Habilite sua localização neste dispositivo!");
                                        }
                                      }
                                    : null,
                                child: const Text("Localização Atual")),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0, 0, topPadding),
                            child: SizedBox(
                              child: ElevatedButton(
                                  onPressed: controller.typeAdress != 2
                                      ? () {
                                          controller.setTypeAdress(2);
                                        }
                                      : null,
                                  child: const Text("Busca por CEP")),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0, 0, topPadding),
                            child: ElevatedButton(
                                onPressed: controller.typeAdress != 3
                                    ? () {
                                        controller.setTypeAdress(3);
                                      }
                                    : null,
                                child: const Text("Informar manualmente")),
                          ),
                        ],
                      ),
                      if (controller.typeAdress == 2)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14.0),
                                child: CustomTextField(
                                  controller: controller.controllerCep,
                                  inputFormatters: [cepFormatter],
                                  textInputType: TextInputType.number,
                                  icon: Icons.document_scanner,
                                  label: "CEP",
                                  validator: cepValidator,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.getCep(
                                          controller.controllerCep.text);
                                    },
                                    icon: const Icon(Icons.search),
                                    label: const Text("CEP")),
                              ),
                            ),
                          ],
                        ),
                      if (controller.entrega.logradouro != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_pin),
                              const Text('Sua Localização:'),
                              Text(controller.entrega.numero!.isEmpty
                                  ? controller.entrega.logradouro!
                                  : '${controller.entrega.logradouro!}, ${controller.entrega.numero!}'),
                              if (controller.entrega.complemento!.isNotEmpty)
                                Text(controller.entrega.complemento!),
                              Text(controller.entrega.bairro!),
                              Text(
                                  '${controller.entrega.cidade}-${controller.entrega.estado}'),
                              Text('Cep: ${controller.entrega.cep}'),
                              if (controller.entrega.referencia!.isNotEmpty)
                                Text(controller.entrega.referencia!),
                            ],
                          ),
                        ),
                      if (controller.typeAdress == 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              CustomTextField(
                                  textInputType: TextInputType.number,
                                  icon: Icons.document_scanner,
                                  label: "CEP",
                                  validator: cepValidator,
                                  inputFormatters: [cepFormatter],
                                  iniValue: controller.entrega.cep,
                                  onSaved: (value) {
                                    controller.entrega.cep = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Endereco",
                                  iniValue: controller.entrega.logradouro,
                                  validator: logradouroValidator,
                                  onSaved: (value) {
                                    controller.entrega.logradouro = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Bairro",
                                  iniValue: controller.entrega.bairro,
                                  validator: bairroValidator,
                                  onSaved: (value) {
                                    controller.entrega.bairro = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Cidade",
                                  iniValue: controller.entrega.cidade,
                                  validator: cidadeValidator,
                                  onSaved: (value) {
                                    controller.entrega.cidade = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  iniValue: controller.entrega.estado,
                                  label: "Estado",
                                  validator: estadoValidator,
                                  onSaved: (value) {
                                    controller.entrega.estado = value!;
                                  }),
                            ],
                          ),
                        ),
                      CustomTextField(
                          textInputType: TextInputType.number,
                          icon: Icons.document_scanner,
                          label: "Número",
                          validator: numeroValidator,
                          iniValue: controller.entrega.numero,
                          onSaved: (value) {
                            controller.entrega.numero = value!;
                          }),
                      CustomTextField(
                          textInputType: TextInputType.text,
                          icon: Icons.document_scanner,
                          label: "Ponto de referência (opcional)",
                          iniValue: controller.entrega.referencia,
                          onSaved: (value) {
                            controller.entrega.referencia = value!;
                          }),
                      CustomTextField(
                          textInputType: TextInputType.text,
                          icon: Icons.document_scanner,
                          iniValue: controller.entrega.complemento,
                          label: "Complemento (opcional)",
                          onSaved: (value) {
                            controller.entrega.complemento = value!;
                          }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  // if (controller.endereco.cep == null) {
                                  //  controller.setTypeAdress(0);
                                  // }
                                },
                                child: const Text("Cancelar")),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    controller.controllerCep.text =
                                        controller.entrega.cep!;
                                    controller.saveAddressDelivery();
                                    controller.update();
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: const Text("Confirma")),
                          )
                        ],
                      )
                    ])))),
      );
    });
  }
}
