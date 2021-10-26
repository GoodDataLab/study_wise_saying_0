import 'dart:async';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';

import 'onboading_screen.dart';
import 'package:show_up_animation/show_up_animation.dart';

import 'login_screen.dart';

import '../common_import.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _getLocalData();
    Future.delayed(Duration(milliseconds: 5000))
        .then((value) => Get.off(() => OnBoardingScreen()));
  }

  AppData appData = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (AppData appData) {
      return Scaffold(
        body: Center(
          child: ShowUpAnimation(
            child: SizedBox(
              width: Get.width / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo_1x.png'),
                ],
              ),
            ),
            delayStart: Duration(milliseconds: 000),
            animationDuration: Duration(milliseconds: 3000),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.0,
          ),
        ),
      );
    });
  }

  Future<void> _getLocalData() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    String? goal = instance.getString('goal');
    int? dDay = instance.getInt('dDay');
    String? now =
        instance.getString('now'); //DateFormat('yyyy-MM-dd 00:00:00.000')
    //.format(DateTime.now());
    String? selectedDay = instance.getString('selectedDate');

    if (goal == null) {
      // do nothing
    } else {
      AppData appData = Get.find();
      appData.currentGoal = goal;
    }

    if (dDay == null) {
      // do nothing
    } else {
      AppData appData = Get.find();
      appData.currentDDay = dDay;
      print(dDay);
    }

    if (now == null) {
      //do noting
    } else {
      AppData appData = Get.find();
      appData.currentNow = now;
      print(now);
    }

    if (selectedDay == null) {
    } else {
      AppData appData = Get.find();
      appData.currentSelectedDay = selectedDay;
      print(selectedDay);
    }
  }
}
