import 'package:app_tarefas/src/tests/validar_email.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValidateEmail validateEmail;

  setUp(() {
    validateEmail = ValidateEmail();
  }); // a função é chamada toda vez que um teste é executado

  group('Validar email', () {
    test('mostrar mensagem de erro caso o e-mail seja nulo', () {
      final resultado = validateEmail.validate(email: null);

      expect(resultado, equals('O e-mail não pode estar vazio'));
    });

    test('mostrar mensagem de erro caso o e-mail seja vazio', () {
      final resultado = validateEmail.validate(email: '');

      expect(resultado, equals('O e-mail não pode estar vazio'));
    });

    test('retornar null caso o e-mail seja válido', () {
      final resultado = validateEmail.validate(email: 'teste@email.com');

      expect(resultado, isNull);
    });
  });
}
