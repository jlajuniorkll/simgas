// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as int? ?? 0,
      itemName: json['nome'] as String,
      imgUrl: json['imagem'] as String,
      unit: json['unidade'] as String,
      price: (json['preco'] as num).toDouble(),
      description: json['descricao'] as String,
      categoria: json['categoria'] as String,
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'codigo': instance.codigo,
      'nome': instance.itemName,
      'imagem': instance.imgUrl,
      'unidade': instance.unit,
      'preco': instance.price,
      'descricao': instance.description,
      'categoria': instance.categoria,
    };
