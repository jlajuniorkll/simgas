import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  String id;
  int codigo;
  @JsonKey(name: 'nome')
  String itemName;
  @JsonKey(name: 'imagem')
  String imgUrl;
  @JsonKey(name: 'unidade')
  String unit;
  @JsonKey(name: 'preco')
  double price;
  @JsonKey(name: 'descricao')
  String description;
  String categoria;

  ItemModel(
      {this.id = '',
      this.codigo = 0,
      required this.itemName,
      required this.imgUrl,
      required this.unit,
      required this.price,
      required this.description,
      required this.categoria});

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);
}
