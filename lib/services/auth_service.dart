import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();




  Future<String?> singIn({
    required String email,
    required String password,

}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);

    }
  }

  Future<String?> register({
    required String email,
    required String password,
}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
      );
      await result.user?.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);

    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    }on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case'user_not_found!':
        return 'No User Was Found With This Email';
      case 'wrong-password':
        return 'Wrong_password boi';
      case 'email_already_in_use':
        return 'An Account already exist with this email';
      case 'invalid-email':
        return 'The email address is invalid boi';
      case 'weak-password':
        return 'the password is weaker than you';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please Contact Support';
      case 'user-disabled':
        return 'This User account has been disabled';
        default:
          return 'An error occurred. Please try again';




    }
  }


}
