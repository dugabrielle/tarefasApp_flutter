import 'package:app_tarefas/src/provider/theme_provider.dart';
import 'package:app_tarefas/src/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:app_tarefas/src/screens/forgot.dart';
import 'package:app_tarefas/src/screens/home.dart';
import 'package:app_tarefas/src/screens/login.dart';
import 'package:app_tarefas/src/screens/register.dart';
import 'package:app_tarefas/src/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? user = FirebaseAuth.instance.currentUser;

  final AuthService authService = AuthService();

  runApp(
    MyApp(initialRoute: user != null ? '/home' : '/', authService: authService),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  final AuthService authService;

  const MyApp({
    super.key,
    required this.initialRoute,
    required this.authService,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final provider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: provider.theme,
          initialRoute: widget.initialRoute,
          routes: {
            '/': (context) => WelcomeScreen(),
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/register':
                (context) => RegisterScreen(authService: widget.authService),
            '/forgot': (context) => ForgotPasswordScreen(),
          },
        );
      },
    );
  }
}
