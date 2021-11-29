import '../../common_import.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

class OnBoarding2 extends StatefulWidget {
  const OnBoarding2({Key? key}) : super(key: key);

  @override
  _OnBoarding2State createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
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
                      //curve: Curves.easeInOut,
                      child: Text(
                        '울림이 있는 공부 명언',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -4.5.sp,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 509.w,
                    height: 91.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '공부 시작 전, 공명을 켜고\n명언 한 줄로 원하는 목표에 다가가세요.',
                        style: TextStyle(
                          fontSize: 35.sp,
                          letterSpacing: -2.63.sp,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 590.w,
                  //   height: 50.h,
                  //   child: FadeIn(
                  //     duration: Duration(seconds: 3),
                  //     child: Text(
                  //       '명언 한 줄로 원하는 목표에 다가가세요.',
                  //       style: TextStyle(
                  //         fontSize: 35.sp,
                  //         wordSpacing: -7.5.w,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 44.h),
                  FadeIn(
                    duration: Duration(seconds: 1),
                    child: Container(
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/jjal_01.gif',
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            blurRadius: 3.0,
                            spreadRadius: 3.0,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      width: 552.w,
                      height: 509.h,
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
