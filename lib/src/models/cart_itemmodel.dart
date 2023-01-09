// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:dartt_shop/src/models/item_model.dart';

part 'cart_itemmodel.g.dart';

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: 'product')
  String productId;
  ItemModel? item;
  int quantity;
  String id;

  CartItemModel({
    required this.productId,
    required this.id,
    this.item,
    required this.quantity,
  });

  double totalPrice() {
    final price = item?.price ?? 0;
    return price * quantity;
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  @override
  String toString() =>
      'CartItemModel(item: $item, quantity: $quantity, id: $id)';
}

@JsonSerializable()
class CartItemModelHiper {
  String produtoId;
  double quantidade;
  double precoUnitarioBruto;
  double precoUnitarioLiquido;

  CartItemModelHiper({
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitarioBruto,
    required this.precoUnitarioLiquido,
  });

  factory CartItemModelHiper.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelHiperFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelHiperToJson(this);
}
