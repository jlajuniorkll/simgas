import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:dartt_shop/src/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().validateToken();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              CustomColors.customSwatchColor,
              CustomColors.customSwatchColor.shade700
            ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*AppNameWidget(
              greenTitleColor: Colors.white,
              textSize: 40,
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(
                'assets/appimages/logo-simgas.png',
                height: 250,
                width: 250,
                filterQuality: FilterQuality.high,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
