import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF9E76C8), Color(0xFFF7F1FC)],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/src/assets/images/logo.png',
                        width: 90,
                        height: 90,
                      ),
                      const SizedBox(height: 35),
                      const Text.rich(
                        TextSpan(
                          text: 'Bem-vindo ao ToDo App ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            color: Color.fromARGB(255, 48, 48, 48),
                          ),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.favorite,
                                color: Color(0xFF3F178F),
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F178F),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(150, 50),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Entrar'),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1C2F1),
                              foregroundColor: Colors.black,
                              minimumSize: const Size(150, 50),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text('Criar conta'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'Nossas redes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          color: Color.fromARGB(255, 48, 48, 48),
                        ),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Color(0xFF1877F2),
                              size: 50,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.instagram,
                              color: Color(0xFF833AB4),
                              size: 50,
                            ),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.linkedin,
                              color: Color(0xFF0077B5),
                              size: 50,
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
          ),
        ),
      ),
    );
  }
}
