import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/pages/profile/controller/address_controller.dart';
import 'package:dartt_shop/src/services/formatters.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertAdressProfile extends StatelessWidget {
  const AlertAdressProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final UtilsServices utilsServices = UtilsServices();
    return GetBuilder<AddressController>(builder: (controller) {
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
                                        await controller.getPosition();
                                        /*if (!positionEncontrada) {
                                          utilsServices.showToast(
                                              message:
                                                  "Habilite sua localização neste dispositivo!");
                                        }*/
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
                      if (controller.endereco.logradouro != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_pin),
                              const Text('Sua Localização:'),
                              Text(controller.endereco.numero!.isEmpty
                                  ? controller.endereco.logradouro!
                                  : '${controller.endereco.logradouro!}, ${controller.endereco.numero!}'),
                              if (controller.endereco.complemento!.isNotEmpty)
                                Text(controller.endereco.complemento!),
                              Text(controller.endereco.bairro!),
                              Text(
                                  '${controller.endereco.cidade}-${controller.endereco.estado}'),
                              Text('Cep: ${controller.endereco.cep}'),
                              if (controller.endereco.referencia!.isNotEmpty)
                                Text(controller.endereco.referencia!),
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
                                  iniValue: controller.endereco.cep,
                                  onSaved: (value) {
                                    controller.endereco.cep = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Endereco",
                                  iniValue: controller.endereco.logradouro,
                                  validator: logradouroValidator,
                                  onSaved: (value) {
                                    controller.endereco.logradouro = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Bairro",
                                  iniValue: controller.endereco.bairro,
                                  validator: bairroValidator,
                                  onSaved: (value) {
                                    controller.endereco.bairro = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  label: "Cidade",
                                  iniValue: controller.endereco.cidade,
                                  validator: cidadeValidator,
                                  onSaved: (value) {
                                    controller.endereco.cidade = value!;
                                  }),
                              CustomTextField(
                                  textInputType: TextInputType.text,
                                  icon: Icons.document_scanner,
                                  iniValue: controller.endereco.estado,
                                  label: "Estado",
                                  validator: estadoValidator,
                                  onSaved: (value) {
                                    controller.endereco.estado = value!;
                                  }),
                            ],
                          ),
                        ),
                      CustomTextField(
                          textInputType: TextInputType.number,
                          icon: Icons.document_scanner,
                          label: "Número",
                          validator: numeroValidator,
                          iniValue: controller.endereco.numero,
                          onSaved: (value) {
                            controller.endereco.numero = value!;
                          }),
                      CustomTextField(
                          textInputType: TextInputType.text,
                          icon: Icons.document_scanner,
                          label: "Ponto de referência (opcional)",
                          iniValue: controller.endereco.referencia,
                          onSaved: (value) {
                            controller.endereco.referencia = value!;
                          }),
                      CustomTextField(
                          textInputType: TextInputType.text,
                          icon: Icons.document_scanner,
                          iniValue: controller.endereco.complemento,
                          label: "Complemento (opcional)",
                          onSaved: (value) {
                            controller.endereco.complemento = value!;
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
                                        controller.endereco.cep!;
                                    controller.saveAddress();
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
