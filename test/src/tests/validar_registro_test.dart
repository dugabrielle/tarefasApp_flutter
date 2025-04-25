import 'package:app_tarefas/src/tests/validar_registro.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Registro registro;

  setUp(() {
    registro = Registro();
  });

  group('Validar Registro', () {
    test(
      'mostrar uma mensagem de erro para um nome, e-mail e senha inválidos',
      () {
        final resultado = registro.register('', 'email', 'senha1@');
        expect(resultado, isA<String>());
      },
    );
    test('retornar null caso o e-mail e a senha sejam válidos', () {
      final resultado = registro.register(
        'Nome',
        'teste@email.com',
        'Senha12@',
      );
      expect(resultado, isNull);
    });
  });
}
