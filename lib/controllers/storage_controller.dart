// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// FirebaseStorageController firebaseStorageController =
//     FirebaseStorageController();
//
// class FirebaseStorageController {
//   Future<String?> uploadFile(
//       {required String filePath, required String uploadPath}) async {
//     File file = File(filePath);
//
//     try {
//       var task = await FirebaseStorage.instance.ref(uploadPath).putFile(file);
//
//       return await task.ref.getDownloadURL();
//     } on FirebaseException catch (e) {
//       print(e.code);
//     }
//   }
//
//   deleteFile(String url) async {
//     try {
//       await FirebaseStorage.instance.refFromURL(url).delete();
//     } on FirebaseException catch (e) {
//       print(e.code);
//     }
//   }
// }
