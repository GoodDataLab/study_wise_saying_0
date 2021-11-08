import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';

import 'common_import.dart';
import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Get.put(AppData());

    return ScreenUtilInit(
      designSize: Size(750, 1624),
      builder: () => GetMaterialApp(
        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        title: 'FlynnApps',
        home: SplashScreen(),
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          primarySwatch: createMaterialColor(kPrimaryColor),
          fontFamily: 'NotoSans',
        ),
        builder: (BuildContext? context, Widget? child) {
          // 기기 내 텍스트 크기설정을 무시하기 위한 코드
          if (context == null) {
            return Container();
          } else {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? Container(),
            );
          }
        },
      ),
    );
  }
}

// todo: firebase 적용 시 위 내용 삭제하고 아래 내용 적용
// class App extends StatefulWidget {
//   // Create the initialization Future outside of `build`:
//   @override
//   _AppState createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   /// The future is part of the state of our widget. We should not call `initializeApp`
//   /// directly inside [build].
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(AppData());
//     return FutureBuilder(
//       // Initialize FlutterFire:
//       future: _initialization,
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return _somethingWentWrong();
//         }
//
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return ScreenUtilInit(
//             designSize: Size(180, 380),
//             builder: () => GetMaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'FlynnApps',
//               home: SplashScreen(),
//               theme: ThemeData(
//                 primaryColor: kPrimaryColor,
//                 primarySwatch: createMaterialColor(kPrimaryColor),
//                 fontFamily: 'NotoSans',
//               ),
//               builder: (BuildContext? context, Widget? child) {
//                 // 기기 내 텍스트 크기설정을 무시하기 위한 코드
//                 if (context == null) {
//                   return Container();
//                 } else {
//                   return MediaQuery(
//                     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//                     child: child ?? Container(),
//                   );
//                 }
//               },
//             ),
//           );
//         }
//
//         // Otherwise, show something whilst waiting for initialization to complete
//         return _firebaseLoading();
//       },
//     );
//   }
//
//   Widget _somethingWentWrong() {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child:
//               Text('The app cannot run because the database is not working.'),
//         ),
//       ),
//     );
//   }
//
//   Widget _firebaseLoading() {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: SizedBox(
//             width: 50,
//             height: 50,
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//   }
// }
