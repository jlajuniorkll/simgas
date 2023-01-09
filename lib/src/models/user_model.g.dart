// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      name: json['fullname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      cpf: json['cpf'] as String?,
      password: json['password'] as String?,
      id: json['id'] as String?,
      token: json['token'] as String?,
      tokenHiper: json['tokenHiper'] as String?,
      entrega: json['entrega'] == null
          ? null
          : EnderecoModel.fromJson(json['entrega'] as Map<String, dynamic>),
      endereco: json['endereco'] == null
          ? null
          : EnderecoModel.fromJson(json['endereco'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'fullname': instance.name,
      'email': instance.email,
      'cpf': instance.cpf,
      'password': instance.password,
      'phone': instance.phone,
      'id': instance.id,
      'token': instance.token,
      'tokenHiper': instance.tokenHiper,
      'entrega': instance.entrega,
      'endereco': instance.endereco,
    };
