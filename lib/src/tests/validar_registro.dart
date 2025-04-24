import 'package:app_tarefas/src/tests/validar_email.dart';
import 'package:app_tarefas/src/tests/validar_senha.dart';

class Registro {
  register(String? email, String? pass) {
    final emailError = ValidateEmail().validate(email: email);
    final passError = ValidatePassword().validate(pass: pass);

    return emailError ?? passError;
  }
}