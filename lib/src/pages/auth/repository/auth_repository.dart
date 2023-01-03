import 'package:dartt_shop/src/constants/endpoints.dart';
import 'package:dartt_shop/src/models/user_model.dart';
import 'package:dartt_shop/src/pages/auth/result/auth_result.dart';
import 'package:dartt_shop/src/services/http_manager.dart';
import 'package:dartt_shop/src/pages/auth/repository/auth_errors.dart'
    as autherror;

abstract class AuthRepository {
  AuthResult handleUserOnError(Map<dynamic, dynamic> result);
  Future<AuthResult> validateToken(String token);
  Future<AuthResult> signIn({
    required String email,
    required String password,
  });
  Future<AuthResult> singUp(UserModel user);
  Future<void> resetPassword(String email);
  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String token,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final HttpManager _httpManager;
  AuthRepositoryImpl(this._httpManager);

  @override
  AuthResult handleUserOnError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final usuario = UserModel.fromJson(result['result']);
      return AuthResult.success(usuario);
    } else {
      return AuthResult.error(autherror.authErrorsString(result['error']));
    }
  }

  @override
  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.validateToken,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        });
    return handleUserOnError(result);
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signin,
        method: HttpMethods.post,
        body: {'email': email, 'password': password});

    return handleUserOnError(result);
  }

  @override
  Future<AuthResult> singUp(UserModel user) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signup, method: HttpMethods.post, body: user.toJson());
    return handleUserOnError(result);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
        url: Endpoints.resetPassword,
        method: HttpMethods.post,
        body: {'email': email});
  }

  @override
  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changePassword,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        },
        body: {
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword
        });

    return result['error'] == null;
  }
}
