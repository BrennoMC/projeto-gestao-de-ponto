import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> login({
    required String email,
    required String password,
}) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    print("login realizado");
    return 'Success';
  } on FirebaseAuthException catch(e) {
    if (e.code == 'user-not-found') {
      return 'Usuário não encontrado';
    }

    return e.message;
  } catch (e) {
    print("message = $e");
    return e.toString();
  }
}
}