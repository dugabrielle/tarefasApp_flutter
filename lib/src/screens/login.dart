import 'package:app_tarefas/src/screens/home.dart';
import 'package:app_tarefas/src/services/firebase_auth.dart';
import 'package:app_tarefas/src/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E7F8),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          }

          return Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                padding: const EdgeInsets.only(top: 40, left: 10),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 80.0, left: 20.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5B1E3),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // campo email
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
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

                        const Expanded(child: SizedBox()),
                        // campo senha
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/forgot',
                                );
                              },
                              child: const Text(
                                'Esqueceu sua senha?',
                                style: TextStyle(
                                  color: Color(0xFF2E2E2E),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                const Color(0xFF9C3EC8),
                              ),
                              fixedSize: WidgetStateProperty.all(
                                const Size.fromWidth(130),
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(16),
                              ),
                            ),
                            onPressed: _isLoading ? null : () => login(context),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Color.fromARGB(255, 22, 87, 139),
                                    )
                                    : const Text(
                                      'Entrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        const Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 0.5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'OU',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Faça login com',
                              style: TextStyle(
                                color: Color(0xFF292828),
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.google,
                                size: 40,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await _auth.loginWithGoogle();
                              },
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 40,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email, password);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackbarStyle.snackStyle(e.toString()));
    }
  }
}
