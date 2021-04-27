import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseUser _user;

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> loginEmailPassword(
      String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser firebaseUser = result.user;
      if (firebaseUser == null) {
        print("user kosong");
      }
      return firebaseUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<String> createUserWithEmailAndPassword(
      String nama, String email, String password) async {
    try {
      final currentUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nama;

      _user = currentUser.user;

      _user = await _auth.currentUser();
      await currentUser.user.updateProfile(userUpdateInfo);
      await currentUser.user.reload();
      return currentUser.user.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<FirebaseUser> get firebaseUserStream =>
      _auth.onAuthStateChanged;
}
