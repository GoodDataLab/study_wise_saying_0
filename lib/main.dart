import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_wise_saying/controllers/admob_controller.dart';
import 'package:study_wise_saying/controllers/nofitication_service.dart';
import 'app.dart';
import 'common_import.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  admobController.initMobileAds;
  await NotificationService().init();
  //print('!@#');
  //runApp(
  // DevicePreview(enabled: !kReleaseMode, builder: (context) => App()),
  // Wrap your app
  // );
  runApp(App());
}
