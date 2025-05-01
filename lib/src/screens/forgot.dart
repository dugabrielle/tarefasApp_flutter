import 'package:app_tarefas/src/services/firebase_auth.dart';
import 'package:app_tarefas/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Color(0xFF973ED2),
              Color(0xFF785AFE),
              Color(0xFF000000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Positioned(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/src/assets/images/logo.png',
                    width: 90,
                    height: 90,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    textAlign: TextAlign.center,
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: const Text(
                      'Informe o seu e-mail cadastrado:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color(0xFF491CA8),
                        ),
                        fixedSize: WidgetStateProperty.all(
                          const Size.fromWidth(130),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(16),
                        ),
                      ),
                      onPressed: () async {
                        String email = _emailController.text.trim();

                        if (email.isEmpty) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackbarStyle.snackStyle(
                              'Por favor, insira um e-mail válido.',
                            ),
                          );
                          return;
                        }

                        try {
                          await _auth.sendPasswordResetEmail(email);

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackbarStyle.snackStyle(
                              'E-mail de redefinição enviado!',
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackbarStyle.snackStyle(e.toString()),
                          );
                        }
                      },
                      child: const Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
