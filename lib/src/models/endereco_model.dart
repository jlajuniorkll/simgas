// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'endereco_model.g.dart';

@JsonSerializable()
class EnderecoModel {
  String id;
  String cep;
  String logradouro;
  String numero;
  String bairro;
  String codigoIBGE;
  String complemento;

  EnderecoModel({
    this.id = '',
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.codigoIBGE,
    this.complemento = '',
  });

  int convertStringInt(String value) {
    return int.parse(value);
  }

  factory EnderecoModel.fromJson(Map<String, dynamic> json) =>
      _$EnderecoModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnderecoModelToJson(this);
}
