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
                    height: 80.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      //curve: Curves.easeInOut,
                      child: Text(
                        '울림이 있는 공부 명언',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            wordSpacing: -7.5.w,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 512.w,
                    height: 50.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '공부시작 전, 공명을 켜고',
                        style: TextStyle(
                          fontSize: 35.sp,
                          wordSpacing: -7.5.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 590.w,
                    height: 50.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '명언 한 줄로 원하는 목표에 다가가세요.',
                        style: TextStyle(
                          fontSize: 35.sp,
                          wordSpacing: -7.5.w,
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
                          borderRadius: BorderRadius.circular(50.r)),
                      width: 572.w,
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
