import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common_import.dart';

class OnBoarding5 extends StatefulWidget {
  @override
  _OnBoarding5State createState() => _OnBoarding5State();
}

class _OnBoarding5State extends State<OnBoarding5> {
  var _flutterLocalNotificationsPlugin;

  AppData appData = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 81.w),
            child: Container(
              color: kBackgroundColor,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 374.h,
                  ),
                  SizedBox(
                    height: 87.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '나의 공명',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -4.5.sp,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 590.w,
                    height: 91.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '우측하단에 북마크를 활용하여\n나의 공명을 만들어보세요',
                        style: TextStyle(
                          fontSize: 35.sp,
                          letterSpacing: -2.63.sp,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 44.h),
                  FadeIn(
                    duration: Duration(seconds: 1),
                    child: Container(
                      child: Image.asset(
                        'assets/images/focus1.gif',
                        //width: 300.w,
                        //height: 300.h,
                      ),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 5.0,
                                spreadRadius: 3.0,
                                offset: Offset(5.0, 5.0)),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36.r)),
                      width: 572.w,
                      height: 509.h,
                    ),
                  ),
                  SizedBox(height: 195.h),
                  FadeIn(
                    duration: Duration(seconds: 2),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Get.height / 10),
                      child: Container(
                        width: 572.w,
                        height: 79.h,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.2),
                              blurRadius: 5.0,
                              spreadRadius: 5.0,
                              offset: Offset(5.0, 5.0)),
                        ], borderRadius: BorderRadius.circular(60.r)),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {});
                            appData.isStarted = true;
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            _prefs.setBool('isStarted', true);
                            Get.to(() => TodayScreen());
                          },
                          child: Text(
                            '지금부터 공명하기',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.sp,
                                letterSpacing: -2.1.sp),
                          ),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.r))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (_) => Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
