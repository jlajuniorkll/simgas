// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartt_shop/src/models/endereco_model.dart';
import 'package:json_annotation/json_annotation.dart';

// isso deve ser colocado na mão e após rodar o build runner
// terminal: flutter pub run build_runner build
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'fullname')
  String? name;
  String? email;
  String? cpf;
  String? password;
  String? phone;
  String? id;
  String? token;
  String? tokenHiper;
  @JsonKey(name: 'addressDelivery')
  String? idEntrega;
  EnderecoModel? entrega;
  @JsonKey(name: 'addressBilling')
  String? idEndereco;
  EnderecoModel? endereco;

  UserModel(
      {this.name,
      this.email,
      this.phone,
      this.cpf,
      this.password,
      this.id,
      this.token,
      this.tokenHiper,
      this.entrega,
      this.endereco,
      this.idEndereco,
      this.idEntrega});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /*Exemplo de uso sem o uso do plugin Json serializable*/
  /*factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      cpf: map['cpf'],
      email: map['email'],
      id: map['id'],
      name: map['fullname'],
      senha: map['password'],
      phone: map['phone'],
      token: map['token'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'email': email,
      'fullname': name,
      'password': senha,
      'phone': phone,
      'token': token,
    };
  }*/

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, cpf: $cpf, password: $password, phone: $phone, id: $id, token: $token)';
  }
}
