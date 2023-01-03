import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_result.freezed.dart';

// flutter pub run build_runner watch
// fica observando se existe alguma coisa a ser auto gerada
@freezed
class HomeResult<T> with _$HomeResult<T> {
  factory HomeResult.success(List<T> data) = Success;
  factory HomeResult.error(String message) = Error;
}
