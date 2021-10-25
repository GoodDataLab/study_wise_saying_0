import '../common_import.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {
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
                  Text(
                    '울림이 있는 공부 명언',
                    style:
                        TextStyle(fontSize: 60.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '공부시작 전, 공명을 켜고',
                    style: TextStyle(fontSize: 35.sp),
                  ),
                  Text(
                    '명언 한 줄로 원하는 목표에 다가가세요.',
                    style: TextStyle(fontSize: 35.sp),
                  ),
                  SizedBox(height: 44.h),
                  Container(
                    child: Image.asset(
                      'assets/images/focus1.gif',
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.r)),
                    width: 572.w,
                    height: 509.h,
                  ),
                  SizedBox(height: 185.h),
                  Container(
                    width: 572.w,
                    height: 79.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.r)),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => TodayScreen());
                      },
                      child: Text(
                        '지금부터 공명하기',
                        style: TextStyle(color: Colors.black, fontSize: 40.sp),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.r))),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (_) => Colors.white)),
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
