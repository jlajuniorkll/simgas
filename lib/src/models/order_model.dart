// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dartt_shop/src/models/cart_itemmodel.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  String id;

  @JsonKey(name: 'createdAt')
  DateTime? createdDateTime;

  @JsonKey(name: 'due')
  DateTime overdueDateTime;

  String status;

  @JsonKey(name: 'copiaecola')
  String copyAndPaste;

  @JsonKey(name: 'total')
  double doubleTotal;
  String qrCodeImage;

  @JsonKey(defaultValue: [])
  List<CartItemModel> items;

  String numeroPedidoDeVenda;
  String observacaoDoPedidoDeVenda;
  double valorDoFrete;

  bool get isOverDue => overdueDateTime.isBefore(DateTime.now());

  OrderModel({
    required this.id,
    this.createdDateTime,
    required this.overdueDateTime,
    required this.items,
    required this.status,
    required this.copyAndPaste,
    required this.doubleTotal,
    required this.qrCodeImage,
    this.numeroPedidoDeVenda = '',
    this.observacaoDoPedidoDeVenda = '',
    this.valorDoFrete = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
