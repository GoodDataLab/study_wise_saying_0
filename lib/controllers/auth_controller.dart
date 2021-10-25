// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_login/flutter_login.dart';
// import 'package:get/get.dart';

// import '../common_import.dart';
// import 'local_storage_controller.dart';

// AuthController authController = AuthController();

// class AuthController {
//   Future<String?> authUserByEmail(LoginData data) async {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         log('[authStateChanges]User is currently signed out!');
//       } else {
//         log('[authStateChanges]User is signed in!');
//       }
//     });

//     FirebaseAuth.instance.idTokenChanges().listen((User? user) {
//       if (user == null) {
//         log('[idTokenChanges]User is currently signed out!');
//       } else {
//         log('[idTokenChanges]User is signed in!');
//       }
//     });

//     FirebaseAuth.instance.userChanges().listen((User? user) {
//       if (user == null) {
//         log('[userChanges]User is currently signed out!');
//       } else {
//         log('[userChanges]User is signed in!');
//       }
//     });

//     try {
//       print('start');
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: data.name,
//         password: data.password,
//       );

//       AppData appData = Get.find();
//       appData.userEmail = userCredential.user?.email ?? 'null';
//       localStorageController.setUserEmail(appData.userEmail);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//         return '이메일을 다시 확인해주세요.';
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//         return '패스워드를 다시 확인해주세요.';
//       } else {
//         print(e);
//         return e.toString();
//       }
//     }

//     return null;
//   }

//   Future<bool?> checkIfEmailInUse(String email) async {
//     try {
//       // Fetch sign-in methods for the email address
//       final list =
//           await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

//       // In case list is not empty
//       if (list.isNotEmpty) {
//         // Return true because there is an existing
//         // user using the email address
//         return true;
//       } else {
//         // Return false because email adress is not in use
//         return false;
//       }
//     } catch (error) {
//       // Handle error
//       // ...
//       return true;
//     }
//   }

//   Future<String?> registerUserByEmail(LoginData data) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: data.name,
//         password: data.password,
//       );
//       AppData appData = Get.find();
//       appData.userEmail = userCredential.user?.email ?? 'null';
//       localStorageController.setUserEmail(appData.userEmail);
//       return null;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//         return 'The password provided is too weak.';
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//         return 'The account already exists for that email.';
//       }
//     } catch (e) {
//       print(e);
//       return e.toString();
//     }
//   }

//   Future<Null> handleSignOut() async {
//     await localStorageController.setUserEmail('');
//     await FirebaseAuth.instance.signOut();
//   }
// }
