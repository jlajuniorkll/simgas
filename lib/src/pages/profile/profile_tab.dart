import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const percentScreen = 0.6;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil do usuário"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          height: size.height,
          width: size.width < 800 ? size.width : size.width * percentScreen,
          child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              children: [
                CustomTextField(
                  icon: Icons.person,
                  label: "Nome",
                  iniValue: authController.user.name,
                  isInActive: true,
                ),
                CustomTextField(
                  icon: Icons.file_copy,
                  label: "CPF",
                  isSecret: true,
                  iniValue: authController.user.cpf,
                  isInActive: true,
                ),
                CustomTextField(
                  icon: Icons.phone,
                  label: "Celular",
                  iniValue: authController.user.phone,
                  isInActive: true,
                ),
                CustomTextField(
                  icon: Icons.email,
                  label: "Email",
                  iniValue: authController.user.email,
                  isInActive: true,
                ),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(
                              color: CustomColors.customSwatchColor)),
                      onPressed: () => updatePassword(),
                      child: const Text("Atualizar senha")),
                )
              ]),
        ),
      ),
    );
  }

  Future<bool?> updatePassword() {
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "Atualização de senha",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        CustomTextField(
                          controller: currentPasswordController,
                          icon: Icons.lock,
                          label: "Senha Atual",
                          isSecret: true,
                          validator: senhaValidator,
                        ),
                        CustomTextField(
                          controller: newPasswordController,
                          icon: Icons.lock_outline,
                          label: "Nova Senha",
                          isSecret: true,
                          validator: senhaValidator,
                        ),
                        CustomTextField(
                          icon: Icons.lock_outline,
                          label: "Confirmar nova senha",
                          isSecret: true,
                          validator: (password) {
                            final result = senhaValidator(password);
                            if (result != null) {
                              return result;
                            }
                            if (password != newPasswordController.text) {
                              return 'As senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 45,
                          child: Obx(
                            () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                onPressed: authController.isLoading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          authController.changePassword(
                                              currentPassword:
                                                  currentPasswordController
                                                      .text,
                                              newPassword:
                                                  newPasswordController.text);
                                        }
                                      },
                                child: authController.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text("Atualizar")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ))
              ],
            ),
          );
        });
  }
}
