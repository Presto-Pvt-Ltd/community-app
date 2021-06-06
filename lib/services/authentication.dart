import 'package:firebase_auth/firebase_auth.dart';
import 'package:presto/app/app.locator.dart';
import 'package:presto/app/app.logger.dart';
import 'package:presto/services/error/error.dart';

class AuthenticationService {
  final log = getLogger('AuthenticationService');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ErrorHandlingService _errorHandlingService =
      locator<ErrorHandlingService>();

  /// getter for user [uid]
  String? get uid => _auth.currentUser?.uid;
  FirebaseAuth get auth => _auth;
  String? get referralCode => _auth.currentUser?.displayName;

  Future<void> setDisplayName(String referralCode) async {
    await _auth.currentUser?.updateProfile(displayName: referralCode);
  }

  /// Signing the user using email and password

  Future<User?> signInViaEmailAndPassword(String email, String password) async {
    try {
      log.d("Attempting to Sign-in");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log.d("Sign-in success");
      return userCredential.user;
    } catch (e) {
      log.e(e.toString());
      _errorHandlingService.handleError(error: e);
    }
  }

  Future<User?> registerNewUser(String email, String password) async {
    try {
      log.d("Attempting to register user");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log.d("User registration success");
      return userCredential.user;
    } catch (e) {
      log.e("User Registration failed");
      _errorHandlingService.handleError(error: e);
    }
  }

  Future<User?> linkPhoneNumberWithEmail(
      PhoneAuthCredential phoneCredentials) async {
    try {
      log.d("Attempting to link phone with email");
      UserCredential userCredential =
          await _auth.currentUser!.linkWithCredential(phoneCredentials);
      log.d("Linking success");
      return userCredential.user;
    } catch (e) {
      log.e("Linking process failed");
      _errorHandlingService.handleError(error: e);
    }
  }

  Future<bool> deleteUser() async {
    return await _auth.currentUser!.delete().then((value) {
      _auth.signOut();
      return true;
    }).onError((error, stackTrace) {
      log.e("There was error here");
      _errorHandlingService.handleError(error: error);
      return false;
    });
  }

  Future<bool> sendResetPasswordLink({required String email}) async {
    try {
      return _auth.sendPasswordResetEmail(email: email).then((value) => true);
    } catch (e) {
      _errorHandlingService.handleError(error: e);
      return false;
    }
  }
}
