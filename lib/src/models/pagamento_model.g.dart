// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagamento_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeiosPagamentoModel _$MeiosPagamentoModelFromJson(Map<String, dynamic> json) =>
    MeiosPagamentoModel(
      idMeioPagamento: json['idMeioPagamento'] as int,
      parcelas: json['parcelas'] as int,
      valor: (json['valor'] as num).toDouble(),
    );

Map<String, dynamic> _$MeiosPagamentoModelToJson(
        MeiosPagamentoModel instance) =>
    <String, dynamic>{
      'idMeioPagamento': instance.idMeioPagamento,
      'parcelas': instance.parcelas,
      'valor': instance.valor,
    };
