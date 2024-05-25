import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    );

    
    User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await postDetailsToFirestore(user.uid, email, password);
      }
  }

   Future<void> postDetailsToFirestore(String userId, String email, String password) async {
      try {
        await _firestore.collection('users').doc(userId).set({
          'email': email, 'password': password
        });
      } catch (e) {
        // Handle Firestore errors
      }
    }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}