import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/page_routes/app_pages.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:dartt_shop/src/pages/auth/view/components/forgot_password_dialog.dart';
import 'package:dartt_shop/src/pages/commons/custom_text_field.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:dartt_shop/src/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final utilsServices = UtilsServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nome do app
                  /*const AppNameWidget(
                    greenTitleColor: Colors.white,
                    textSize: 40,
                  ),*/
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/appimages/logo-simgas.png',
                      height: 250,
                      width: 250,
                    ),
                  ),
                  // categorias
                  SizedBox(
                    height: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 25),
                      child: AnimatedTextKit(
                          pause: Duration.zero,
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText('Bem vindo!'),
                            FadeAnimatedText('Gás'),
                            FadeAnimatedText('Água Mineral'),
                            FadeAnimatedText('Acessórios'),
                          ]),
                    ),
                  )
                ],
              )),
              // Formulário
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(45))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Textfields
                      CustomTextField(
                        controller: emailController,
                        icon: Icons.email,
                        label: 'Email',
                        validator: emailValidator,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        icon: Icons.lock,
                        label: 'Senha',
                        isSecret: true,
                        validator: senhaValidator,
                      ),
                      // Entrar
                      SizedBox(
                        height: 50,
                        child: GetX<AuthController>(
                          builder: (authController) {
                            return ElevatedButton(
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () {
                                      // remove o teclado ao clicar em entrar
                                      FocusScope.of(context).unfocus();
                                      /* Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: ((context) => const BaseScreen())));*/
                                      if (_formKey.currentState!.validate()) {
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;
                                        authController.signIn(
                                            email: email, password: password);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              child: authController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            );
                          },
                        ),
                      ),
                      // Esqueceu a senha
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () async {
                              final bool? result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ForgotPasswordDialog(
                                        email: emailController.text);
                                  });

                              if (result ?? false) {
                                utilsServices.showToast(
                                    message:
                                        "Link de recuperação enviado para o seu email!");
                              }
                            },
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: CustomColors.customContrastColor,
                              ),
                            )),
                      ),
                      // Divisor
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('Ou'),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(90),
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botão novo usuário
                      SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              side: BorderSide(
                                width: 2,
                                color: CustomColors.customSwatchColor,
                              )),
                          onPressed: () {
                            /* Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => SignupScreen()));*/
                            Get.toNamed(PagesRoutes.signupRoute);
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
