import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu e-mail';
  } else if (!email.isEmail) {
    return 'Digite um email válido';
  } else {
    return null;
  }
}

String? senhaValidator(String? pass) {
  if (pass == null || pass.isEmpty) {
    return 'Digite sua senha';
  } else if (pass.length < 4) {
    return 'Senha deve ter mínimo 4 caracteres!';
  } else {
    return null;
  }
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite um nome';
  }
  final names = name.split(' ');
  if (names.length == 1) return 'Digite seu nome completo';
  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    return 'Digite um celular';
  }

  if (!phone.isPhoneNumber || phone.length < 15) {
    return 'Digite um número válido';
  }

  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    return 'Digite um celular';
  }

  if (!cpf.isCpf) return 'Digite um cpf válido';

  return null;
}
