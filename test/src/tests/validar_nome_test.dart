import 'package:app_tarefas/src/tests/validar_nome.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ValidateName validateName;

  setUp(() {
    validateName = ValidateName();
  });

  group('Validar nome', () {
    test('mostrar mensagem de erro caso o nome seja nulo', () {
      final resultado = validateName.validate(name: null);

      expect(resultado, equals('O nome não pode estar vazio'));
    });

    test('mostrar mensagem de erro caso o nome seja vazio', () {
      final resultado = validateName.validate(name: '');

      expect(resultado, equals('O nome não pode estar vazio'));
    });

    test('retornar null caso o nome seja válido', () {
      final resultado = validateName.validate(name: 'Nome');

      expect(resultado, isNull);
    });
  });
}
