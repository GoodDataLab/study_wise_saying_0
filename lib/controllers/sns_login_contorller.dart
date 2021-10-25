// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:flutter_template/common_import.dart';
//
// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth =
//       await googleUser!.authentication;
//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//   AppData appData = Get.find();
//   appData.accessToken = googleAuth.accessToken;
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }
//
// Future<UserCredential> signInWithFacebook() async {
//   // Trigger the sign-in flow
//   final LoginResult result = await FacebookAuth.instance.login();
//
//   // Create a credential from the access token
//   final facebookAuthCredential =
//       FacebookAuthProvider.credential(result.accessToken!.token);
//
//   AppData appData = Get.find();
//   appData.accessToken = result.accessToken!.token;
//
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance
//       .signInWithCredential(facebookAuthCredential);
// }
//
// Future<UserCredential> signInWithApple() async {
//   // Request credential for the currently signed in Apple account.
//   final appleCredential = await SignInWithApple.getAppleIDCredential(
//     scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ],
//   );
//
//   // Create an `OAuthCredential` from the credential returned by Apple.
//   final oauthCredential = OAuthProvider("apple.com").credential(
//     idToken: appleCredential.identityToken,
//     accessToken: appleCredential.authorizationCode,
//   );
//
//   AppData appData = Get.find();
//   appData.accessToken = appleCredential.authorizationCode;
//
//   // Sign in the user with Firebase. If the nonce we generated earlier does
//   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
//   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
// }
