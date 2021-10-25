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
//import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
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
    with SingleTickerProviderStateMixin {
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

  DateTime now = DateTime.now();
  String formattedNow = DateFormat.jm().add_yMMMd().format(DateTime.now());
  DateTime? selectedDay;
  int? diff;
  Post? _selectedPost;
  Post? _myselectedPost;

  final Stream<QuerySnapshot>? _postStream = FirebaseFirestore.instance
      .collection('post')
      .orderBy('dateCreated', descending: true)
      .snapshots();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    String initGoal = appData.currentGoal ?? '';
    _goalEditingController = TextEditingController(text: initGoal);

    admobController.initBannerAd();
    admobController.initMediumRectangleAd();
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _goalEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String postId =
        DateFormat('yyyy-MM-dd 00:00:00.000').format(DateTime.now());
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
                          SizedBox(height: 34.h),
                        ],
                      ),
                    ),
                    //지난 공명
                    Container(
                      color: kBackgroundColor,
                      child: Stack(
                        children: [
                          SwiperCard(appData),
                          IgnorePointer(
                            ignoring: !_isSelected,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 100),
                              opacity: _isSelected ? 1 : 0,
                              child: Positioned(
                                  bottom: 0.0.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                      _isSelected = !_isSelected;
                                    },
                                    child: EnlargeLastCard(_selectedPost),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    // 나의 공명
                    Container(
                      color: kBackgroundColor,
                      child: Stack(
                        children: [
                          Container(
                            color: kBackgroundColor,
                            child: Padding(
                              padding: EdgeInsets.all(30.0.r),
                              child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('post')
                                      .doc(postId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    return AnimationLimiter(
                                      child: GridView.builder(
                                          itemCount: appData.savedPost.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          itemBuilder: (context, index) {
                                            Post post = Post(
                                                title: (snapshot.data!.data()
                                                    as Map<String,
                                                        dynamic>)['title'],
                                                subtitle: (snapshot.data!.data()
                                                    as Map<String,
                                                        dynamic>)['subtitle'],
                                                content: (snapshot.data!.data()
                                                    as Map<String,
                                                        dynamic>)['content']);
                                            if (post == null)
                                              return Container();

                                            return AnimationConfiguration
                                                .staggeredGrid(
                                              position: index,
                                              columnCount: 2,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {});
                                                  _myselectedPost = post;
                                                  _isMySelected =
                                                      !_isMySelected;
                                                },
                                                child: ScaleAnimation(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  child: Container(
                                                    height: 313.h,
                                                    width: 313.w,
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          36.r)),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.w,
                                                                top: 20.h,
                                                                right: 20.w),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 70.h,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const CircleAvatar(
                                                                  child: null,
                                                                  radius: 15,
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        15.w),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          '',
                                                                          style: TextStyle(
                                                                              fontSize: 18.sp,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .star_border_purple500_outlined,
                                                                          size:
                                                                              15,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      '',
                                                                      style: TextStyle(
                                                                          fontSize: 18
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 22.h),
                                                            Text(
                                                              '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.sp),
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: _isMySelected ? 1 : 0,
                            child: IgnorePointer(
                              ignoring: !_isMySelected,
                              child: Positioned(
                                  bottom: 0.h,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                      _isMySelected = !_isMySelected;
                                    },
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 1100.h,
                                        child: Center(
                                          child: AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 700),
                                            opacity: _isMySelected ? 1 : 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              width: 654.w,
                                              height: 654.h,
                                              child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              36.r)),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 64.w,
                                                        top: 80.h,
                                                        right: 64.w),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const CircleAvatar(
                                                              child: null,
                                                            ),
                                                            SizedBox(
                                                                width: 15.w),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(''),
                                                                Text(''),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        Container(
                                                          height: 320.h,
                                                          child: Text('',
                                                              maxLines: 8,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        SizedBox(
                                                          height: 20.h,
                                                        ),
                                                        Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Text(
                                                                '${formattedNow}'),
                                                            decoration:
                                                                const BoxDecoration(
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                            )),
                                                        SizedBox(
                                                          height: 12.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              width: 50.w,
                                                              height: 50.h,
                                                              child: const Center(
                                                                  child: Icon(
                                                                Icons
                                                                    .share_outlined,
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
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black)),
                                                              width: 50.w,
                                                              height: 50.h,
                                                              child: const Center(
                                                                  child: Icon(
                                                                Icons
                                                                    .file_download_outlined,
                                                                size: 20,
                                                              )
                                                                  //     'assets/images/save_icon.png'),
                                                                  ),
                                                            ),
                                                            SizedBox(
                                                              width: 12.w,
                                                            ),
                                                            Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                width: 50.w,
                                                                height: 50.h,
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .bookmark_border_outlined,
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
                                    ),
                                  )),
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

  ShowCalendar(BuildContext context, AppData appData) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter stateSetter) {
              return Center(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36.r)),
                    width: 654.w,
                    height: 1000.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
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
                            height: 615.h,
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
                              initialDisplayDate: DateFormat('yyyy-MM-dd')
                                  .parse(appData.currentSelectedDay!),
                              initialSelectedDate: DateFormat('yyyy-MM-dd')
                                  .parse(appData.currentSelectedDay!),
                            ),
                          ),
                          SizedBox(height: 7.h),
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
                                        _dateRangePickerController.displayDate =
                                            DateTime.now();
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

                                        selectedDay = _dateRangePickerController
                                            .selectedDate;

                                        appData.currentNow = DateFormat(
                                                'yyyy-MM-dd 00:00:00.000')
                                            .format(currentDay);

                                        appData.currentSelectedDay = DateFormat(
                                                'yyyy-MM-dd 00:00:00.000')
                                            .format(selectedDay ?? currentDay);

                                        SharedPreferences _prefsNow =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefsNow.setString('now',
                                            appData.currentNow.toString());

                                        SharedPreferences _prefsSelectedDay =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefsSelectedDay.setString(
                                            'selectedDate',
                                            appData.currentSelectedDay
                                                .toString());

                                        if (selectedDay == null) {
                                          appData.currentSelectedDay =
                                              appData.currentNow;

                                          appData.currentDDay = currentDay
                                              .difference(appData.currentDDay
                                                  as DateTime)
                                              .inDays;
                                        } else {
                                          appData.currentDDay = selectedDay!
                                              .difference(appData.currentDDay
                                                  as DateTime)
                                              .inDays;
                                        }
                                        SharedPreferences _prefDDay =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefDDay.setInt('dDay',
                                            appData.currentDDay!.toInt());
                                        print(
                                            '1:${appData.currentNow} 2:${appData.currentSelectedDay} 3:${appData.currentDDay}');

                                        Get.back();
                                      },
                                      child: const Text('확 인')),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              );
            }),
          );
        });
  }

  SizedBox TodayCard() {
    String postId =
        DateFormat('yyyy-MM-dd 00:00:00.000').format(DateTime.now());
    //print(postId);

    return SizedBox(
      width: 654.w,
      height: 654.h,
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
                child: Text('데이터가 없습니다.'),
              );
            }

            String title =
                (snapshot.data!.data() as Map<String, dynamic>)['title'];
            String subtitle =
                (snapshot.data!.data() as Map<String, dynamic>)['subtitle'];
            String content =
                (snapshot.data!.data() as Map<String, dynamic>)['content'];

            return Screenshot(
              controller: _screenshotController,
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
                                Text(title),
                                Text(subtitle),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 320.h,
                          child: Text(content,
                              maxLines: 8, overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('${formattedNow}'),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black)),
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
                                border: Border.all(color: Colors.black),
                              ),
                              width: 55.w,
                              height: 55.h,
                              child: Center(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        final imageSave =
                                            await _screenshotController
                                                .capture();
                                        saveAndShare(imageSave);
                                      }, // _takeScreenshot,
                                      icon: Icon(Icons.share_outlined))),
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black)),
                              width: 55.w,
                              height: 55.h,
                              child: Center(
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () async {
                                      final imageSave =
                                          await _screenshotController.capture();
                                      if (imageSave == null) {}
                                      await saveImage(imageSave);
                                    },
                                    icon: Icon(Icons.file_download_outlined)),

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
                                border: Border.all(color: Colors.black),
                              ),
                              width: 55.w,
                              height: 55.h,
                              child: Center(
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {});

                                      _isBookMarkSelected =
                                          !_isBookMarkSelected;
                                      _isBookMarkSelected
                                          ? appData.savedPost.add(Post())
                                          : appData.savedPost.removeLast();
                                      //하루에 하나의 명언이 나오는데 새로운 명언이 나오면 데이터 다시...
                                    },
                                    icon: Icon(_isBookMarkSelected
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_outlined)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  color: Colors.white),
            );
          }),
    );
  }

  Widget EnlargeLastCard(Post? post) {
    if (post == null) return Container();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
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
                                Text(post.title.toString()),
                                Text(post.subtitle.toString()),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 320.h,
                          child: Text(post.content.toString(),
                              maxLines: 8, overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('${formattedNow}'),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black)),
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
                                border: Border.all(color: Colors.black),
                              ),
                              width: 55.w,
                              height: 55.h,
                              child: Center(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        await Share.share(
                                            'title : ${post.title}\nsubtitle : ${post.subtitle}\ncontent : ${post.content}');
                                      },
                                      icon: Icon(Icons.share_outlined))
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
                                  border: Border.all(color: Colors.black)),
                              width: 55.w,
                              height: 55.h,
                              child: Center(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: Icon(Icons.file_download_outlined))
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
                                  border: Border.all(color: Colors.black),
                                ),
                                width: 55.w,
                                height: 55.h,
                                child: Center(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        icon: Icon(
                                            Icons.bookmark_border_outlined)))),
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

  Container SwiperCard(AppData appData) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _postStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Container();
            if (!snapshot.hasData) return Container();
            if (snapshot.data?.size == 0) return Container();

            return Swiper(
              itemCount: snapshot.data!.docs.length,
              itemWidth: 600.w,
              itemHeight: 600.h,
              onTap: (index) {},
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

                    print(index);
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
                                    Text(title),
                                    Text(subtitle),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 22.h),
                            Container(
                              child: Text(
                                content,
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
                  appData.currentDDay! < 0
              ? 'D-000'
              : 'D-${appData.currentDDay!.toInt()}',
          style: TextStyle(fontSize: 35.sp),
        ));
  }

  SizedBox ShowGoal(AppData appData) {
    return SizedBox(
      width: 397.w,
      child: Text(
        _goalEditingController!.text == ''
            ? '목표를 정하십시오'
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
              setState(() {});
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
}

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

class AdsBottom extends StatelessWidget {
  const AdsBottom({
    Key? key,
  }) : super(key: key);

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
  const ExitApp({
    Key? key,
  }) : super(key: key);

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
                              onPressed: () {}, child: const Text('종료')),
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
