import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Get current user
  User? get currentUser => _auth.currentUser;

  //Register with email and password

  Future<User?> registerUser(String email, String password) async {
    try {
      // ignore: non_constant_identifier_names, unused_local_variable
      var UserCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // ignore: prefer_typing_uninitialized_variables
      var userCredential;
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
