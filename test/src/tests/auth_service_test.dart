import 'auth_service_test.mocks.dart';

import 'package:app_tarefas/src/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_tarefas/src/services/firebase_auth.dart';

@GenerateMocks([AuthService, UserCredential])
void main() {
  testWidgets('deve exibir erros quando os campos estiverem vazios', (
    WidgetTester tester,
  ) async {
    final mockAuthService = MockAuthService();
    final mockUserCredential = MockUserCredential();

    when(mockAuthService.isValidEmail(any)).thenReturn(false);

    when(
      mockAuthService.signUpWithEmailPassword(any, any, any),
    ).thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(authService: mockAuthService)),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('name')), '');
    await tester.enterText(find.byKey(Key('email')), '');
    await tester.enterText(find.byKey(Key('password')), '');

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.byKey(Key('registerButton')));

    await tester.pump(Duration(seconds: 3));

    await tester.pumpAndSettle();

    expect(find.text('O nome não pode estar vazio.'), findsOneWidget);
    expect(find.text('O e-mail não pode estar vazio.'), findsOneWidget);
    expect(find.text('Por favor, digite a senha.'), findsOneWidget);
  });

  testWidgets('deve exibir erros quando os campos forem inválidos', (
    WidgetTester tester,
  ) async {
    final mockAuthService = MockAuthService();
    final mockUserCredential = MockUserCredential();

    when(mockAuthService.isValidEmail(any)).thenReturn(false);

    when(
      mockAuthService.signUpWithEmailPassword(any, any, any),
    ).thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(
      MaterialApp(home: RegisterScreen(authService: mockAuthService)),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('name')), '');
    await tester.enterText(find.byKey(Key('email')), 'teste@');
    await tester.enterText(find.byKey(Key('password')), 'senha1@');

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    await tester.tap(find.byKey(Key('registerButton')));

    await tester.pump(Duration(seconds: 3));

    await tester.pumpAndSettle();

    expect(find.text('O nome contém caracteres inválidos.'), findsOneWidget);
    expect(find.text('Formato de e-mail inválido.'), findsOneWidget);
    expect(
      find.textContaining(
        'A senha deve conter entre 8 e 40 caracteres, ao menos uma letra maiúscula, uma minúscula, um caractere especial e um número.',
      ),
      findsOneWidget,
    );
    await Future.delayed(Duration(seconds: 3));
  });
}
