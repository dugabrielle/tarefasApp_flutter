import 'package:flutter_test/flutter_test.dart';

import '../test/src/tests/auth_service_test.mocks.dart';

import 'package:app_tarefas/src/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_tarefas/src/services/firebase_auth.dart';

@GenerateMocks([AuthService, UserCredential])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Teste da tela RegisterScreen', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    final mockUserCredential = MockUserCredential();

    when(
      mockAuthService.signUpWithEmailPassword(
        'teste@gmail.com',
        'Senha12@',
        'Nome',
      ),
    ).thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(authService: mockAuthService)),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('name')), 'Nome');
    await tester.enterText(find.byKey(Key('email')), 'teste@gmail.com');
    await tester.enterText(find.byKey(Key('password')), 'Senha12@');

    await tester.tap(find.byKey(Key('registerButton')));

    await tester.pumpAndSettle();

    verify(
      mockAuthService.signUpWithEmailPassword(
        'teste@gmail.com',
        'Senha12@',
        'Nome',
      ),
    ).called(1);
  });
}
