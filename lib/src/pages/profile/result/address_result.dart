import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_result.freezed.dart';

@freezed
class AddressResult<T> with _$AddressResult<T> {
  factory AddressResult.success(T data) = Success;
  factory AddressResult.error(String error) = Error;
}
