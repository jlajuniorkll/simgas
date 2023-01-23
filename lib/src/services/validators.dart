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

String? nParcelasValidator(String? nParcelas) {
  if (nParcelas == null || nParcelas.isEmpty) {
    return 'Digite o número de parcelas';
  }

  if (nParcelas.length > 6) {
    return 'Parcelar até 6x';
  }

  return null;
}

String? cepValidator(String? cep) {
  if (cep == null || cep.isEmpty) {
    return 'Digite o CEP';
  }

  if (cep.length > 9) {
    return 'CEP inválido';
  }

  return null;
}

String? logradouroValidator(String? logradouro) {
  if (logradouro == null || logradouro.isEmpty) {
    return 'Rua deve ser preenchida';
  }
  return null;
}

String? bairroValidator(String? bairro) {
  if (bairro == null || bairro.isEmpty) {
    return 'Rua deve ser preenchida';
  }
  return null;
}

String? numeroValidator(String? numero) {
  if (numero == null || numero.isEmpty) {
    return 'Número deve ser preenchido';
  }
  return null;
}

String? referenciaValidator(String? referencia) {
  if (referencia == null || referencia.isEmpty) {
    return 'Digite um ponto de referência';
  }
  return null;
}

String? cidadeValidator(String? cidade) {
  if (cidade == null || cidade.isEmpty) {
    return 'Digite a cidade';
  }
  return null;
}

String? estadoValidator(String? estado) {
  if (estado == null || estado.isEmpty) {
    return 'Digite o estado';
  }
  return null;
}
