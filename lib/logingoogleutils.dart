import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

class LoginGoogleUtils {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken);

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    User? user = userCredential.user;
    return _isCurrentSignIn(user!);
  }

  Future<User?> _isCurrentSignIn(User user) async {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    return user;
  }
}
