import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: '425476392775-ljfj8his4vesj5k26eg7cio3qs5uaafu.apps.googleusercontent.com',
    // Use redirect instead of popup to avoid COOP issues
    signInOption: SignInOption.standard,
  );

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => _auth.currentUser != null;

  // Get ID token for API calls
  static Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Sign in with Google using redirect (more compatible with COOP policies)
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Try popup first, then redirect as fallback
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');
      
      try {
        print('Trying popup method...');
        return await _auth.signInWithPopup(googleProvider);
      } catch (popupError) {
        print('Popup failed, trying redirect: $popupError');
        // Redirect doesn't return a result immediately - it redirects the page
        await _auth.signInWithRedirect(googleProvider);
        return null; // Will be handled by redirect result check
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }
  
  // Check for redirect result on app startup
  static Future<UserCredential?> getRedirectResult() async {
    try {
      return await _auth.getRedirectResult();
    } catch (e) {
      print('No redirect result: $e');
      return null;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Listen to auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
}