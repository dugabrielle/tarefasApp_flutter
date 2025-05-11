import 'package:app_tarefas/src/services/firebase_auth.dart';
import 'package:app_tarefas/src/widgets/input_decorations.dart';
import 'package:app_tarefas/src/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final AuthService authService;

  const RegisterScreen({super.key, required this.authService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = widget.authService;
  }

  final _formKey = GlobalKey<FormState>();

  RegExp senhaRequisitos = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!#%@*$]).{8,40}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E7F8),
      body: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            padding: const EdgeInsets.only(top: 50, left: 10),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80.0, left: 20.0),
                child: Text(
                  'Criar Conta',
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
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFD5B1E3),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          key: const Key('name'),
                          controller: _nameController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          decoration: InputStyleDecoration.style().copyWith(
                            labelText: 'Nome de usuário',
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
                          ),
                          validator: _validarNome,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('email'),
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          decoration: InputStyleDecoration.style().copyWith(
                            labelText: 'Email',
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
                          ),
                          validator: _validarEmail,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('password'),
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Por favor, digite a senha.";
                            } else {
                              bool result = validarSenha(value);
                              if (result) {
                                return null;
                              } else {
                                return "A senha deve conter entre 8 e 40 caracteres, ao menos uma letra maiúscula, uma minúscula, um caractere especial e um número.";
                              }
                            }
                          },
                          obscureText: _obscureText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                          ),
                          decoration: InputStyleDecoration.style().copyWith(
                            labelText: 'Senha',
                            errorMaxLines: 3,
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
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            key: const Key('registerButton'),
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
                            onPressed:
                                _isLoading ? null : () => registrar(context),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Color.fromARGB(255, 22, 87, 139),
                                    )
                                    : const Text(
                                      'Registrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Já tem uma conta? ',
                                  style: TextStyle(
                                    color: Color(0xFF2E2E2E),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Entre',
                                      style: TextStyle(
                                        color: Color(0xFF003366),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validarNome(String? nome) {
    if (nome == null || nome.isEmpty) {
      return "O nome não pode estar vazio.";
    }

    if (nome.length < 3 || nome.length > 30) {
      return "O nome deve ter entre 3 e 30 caracteres.";
    }

    final nomeRegex = RegExp(r"^[A-Za-zÀ-ÿ\s'-]+$");
    if (!nomeRegex.hasMatch(nome)) {
      return "O nome contém caracteres inválidos.";
    }

    return null;
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'O e-mail não pode estar vazio.';
    } else if (!_auth.isValidEmail(value)) {
      return 'Formato de e-mail inválido.';
    }
    return null;
  }

  bool validarSenha(String sen) {
    String senha = sen.trim(); // remove espaços

    if (senhaRequisitos.hasMatch(senha)) {
      return true; // se senha for válida
    } else {
      return false;
    }
  }

  void registrar(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    try {
      await _auth.signUpWithEmailPassword(email, password, name);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
