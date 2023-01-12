// ignore_for_file: public_member_api_docs, sort_constructors_first
class FormaPagamento {
  int id;
  String nome;
  FormaPagamento({
    required this.id,
    required this.nome,
  });
}

List<FormaPagamento> list = [
  FormaPagamento(id: 8, nome: 'Pix'),
  FormaPagamento(id: 1, nome: 'Dinheiro'),
  FormaPagamento(id: 2, nome: 'Cheque'),
  FormaPagamento(id: 4, nome: 'Cartão de Crédito'),
  FormaPagamento(id: 5, nome: 'Cartão de Débito'),
  FormaPagamento(id: 6, nome: 'Crediário'),
  FormaPagamento(id: 7, nome: 'Voucher'),
  FormaPagamento(id: 3, nome: 'Devolução'),
];
