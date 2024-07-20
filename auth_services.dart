import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signinWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential usercredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return usercredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signupWithEmailPassword(
      String email, String password, String role) async {
    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user email and role in Firestore
      await FirebaseFirestore.instance
          .collection('Roles')
          .doc(userCredential.user?.email)
          .set({
        'email': email,
        'role': role,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signout() async {
    return await _firebaseAuth.signOut();
  }
}
