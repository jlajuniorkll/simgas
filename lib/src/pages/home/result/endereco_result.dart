import 'package:freezed_annotation/freezed_annotation.dart';

part 'endereco_result.freezed.dart';

@freezed
class EnderecoResult<T> with _$EnderecoResult<T> {
  factory EnderecoResult.success(T data) = Success;
  factory EnderecoResult.error(String message) = Error;
}
