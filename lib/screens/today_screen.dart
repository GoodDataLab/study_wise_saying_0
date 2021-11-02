//import 'dart:html';
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:study_wise_saying/model/post.dart';
import '../common_import.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:path_provider/path_provider.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AppData appData = Get.find();

  bool administrator = true;
  TabController? _tabController;
  final int _currentIndex = 0;
  bool _isSelected = false;
  bool _isMySelected = false;
  bool _isBookMarkSelected = false;

  TextEditingController? _goalEditingController = TextEditingController();
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  ScreenshotController _screenshotController = ScreenshotController();
  ScreenshotController _lastScreenshotController = ScreenshotController();

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  DateTime now = DateTime.now();
  DateTime lastMonth = DateTime.now().subtract(Duration(days: 30));

  DateTime? selectedDay;
  int? diff;
  Post? _selectedPost;
  Post? _myselectedPost;

  final Stream<QuerySnapshot>? _postStream = FirebaseFirestore.instance
      .collection('post')
      .orderBy('id', descending: true)
      .snapshots();

  @override
  void initState() {
    _dateRangePickerController.displayDate =
        DateTime.tryParse(appData.currentSelectedDay.toString());

    _tabController = TabController(length: 3, vsync: this);

    String initGoal = appData.currentGoal ?? '';
    _goalEditingController = TextEditingController(text: initGoal);

    admobController.initBannerAd();
    admobController.initMediumRectangleAd();
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    _goalEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String postId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return GetBuilder(
      builder: (AppData appData) => WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                // 뒤로 가기 버튼 누를 시, 종료버튼, 취소버튼, 광고 출력
                return ExitApp();
              });
          return Future(() => false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0.h),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          backgroundColor: kBackgroundColor,
          //앱 하단부에 배너 광고 표시
          bottomNavigationBar: AdsBottom(),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 333.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(60.r))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //공부명언 로고 클릭 시, 오늘공명 화면 이동 후 출력
                    ClickonLogo(),
                    // 오늘공명 지난 공명 나의 공명 화면 이동 가능한 탭바
                    ClickonTabbar(context),
                    SizedBox(height: 41.h),
                    Padding(
                      padding: EdgeInsets.only(left: 46.w),
                      child: Row(
                        children: [
                          //작성한 목표를 확인 할 수 있음.
                          ShowGoal(appData),
                          SizedBox(width: 35.w),
                          // 캘린더를 통해 계산된 디데이 날짜를 확인 할 수 있음.
                          ShowDDay(),
                          SizedBox(width: 62.w),
                          Padding(
                            padding: EdgeInsets.only(top: 10.0.h),
                            child: GestureDetector(
                              onTap: () async {
                                await ShowCalendar(context, appData);
                                // await _showNotification();
                              },
                              child: SizedBox(
                                  width: 25.w,
                                  height: 25.h,
                                  child:
                                      Image.asset('assets/images/write1.png')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          SizedBox(height: 150.h),
                          // 오늘 공명
                          TodayCard(),
                          // SizedBox(height: 34.h),
                        ],
                      ),
                    ),
                    //지난 공명
                    Container(
                      color: kBackgroundColor,
                      child: Stack(
                        children: [
                          SwiperCard(),
                          Positioned(
                            bottom: 0.0.h,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 100),
                              opacity: _isSelected ? 1 : 0,
                              child: IgnorePointer(
                                ignoring: !_isSelected,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {});
                                    _isSelected = !_isSelected;
                                  },
                                  child: EnlargeLastCard(_selectedPost),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 나의 공명
                    Container(
                      child: Stack(
                        children: [
                          MyCard(postId, appData),
                          Positioned(
                            bottom: 0.0.h,
                            child: IgnorePointer(
                              ignoring: !_isMySelected,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: _isMySelected ? 1 : 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {});

                                    _isMySelected = !_isMySelected;
                                  },
                                  child: EnlargedMyCard(_myselectedPost),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container MyCard(String postId, AppData appData) {
    return Container(
      color: kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.all(30.0.r),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('post')
                .doc(postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (appData.savedPost.length == 0) {
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 380.h,
                      ),
                      Container(
                        height: 80.h,
                        width: 494.w,
                        child: Text('나의 공명을 채워주세요!',
                            style: GoogleFonts.notoSans(
                              fontSize: 55.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -5.sp,
                            )),
                      ),
                      Container(
                        height: 55.3.h,
                        child: Text('간직하고픈 공부명언을 스크랩하여',
                            style: GoogleFonts.notoSans(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.normal,
                              letterSpacing: -5.sp,
                            )),
                      ),
                      Container(
                        height: 55.3.h,
                        child: Text('울림이 있는 나의 공명을 채워보세요.',
                            style: GoogleFonts.notoSans(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -5.sp,
                            )),
                      )
                    ],
                  ),
                );
              }

              return AnimationLimiter(
                child: GridView.builder(
                    itemCount: appData.savedPost.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Post post = Post(
                        title: (snapshot.data!.data()
                            as Map<String, dynamic>)['title'],

                        subtitle: (snapshot.data!.data()
                            as Map<String, dynamic>)['subtitle'],

                        content: (snapshot.data!.data()
                            as Map<String, dynamic>)['content'],
                        // id: (snapshot.data?.data()
                        //     as Map<String, dynamic>)['id'],
                      );

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {});
                            _myselectedPost = post;
                            _isMySelected = !_isMySelected;
                          },
                          child: ScaleAnimation(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              height: 313.h,
                              width: 313.w,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36.r)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.w, top: 20.h, right: 20.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 70.h,
                                      ),
                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            child: Icon(Icons.person),
                                            radius: 15,
                                          ),
                                          SizedBox(width: 15.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        post.title.toString(),
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Container(
                                                        width: 20.w,
                                                        height: 20.h,
                                                        child: Image.asset(
                                                            'assets/images/pngkit_twitter-png_189183.png'),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                post.subtitle.toString(),
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 22.h),
                                      Flexible(
                                        child: Container(
                                          width: 220.w,
                                          height: 125.h,
                                          child: Text(
                                            post.content.toString(),
                                            style: TextStyle(fontSize: 20.sp),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }),
      ),
    );
  }

  Widget EnlargedMyCard(Post? post) {
    if (post == null) return Container();
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: 1100.h,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _isMySelected ? 1 : 0,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
              width: 654.w,
              height: 654.h,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.r)),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 64.w, top: 80.h, right: 64.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: null,
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      post.title.toString(),
                                      style: GoogleFonts.notoSans(
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -1.w,
                                          wordSpacing: 34.h),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 25.h,
                                      child: Image.asset(
                                          'assets/images/pngkit_twitter-png_189183.png'),
                                    ),
                                  ],
                                ),
                                Text(
                                  post.subtitle.toString(),
                                  style: GoogleFonts.notoSans(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1.w,
                                      wordSpacing: 34.h),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 320.h,
                          child: Text(post.content.toString(),
                              style: GoogleFonts.notoSans(
                                  fontSize: 25.sp,
                                  letterSpacing: -1.h,
                                  wordSpacing: 34.sp),
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(DateTime.now().toIso8601String()),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Color(0xFF777777))),
                            )),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Color(0xFF707070)),
                              ),
                              width: 50.w,
                              height: 50.h,
                              child: const Center(
                                  child: Icon(
                                Icons.share_outlined,
                                size: 20,
                              )
                                  // child: Image.asset(
                                  //     'assets/images/share_icon.png'),
                                  ),
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF707070))),
                              width: 50.w,
                              height: 50.h,
                              child: const Center(
                                  child: Icon(
                                Icons.file_download_outlined,
                                size: 20,
                              )
                                  //     'assets/images/save_icon.png'),
                                  ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF707070)),
                                ),
                                width: 50.w,
                                height: 50.h,
                                child: const Center(
                                  child: Icon(
                                    Icons.bookmark_border_outlined,
                                    size: 20,
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  ShowCalendar(BuildContext context, AppData appData) {
    showDialog(
        //useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) {
            return Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.r)),
                  child: Container(
                    width: 654.w,
                    height: 1000.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, top: 35.h),
                              child: Material(
                                child: Text('문구수정',
                                    style: GoogleFonts.notoSans(
                                        fontSize: 31.sp,
                                        backgroundColor: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Material(
                                  child: Container(
                                color: Colors.white,
                                child: TextFormField(
                                  maxLength: 12,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () async {
                                            setState(() {});
                                            _goalEditingController!.clear();

                                            SharedPreferences _prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            _prefs.setString('goal', '');
                                          },
                                          icon: Icon(Icons.clear))),
                                  controller: _goalEditingController,
                                  onChanged: (value) async {
                                    setState(() {});
                                    appData.currentGoal = value;
                                    SharedPreferences _prefs =
                                        await SharedPreferences.getInstance();
                                    _prefs.setString('goal', value);
                                  },
                                ),
                              )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w),
                              child: Material(
                                  child: Text('디데이 설정',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 31.sp,
                                        backgroundColor: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ))),
                            ),
                            SizedBox(height: 15.h),
                            SizedBox(
                              width: 654.w,
                              height: 600.h,
                              child: SfDateRangePicker(
                                  //showActionButtons: true,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  monthViewSettings:
                                      const DateRangePickerMonthViewSettings(
                                          dayFormat: 'EEE'),
                                  toggleDaySelection: true,
                                  allowViewNavigation: false,
                                  controller: _dateRangePickerController,
                                  initialDisplayDate: DateTime.now(),
                                  initialSelectedDate: DateTime.tryParse(
                                      appData.currentSelectedDay.toString()),
                                  onSelectionChanged:
                                      (DateRangePickerSelectionChangedArgs
                                          args) {
                                    SchedulerBinding.instance!
                                        .addPostFrameCallback(
                                            (timeStamp) async {
                                      setState(() {});
                                      appData.currentSelectedDay =
                                          DateFormat('yyyy-MM-dd')
                                              .format(args.value)
                                              .toString();

                                      SharedPreferences _prefsSelectedDay =
                                          await SharedPreferences.getInstance();
                                      _prefsSelectedDay.setString(
                                          'selectedDate',
                                          appData.currentSelectedDay
                                              .toString());
                                      print(appData.currentSelectedDay
                                          .toString());
                                    });
                                  }),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFF777777)),
                                            right: BorderSide(
                                                color: Color(0xFF777777)))),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {});
                                          _dateRangePickerController
                                              .displayDate = DateTime.now();
                                        },
                                        child: const Text(
                                          '오늘 날짜로',
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Color(0xFF777777)))),
                                    child: TextButton(
                                        onPressed: () async {
                                          setState(() {});
                                          DateTime currentDay = DateTime(
                                              now.year, now.month, now.day);

                                          appData.currentNow =
                                              DateFormat('yyyy-MM-dd ')
                                                  .format(DateTime.now());

                                          appData.currentDDay =
                                              _dateRangePickerController
                                                  .selectedDate!
                                                  .difference(currentDay)
                                                  .inDays;

                                          print(appData.currentNow);
                                          print(appData.currentDDay);

                                          SharedPreferences _prefsDDay =
                                              await SharedPreferences
                                                  .getInstance();
                                          _prefsDDay.setInt(
                                              'dDay', appData.currentDDay!);

                                          Get.back();
                                        },
                                        child: const Text('확 인')),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  Container TodayCard() {
    String postId =
        DateFormat("yyyy-MM-dd 00:00:00.000").format(DateTime.now());
    String formatted = DateFormat.yMMMd().format(DateTime.now());
    //print(postId);

    return Container(
      width: 654.w,
      height: 654.h,
      child: Screenshot(
        controller: _screenshotController,
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('post')
                .doc(postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                return Container();
              }
              if (!snapshot.hasData) return Container();

              // print(snapshot);
              // print(snapshot.data);
              // print(snapshot.data!.data());

              if (snapshot.data?.data() == null) {
                // print('null data');
                return Center(
                  child: Text('오늘은 명언이 없습니다.'),
                );
              }

              String title =
                  (snapshot.data!.data() as Map<String, dynamic>)['title'];
              String subtitle =
                  (snapshot.data!.data() as Map<String, dynamic>)['subtitle'];
              String content =
                  (snapshot.data!.data() as Map<String, dynamic>)['content'];
              //String id = (snapshot.data!.data() as Map<String, dynamic>)['id'];

              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.r)),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 64.w, top: 80.h, right: 64.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(title,
                                        style: GoogleFonts.notoSans(
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -1.sp,
                                          height: 1.0,
                                        )),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Container(
                                      width: 25.w,
                                      height: 25.h,
                                      child: Image.asset(
                                          'assets/images/pngkit_twitter-png_189183.png'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  subtitle,
                                  style: GoogleFonts.notoSans(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: -1.sp,
                                      height: 1.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 320.h,
                          width: 356.w,
                          child: Text(content,
                              style: GoogleFonts.notoSans(
                                fontSize: 25.sp,
                                letterSpacing: -1.13.sp,
                                height: 1.3,
                              ),
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${formatted}',
                              style: GoogleFonts.notoSans(
                                fontSize: 25.sp,
                                letterSpacing: -1.13.sp,
                                height: 1.0,
                              ),
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Color(0xFF777777))),
                            )),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final imageSave =
                                    await _screenshotController.capture();
                                saveAndShare(imageSave);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF707070)),
                                ),
                                width: 55.w,
                                height: 55.h,
                                child:
                                    Center(child: Icon(Icons.share_outlined)),
                              ),
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final imageSave =
                                    await _screenshotController.capture();
                                if (imageSave == null) {}
                                await saveImage(imageSave);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Color(0xFF707070))),
                                width: 55.w,
                                height: 55.h,
                                child: Center(
                                    child: Icon(Icons.file_download_outlined)),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  appData.isBookMarked = !appData.isBookMarked;

                                  // appData.isBookMarked
                                  // ? databaseController.getPost(
                                  //     postId: postId)
                                  // : databaseController.deletePost(
                                  //     postId: postId);
                                });

                                SharedPreferences _prefsPostId =
                                    await SharedPreferences.getInstance();
                                _prefsPostId.setBool(
                                    'myPostId', appData.isBookMarked);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFF707070)),
                                ),
                                width: 55.w,
                                height: 55.h,
                                child: Center(
                                    child: Icon(appData.isBookMarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_outlined)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  color: Colors.white);
            }),
      ),
    );
  }

  Widget EnlargeLastCard(Post? post) {
    if (post == null) return Container();
    DateTime? formattedId = DateTime.tryParse(post.id.toString());
    String formattedPostId = DateFormat.yMMMd().format(formattedId!);
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: 1100.h,
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _isSelected ? 1 : 0,
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
              width: 654.w,
              height: 654.h,
              child: Screenshot(
                controller: _lastScreenshotController,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.r)),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 64.w, top: 80.h, right: 64.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 15.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        post.title.toString(),
                                        style: GoogleFonts.notoSans(
                                            fontSize: 23.sp,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: -1.sp,
                                            height: 1.2),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Container(
                                        width: 25.w,
                                        height: 25.h,
                                        child: Image.asset(
                                            'assets/images/pngkit_twitter-png_189183.png'),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    post.subtitle.toString(),
                                    style: GoogleFonts.notoSans(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: -1.sp,
                                        height: 1.2),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            height: 320.h,
                            width: 356.w,
                            child: Text(post.content.toString(),
                                style: GoogleFonts.notoSans(
                                    fontSize: 25.sp,
                                    letterSpacing: -1.sp,
                                    height: 1.2),
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(formattedPostId),
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xFF777777))),
                              )),
                          SizedBox(
                            height: 12.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final imageSave =
                                      await _lastScreenshotController.capture();
                                  saveAndShare(imageSave);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Color(0xFF707070)),
                                  ),
                                  width: 55.w,
                                  height: 55.h,
                                  child: Center(
                                    child: Icon(Icons.share_outlined),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 11.w,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final imageSave =
                                      await _lastScreenshotController.capture();
                                  if (imageSave == null) {}
                                  await saveImage(imageSave);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Color(0xFF707070))),
                                  width: 55.w,
                                  height: 55.h,
                                  child: Center(
                                      child:
                                          Icon(Icons.file_download_outlined)),
                                ),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Color(0xFF707070)),
                                  ),
                                  width: 55.w,
                                  height: 55.h,
                                  child: Center(
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          icon: Icon(Icons
                                              .bookmark_border_outlined)))),
                            ],
                          )
                        ],
                      ),
                    ),
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SwiperCard() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _postStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Container();
            if (!snapshot.hasData) return Container();
            if (snapshot.data?.size == 0) return Container();

            return Swiper(
              itemCount: snapshot == 30 ? 30 : snapshot.data!.docs.length,
              itemWidth: 600.w,
              itemHeight: 600.h,
              scrollDirection: Axis.vertical,
              layout: SwiperLayout.STACK,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = snapshot.data!.docs
                    .elementAt(index)
                    .data() as Map<String, dynamic>;
                Post post = Post.fromJson(data);

                String title = post.title ?? '';
                String subtitle = post.subtitle ?? '';
                String content = post.content ?? '';

                return GestureDetector(
                  onTap: () {
                    setState(() {});
                    _selectedPost = post;
                    _isSelected = !_isSelected;
                  },
                  child: Container(
                    decoration: BoxDecoration(boxShadow: const [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                      ),
                    ], borderRadius: BorderRadius.circular(10.0)),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 64.w, top: 80.h, right: 64.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                SizedBox(width: 15.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.notoSans(
                                              fontSize: 23.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -1.sp,
                                              height: 1.1),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Container(
                                          width: 25.w,
                                          height: 25.h,
                                          child: Image.asset(
                                              'assets/images/pngkit_twitter-png_189183.png'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      subtitle,
                                      style: GoogleFonts.notoSans(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: -1.sp,
                                          height: 1.1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 22.h),
                            Container(
                              width: 356.w,
                              height: 320.h,
                              child: Text(
                                content,
                                style: GoogleFonts.notoSans(
                                    fontSize: 25.sp,
                                    letterSpacing: -1.sp,
                                    height: 1.2),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 8,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  SizedBox ShowDDay() {
    return SizedBox(
      width: 135.w,
      child: Text(
        appData.currentSelectedDay == null ||
                appData.currentDDay == 0 ||
                appData.currentDDay! <= 0
            ? 'D-000'
            : 'D-${appData.currentDDay}',
        style: TextStyle(fontSize: 35.sp),
      ),
    );
  }

  SizedBox ShowGoal(AppData appData) {
    return SizedBox(
      width: 397.w,
      child: Text(
        _goalEditingController!.text == ''
            ? '목표를 작성해주세요.'
            : appData.currentGoal.toString(),
        style: TextStyle(
            fontSize: 35.sp,
            fontWeight: FontWeight.bold,
            color: _goalEditingController!.text == ''
                ? Colors.grey[400]
                : Colors.black),
      ),
    );
  }

  Padding ClickonTabbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Stack(
        children: [
          Positioned(
              //top: 10,
              bottom: 0.5,
              child: Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: 1,
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TabBar(
              padding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.only(right: 20.w),
              labelColor: Colors.black,
              labelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 35.sp),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.normal, fontSize: 35.sp),
              isScrollable: true,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              labelPadding: EdgeInsets.only(right: 20.w),
              tabs: const [
                Tab(text: '오늘공명'),
                Tab(text: '지난공명'),
                Tab(text: '나의공명'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding ClickonLogo() {
    return Padding(
      padding: EdgeInsets.only(left: 30.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _tabController!.animateTo(_currentIndex);
            },
            child: SizedBox(
                width: 148.w,
                height: 90.h,
                child: Image.asset('assets/images/logo_small.png')),
          ),
          const Spacer(),
          administrator
              ? IconButton(
                  onPressed: () {
                    Get.to(() => const AdminScreen());
                  },
                  icon:
                      const Icon(Icons.admin_panel_settings, color: Colors.red),
                  color: Colors.black,
                )
              : const Icon(null),
        ],
      ),
    );
  }

//   Future _dailyAtTimeNotification() async {
//     var time = Time(02, 31, 0);
//     var android = AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max, priority: Priority.high);

//     var ios = IOSNotificationDetails();
//     var detail = NotificationDetails(iOS: ios);

//     await _flutterLocalNotificationsPlugin.showDailyAtTime(
//       0,
//       '공명',
//       '오늘의 공명을 확인하세요!',
//       time,
//       detail,
//       payload: 'Hello Flutter',
//     );
//   }
// }

  Future saveAndShare(Uint8List? bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageSave = File('${directory.path}/flutter.png');

    imageSave.writeAsBytesSync(bytes!);
    await Share.shareFiles([imageSave.path]);
  }

  Future<String> saveImage(Uint8List? bytes) async {
    await [Permission.storage].request();

    final time = DateTime.now().toIso8601String();
    final name = 'screenShot_$time';
    final result = await ImageGallerySaver.saveImage(bytes!, name: name);

    return result['filePath'];
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

class AdsBottom extends StatelessWidget {
  // const AdsBottom({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kBackgroundColor,
        width: MediaQuery.of(context).size.width,
        height: 100.h,
        child: admobController.createBannerAd());
  }
}

class ExitApp extends StatelessWidget {
  // const ExitApp({
  //   Key? key,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter stateSetter) {
        return Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36.r)),
              width: 654.w,
              height: 700.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  SizedBox(
                      width: 654.w,
                      height: 508.h,
                      //color: Colors.red,
                      child: admobController.createMediumAd()),
                  // SizedBox(
                  //   height: 12.h,
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Color(0xFF777777)),
                                  right: BorderSide(color: Color(0xFF777777)))),
                          child: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                '취소',
                              )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Color(0xFF777777)))),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text('종료')),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        );
      }),
    );
  }
}
