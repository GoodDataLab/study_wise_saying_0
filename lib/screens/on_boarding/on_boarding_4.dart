import '../../common_import.dart';

class OnBoarding4 extends StatefulWidget {
  @override
  _OnBoarding4State createState() => _OnBoarding4State();
}

class _OnBoarding4State extends State<OnBoarding4> {
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
                        '지난 공명',
                        style: TextStyle(
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -4.5.sp,
                            height: 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 573.w,
                    height: 91.h,
                    child: FadeIn(
                      duration: Duration(seconds: 3),
                      child: Text(
                        '오른쪽으로 넘기면 지난 공명을 볼 수 있어요.\n명언은 30개까지 볼 수 있습니다.',
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
                  //       '명언은 30개까지 볼 수 있습니다.',
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
                      child: Image.asset(
                        'assets/images/third.gif',
                        fit: BoxFit.fitHeight,
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
                        //borderRadius: BorderRadius.circular(36.r),
                      ),
                      // width: 572.w,
                      // height: 509.h,
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
