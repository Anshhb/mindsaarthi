import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  final _auth = FirebaseAuth.instance;

  Future<(bool, String)> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return (true, "Login successful");
    } on FirebaseAuthException catch (e) {
      return (false, e.message ?? "Login failed");
    } catch (e) {
      return (false, "Something went wrong");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<(bool, String)> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        "signupMethod": "Email",
      }, SetOptions(merge: true));
      return (true, "Account created successfully");
    } on FirebaseAuthException catch (e) {
      return (false, e.message ?? "Signup failed");
    } catch (e) {
      return (false, "Something went wrong");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<(bool, String)> signUpWithGoogle() async {
    state = state.copyWith(isLoading: true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return (false, "Google signin cancelled");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      // Check if user already exists
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "email": user.email,
        "name": user.displayName ?? "",
        "createdAt": FieldValue.serverTimestamp(),
        "signupMethod": "Google",
      }, SetOptions(merge: true));

      return (true, "Account created successfully");
    } catch (e) {
      return (false, "Google signin failed: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
