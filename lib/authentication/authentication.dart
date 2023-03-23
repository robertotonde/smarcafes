import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthenticationService(FirebaseAuth instance);

  Stream<String> get authStateChanges =>
      _auth.authStateChanges().map((User? user) => user!.uid);

  //SIGNUP METHOD
  Future registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(name);
      // user.sendEmailVerification();
      await user.reload();
      user = auth.currentUser;
      return "SignedUp";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signInUsingEmailPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "SignedIn";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // SIGNOUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }

// REFRESH USER
  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  // GET CURRENT UID
  String getCurrentUID() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  // GET CURRENT USERNAME
  String getCurrentUname() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.reload();
    }
    user!.reload();
    return FirebaseAuth.instance.currentUser!.displayName.toString();
  }

// CHANGE USERNAME
  Future changeUsername({
    required String name,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    user = FirebaseAuth.instance.currentUser;
    await user!.updateDisplayName(name);
    // user.sendEmailVerification();
    user = auth.currentUser;
  }

// CHANGE DP
  Future changeDP({
    required String url,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    user = FirebaseAuth.instance.currentUser;
    await user!.updatePhotoURL(url);
    // user.sendEmailVerification();
    user = auth.currentUser;
  }

// GET DP
  String getDP() {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      user.reload();
    }
    return FirebaseAuth.instance.currentUser!.photoURL.toString();
    // user.sendEmailVerification();
  }

// FORGET PASSWORD
  Future<void> foregetPassword({
    required String email,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.sendPasswordResetEmail(email: email);
    // user.sendEmailVerification();
  }
}
