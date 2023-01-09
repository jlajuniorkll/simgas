// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_itemmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      productId: json['product'] as String,
      id: json['id'] as String,
      item: json['item'] == null
          ? null
          : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'product': instance.productId,
      'item': instance.item,
      'quantity': instance.quantity,
      'id': instance.id,
    };

CartItemModelHiper _$CartItemModelHiperFromJson(Map<String, dynamic> json) =>
    CartItemModelHiper(
      produtoId: json['produtoId'] as String,
      quantidade: (json['quantidade'] as num).toDouble(),
      precoUnitarioBruto: (json['precoUnitarioBruto'] as num).toDouble(),
      precoUnitarioLiquido: (json['precoUnitarioLiquido'] as num).toDouble(),
    );

Map<String, dynamic> _$CartItemModelHiperToJson(CartItemModelHiper instance) =>
    <String, dynamic>{
      'produtoId': instance.produtoId,
      'quantidade': instance.quantidade,
      'precoUnitarioBruto': instance.precoUnitarioBruto,
      'precoUnitarioLiquido': instance.precoUnitarioLiquido,
    };
