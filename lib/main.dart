import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_wise_saying/controllers/admob_controller.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  admobController.initMobileAds;
  runApp(
    App(),
  );
}
