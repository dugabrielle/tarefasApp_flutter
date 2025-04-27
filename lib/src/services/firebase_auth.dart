import 'package:app_tarefas/src/services/firebase_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegExp.hasMatch(email);
  }

  // login
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (!isValidEmail(email)) {
      throw Exception('Por favor, insira um e-mail válido.');
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!(userCredential.user?.emailVerified ?? false)) {
        await _auth.signOut();
        throw Exception(
          'Por favor, verifique seu e-mail antes de fazer login.',
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  // cadastro

  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String name,
  ) async {
    if (!isValidEmail(email)) {
      throw Exception('Por favor, insira um e-mail válido.');
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestoreService.addUser(
        userCredential.user?.uid ?? '',
        email,
        name,
      );

      await userCredential.user?.sendEmailVerification();

      throw Exception('Por favor, verifique seu e-mail antes de continuar.');
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  // redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    if (!isValidEmail(email)) {
      throw Exception('Por favor, insira um e-mail válido.');
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  // google

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final usuarioGoogle = await googleSignIn.signIn();
      if (usuarioGoogle == null) {
        return null;
      }

      final authGoogle = await usuarioGoogle.authentication;

      final credenciais = GoogleAuthProvider.credential(
        idToken: authGoogle.idToken,
        accessToken: authGoogle.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credenciais);

      return userCredential;
    } catch (e) {
      throw Exception('Erro ao fazer login com Google: ${e.toString()}');
    }
  }

  // logout
  Future<void> logout() async {
    return await _auth.signOut();
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Usuário não encontrado. Verifique o e-mail.';
      case 'invalid-email':
        return 'O e-mail fornecido é inválido. Verifique e tente novamente.';
      case 'missing-password':
        return 'A senha não foi fornecida.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-credential':
        return 'As credenciais fornecidas estão incorretas, por favor, tente novamente.';
      case 'expired-action-code':
        return 'Este e-mail já está registrado. Por favor, use outro e-mail.';
      default:
        return 'Ocorreu um erro desconhecido. Tente novamente.';
    }
  }
}
