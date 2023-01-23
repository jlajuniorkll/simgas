// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'endereco_model.g.dart';

@JsonSerializable()
class EnderecoModel {
  String? id;
  String? cep;
  String? logradouro;
  String? numero;
  String? bairro;
  String? codigoIBGE;
  String? complemento;
  String? referencia;
  String? cidade;
  String? estado;

  EnderecoModel(
      {this.id = '',
      this.cep,
      this.logradouro,
      this.numero = '',
      this.bairro,
      this.codigoIBGE,
      this.complemento = '',
      this.referencia = '',
      this.cidade,
      this.estado});

  int convertStringInt(String value) {
    return int.parse(value);
  }

  factory EnderecoModel.fromJson(Map<String, dynamic> json) =>
      _$EnderecoModelFromJson(json);
  Map<String, dynamic> toJson() => _$EnderecoModelToJson(this);
}
