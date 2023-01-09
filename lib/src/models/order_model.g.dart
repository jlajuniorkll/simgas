// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      createdDateTime: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      overdueDateTime: DateTime.parse(json['due'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: json['status'] as String,
      copyAndPaste: json['copiaecola'] as String,
      doubleTotal: (json['total'] as num).toDouble(),
      qrCodeImage: json['qrCodeImage'] as String,
      numeroPedidoDeVenda: json['numeroPedidoDeVenda'] as String? ?? '',
      observacaoDoPedidoDeVenda:
          json['observacaoDoPedidoDeVenda'] as String? ?? '',
      valorDoFrete: (json['valorDoFrete'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdDateTime?.toIso8601String(),
      'due': instance.overdueDateTime.toIso8601String(),
      'status': instance.status,
      'copiaecola': instance.copyAndPaste,
      'total': instance.doubleTotal,
      'qrCodeImage': instance.qrCodeImage,
      'items': instance.items,
      'numeroPedidoDeVenda': instance.numeroPedidoDeVenda,
      'observacaoDoPedidoDeVenda': instance.observacaoDoPedidoDeVenda,
      'valorDoFrete': instance.valorDoFrete,
    };
