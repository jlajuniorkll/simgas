import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagamento_model.g.dart';

@JsonSerializable()
class MeiosPagamentoModel {
  int idMeioPagamento;
  int parcelas;
  double valor;

  MeiosPagamentoModel({
    required this.idMeioPagamento,
    required this.parcelas,
    required this.valor,
  });

  factory MeiosPagamentoModel.fromJson(Map<String, dynamic> json) =>
      _$MeiosPagamentoModelFromJson(json);
  Map<String, dynamic> toJson() => _$MeiosPagamentoModelToJson(this);
}
