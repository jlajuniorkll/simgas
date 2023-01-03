import 'package:dartt_shop/src/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// isso deve ser colocado na mão e após rodar o build runner
// terminal: flutter pub run build_runner build
part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  factory AuthResult.success(UserModel user) = Success;
  factory AuthResult.error(String message) = Error;
}
