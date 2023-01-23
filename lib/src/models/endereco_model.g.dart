// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endereco_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnderecoModel _$EnderecoModelFromJson(Map<String, dynamic> json) =>
    EnderecoModel(
      id: json['id'] as String? ?? '',
      cep: json['cep'] as String?,
      logradouro: json['logradouro'] as String?,
      numero: json['numero'] as String? ?? '',
      bairro: json['bairro'] as String?,
      codigoIBGE: json['codigoIBGE'] as String?,
      complemento: json['complemento'] as String? ?? '',
      referencia: json['referencia'] as String? ?? '',
      cidade: json['cidade'] as String?,
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$EnderecoModelToJson(EnderecoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cep': instance.cep,
      'logradouro': instance.logradouro,
      'numero': instance.numero,
      'bairro': instance.bairro,
      'codigoIBGE': instance.codigoIBGE,
      'complemento': instance.complemento,
      'referencia': instance.referencia,
      'cidade': instance.cidade,
      'estado': instance.estado,
    };
