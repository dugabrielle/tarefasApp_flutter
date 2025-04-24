import 'package:app_tarefas/src/tests/validar_senha.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValidatePassword validatePassword;

  setUp(() {
    validatePassword = ValidatePassword();
  }); // a função é chamada toda vez que um teste é executado

  group('Validar senha', () {
    test('mostrar mensagem de erro caso a senha seja nula', () {
      final resultado = validatePassword.validate(pass: null);

      expect(resultado, equals('A senha não pode estar vazia'));
    });

    test('mostrar mensagem de erro caso a senha seja vazio', () {
      final resultado = validatePassword.validate(pass: '');

      expect(resultado, equals('A senha não pode estar vazia'));
    });

    test('mostrar erro se a senha não atender os requisitos mínimos de segurança', () {
      final resultado = validatePassword.validate(pass: 'senha12');

      expect(resultado, equals('A senha deve conter pelo menos 8 caracteres, incluindo letra maiúscula, letra minúscula, número e um caractere especial (@, #, \$, %, *, !).'));
    });
    test('retornar null caso a senha seja válida', () {
      final resultado = validatePassword.validate(pass: 'Senha12@');

      expect(resultado, isNull);
    });
  });
}
