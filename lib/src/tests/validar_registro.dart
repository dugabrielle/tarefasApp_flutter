import 'package:app_tarefas/src/tests/validar_email.dart';
import 'package:app_tarefas/src/tests/validar_nome.dart';
import 'package:app_tarefas/src/tests/validar_senha.dart';

class Registro {
  register(String? name, String? email, String? pass) {
    final nameError = ValidateName().validate(name: name);
    final emailError = ValidateEmail().validate(email: email);
    final passError = ValidatePassword().validate(pass: pass);

    return nameError ?? emailError ?? passError;
  }
}
