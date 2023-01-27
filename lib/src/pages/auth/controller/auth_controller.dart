import 'package:dartt_shop/src/constants/storage_keys.dart';
import 'package:dartt_shop/src/models/user_model.dart';
import 'package:dartt_shop/src/page_routes/app_pages.dart';
import 'package:dartt_shop/src/pages/auth/repository/auth_repository.dart';
import 'package:dartt_shop/src/pages/auth/result/auth_result.dart';
import 'package:dartt_shop/src/services/utils_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  AuthController(this.authRepository);

  final UtilsServices utilsServices = UtilsServices();

  RxBool isLoading = false.obs;

  UserModel user = UserModel();

  // @override
  // void onInit() async {
  //  super.onInit();
  //}

  Future<void> validateToken() async {
    String? token = await utilsServices.getLocalData(key: StorageKeys.token);
    if (token == null) {
      Get.offAllNamed(PagesRoutes.signinRoute);
      return;
    }
    AuthResult result = await authRepository.validateToken(token);
    result.when(success: (user) async {
      this.user = user;
      saveTokenAndProccedToBase();
    }, error: (message) {
      signOut();
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;
    AuthResult result =
        await authRepository.signIn(email: email, password: password);
    result.when(success: (user) async {
      this.user = user;
      saveTokenAndProccedToBase();
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
    isLoading.value = false;
  }

  void saveTokenAndProccedToBase() async {
    final result = await getTokenHiper();
    await getEnderecoSaved();
    if (result) {
      utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);
      Get.offAllNamed(PagesRoutes.baseRoute);
    } else {
      utilsServices.showToast(message: 'Erro ao conectar com o Hiper');
    }
  }

  Future<void> signOut() async {
    user = UserModel();
    utilsServices.removeLocalData(key: StorageKeys.token);
    Get.offAllNamed(PagesRoutes.signinRoute);
  }

  Future<void> signUp() async {
    isLoading.value = true;
    AuthResult result = await authRepository.singUp(user);
    isLoading.value = false;
    result.when(success: (user) {
      this.user = user;
      saveTokenAndProccedToBase();
    }, error: (menssage) {
      utilsServices.showToast(message: menssage);
    });
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
        token: user.token!);
    isLoading.value = false;

    if (result) {
      utilsServices.showToast(
          message: 'Senha atualizada! Entre com a nova senha!');
      signOut();
    } else {
      utilsServices.showToast(
          message: 'A senha atual está incorreta', isError: true);
    }
  }

  Future<bool> getTokenHiper() async {
    String resultHiper = await authRepository.getTokenHiper();
    if (resultHiper == 'INVALID_TOKENHIPER') {
      utilsServices.showToast(message: 'Não foi possível conectar ao hiper');
      return false;
    } else {
      user.tokenHiper = resultHiper;
      update();
      return true;
    }
  }

  Future<void> getEnderecoSaved() async {
    if (user.idEndereco != null) {
      final result = await authRepository.getAddress(
          token: user.token!, idAddress: user.idEndereco!);
      result.when(success: (data) {
        user.endereco = data;
      }, error: (message) {
        utilsServices.showToast(message: message, isError: true);
      });
    }

    if (user.idEntrega != null) {
      final result = await authRepository.getAddress(
          token: user.token!, idAddress: user.idEntrega!);
      result.when(success: (data) {
        user.entrega = data;
      }, error: (message) {
        utilsServices.showToast(message: message, isError: true);
      });
    }
    update();
  }
}
