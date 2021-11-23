import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:study_wise_saying/controllers/local_storage_controller.dart';
import 'package:study_wise_saying/controllers/nofitication_service.dart';
import 'package:study_wise_saying/model/post.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  //late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();

  @override
  void initState() {
    super.initState();

    NotificationService().requestIOSPermissions();
    //NotificationService().everyAtTimeNotification();
    NotificationService().ScheduleTimeNotification();

    _getLocalData();

    Future.delayed(Duration(milliseconds: 6000)).then((value) =>
        Get.off(() => appData.isStarted ? TodayScreen() : OnBoardingScreen()));
    super.initState();
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
            delayStart: Duration(milliseconds: 1000),
            animationDuration: Duration(milliseconds: 4000),
            curve: Curves.easeIn,
            direction: Direction.vertical,
            offset: 0.0,
          ),
        ),
      );
    });
  }

  Future<void> _getLocalData() async {
    AppData appData = Get.find();
    SharedPreferences instance = await SharedPreferences.getInstance();

    String? goal = instance.getString('goal');
    String? selectedDate = instance.getString('selectedDate');
    DateTime today = DateTime.now();

    //bool isStarted = instance.getBool('isStarted') ?? false;
    bool isStarted = false;
    bool myPostId = instance.getBool('myPostId') ?? false;
    List<String> savedIds = await localStorageController.getSavedPostIds();
    appData.updateSavedPostsByIds(savedIds);
    // instance.remove('savedPost');

    //print(now);

    if (goal == null) {
      //print('ssss');
      // do nothing
    } else {
      AppData appData = Get.find();
      appData.currentGoal = goal;
      //print('aaaaa');
    }

    if (isStarted == false) {
      //do notjing
    } else {
      AppData appData = Get.find();
      appData.isStarted = isStarted;
    }

    // if (myPostId == false) {
    //   //do noting
    // } else {
    //   AppData appData = Get.find();
    //   appData.isBookMarked = myPostId;
    // }
    // if (postMyId == null) {
    //   //do notiing
    // } else {
    //   AppData appData=Get.find();
    //   appData.savedPost.id = postMyId;

    // }

    // if (dDay == null) {
    //   // do nothing
    // } else {
    //   AppData appData = Get.find();
    //   appData.currentDDay = dDay;
    //   print(dDay);
    // }

    // AppData appData = Get.find();
    // appData.currentNow = now;
    // print(now);

    if (selectedDate == null) {
      AppData appData = Get.find();
      appData.currentSelectedDay = DateTime.now().toString();
    } else {
      AppData appData = Get.find();
      appData.currentNow = DateTime(today.year, today.month, today.day);
      appData.currentDDay =
          DateTime.parse(selectedDate).difference(appData.currentNow!).inDays;

      appData.currentSelectedDay = selectedDate;
      print(appData.currentNow);

      print(selectedDate);
    }
  }
}
