import '../../common_import.dart';

class OnBoarding3 extends StatefulWidget {
  @override
  _OnBoarding3State createState() => _OnBoarding3State();
}

class _OnBoarding3State extends State<OnBoarding3> {
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
                        '디데이 설정',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -4.5.sp,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 405.w,
                    height: 91.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '디데이를 설정하여\n공명으로 목표를 달성해보세요.',
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
                  //       '공명으로 목표를 달성해보세요.',
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
                        child: Image.asset('assets/images/jjal_02.gif',
                            fit: BoxFit.cover
                            //width: 300.w,
                            //height: 300.h,
                            ),
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 3.0,
                              spreadRadius: 3.0,
                              offset: Offset(5.0, 5.0)),
                        ],
                        color: Colors.white,
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
