import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/formatters.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                      child: Center(
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 40),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(45),
                        )),
                    child: Form(
                        key: _formKey,
                        child: GetBuilder<AuthController>(
                            builder: (authController) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                icon: Icons.email,
                                label: 'Email',
                                textInputType: TextInputType.emailAddress,
                                validator: emailValidator,
                                onSaved: (value) {
                                  authController.user.email = value;
                                },
                              ),
                              CustomTextField(
                                  icon: Icons.lock,
                                  label: 'Senha',
                                  isSecret: true,
                                  validator: senhaValidator,
                                  onSaved: (value) {
                                    authController.user.password = value;
                                  }),
                              CustomTextField(
                                  icon: Icons.person,
                                  label: 'Nome',
                                  validator: nameValidator,
                                  onSaved: (value) {
                                    authController.user.name = value;
                                  }),
                              CustomTextField(
                                  icon: Icons.phone,
                                  label: 'Celular',
                                  inputFormatters: [phoneFormatter],
                                  textInputType: TextInputType.phone,
                                  validator: phoneValidator,
                                  onSaved: (value) {
                                    authController.user.phone = value;
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Pessoa Jurídica?"),
                                  Switch(
                                      value: authController.isJurudico,
                                      onChanged: (bool value) =>
                                          authController.setJuridico(value)),
                                ],
                              ),
                              !authController.isJurudico
                                  ? CustomTextField(
                                      icon: Icons.file_copy,
                                      label: 'CPF',
                                      inputFormatters: [cpfFormatter],
                                      textInputType: TextInputType.number,
                                      validator: cpfValidator,
                                      onSaved: (value) {
                                        authController.user.cpf = value;
                                      })
                                  : Column(
                                      children: [
                                        CustomTextField(
                                            icon: Icons.file_copy,
                                            label: 'CNPJ',
                                            inputFormatters: [cnpjFormatter],
                                            textInputType: TextInputType.number,
                                            validator: cnpjValidator,
                                            onSaved: (value) {
                                              authController.user.cnpj = value;
                                            }),
                                        CustomTextField(
                                            icon: Icons.file_copy,
                                            label: 'Inscrição Estadual',
                                            textInputType: TextInputType.number,
                                            onSaved: (value) {
                                              authController.user
                                                  .inscricaoEstadual = value;
                                            }),
                                      ],
                                    ),
                              SizedBox(
                                  height: 50,
                                  child: Obx((() {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18))),
                                      onPressed: authController.isLoading.value
                                          ? null
                                          : () {
                                              // remove o teclado ao clicar em entrar
                                              FocusScope.of(context).unfocus();
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                authController.signUp();
                                              }
                                            },
                                      child: authController.isLoading.value
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              'Entrar',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                    );
                                  }))),
                            ],
                          );
                        })),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
