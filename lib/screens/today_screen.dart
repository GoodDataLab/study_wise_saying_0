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
import 'package:study_wise_saying/controllers/local_storage_controller.dart';
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
  bool _clickedTodaySave = true;
  bool _clickedLastSave = true;
  bool _clickedMySave = true;

  TextEditingController? _goalEditingController = TextEditingController();
  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  ScreenshotController _screenshotController = ScreenshotController();
  ScreenshotController _lastScreenshotController = ScreenshotController();
  ScreenshotController _myScreenshotController = ScreenshotController();

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  DateTime now = DateTime.now();

  DateTime? selectedDay;
  int? diff;
  Post? _selectedPost;
  Post? _myselectedPost;

  final Stream<QuerySnapshot>? _postStream = FirebaseFirestore.instance
      .collection('post')
      .orderBy('id', descending: true)
      .where('id',
          isLessThan: DateFormat('yyyy-MM-dd 00:00:00.000')
              .format(DateTime.now())
              .toString())
      .limit(30)
      .snapshots();

  // .limit(30)
  // .snapshots();

  final Stream<QuerySnapshot>? _swiperStream =
      FirebaseFirestore.instance.collection('post').snapshots();

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
                // height: 333.h,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(36.r))),
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
                          SizedBox(width: 40.w),
                          InkWell(
                            onTap: () async {
                              await ShowCalendar(context, appData);
                              // await _showNotification();
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 10.0.h, right: 10.0.w),
                              child: SizedBox(
                                  width: 30.w,
                                  height: 30.w,
                                  child:
                                      Image.asset('assets/images/write1.png')),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 41.h),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 170.h),
                          // 오늘 공명
                          TodayCard(),
                        ],
                      ),
                    ),
                    //지난 공명
                    Container(
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
      child: Padding(
        padding: EdgeInsets.all(30.0.r),
        child: StreamBuilder<QuerySnapshot>(
            stream: _swiperStream,
            builder: (context, snapshot) {
              if (appData.savedPost.length == 0) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 380.h,
                      ),
                      Container(
                        height: 80.h,
                        //width: 494.w,
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
                      // Map<String, dynamic> myData = snapshot.data!.docs
                      //     .elementAt(index)
                      //     .data() as Map<String, dynamic>;
                      // Post post = Post.fromJson(myData);
                      Post post = appData.savedPost[index];

                      String title = post.title ?? '';
                      String subtitle = post.subtitle ?? '';
                      String content = post.content ?? '';
                      String? imageUrl = post.imageUrl;

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
                              height: 313.w,
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
                                          CircleAvatar(
                                            backgroundColor: imageUrl != null
                                                ? Colors.transparent
                                                : Colors.tealAccent,
                                            radius: 17.r,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.r),
                                              child: Center(
                                                child: imageUrl != null
                                                    ? Image.network(
                                                        imageUrl,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/logo_small.png',
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 15.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        title,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
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
                                                Text(
                                                  subtitle,
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 22.h),
                                      Flexible(
                                        child: Container(
                                          width: 220.w,
                                          height: 125.h,
                                          child: Text(
                                            content,
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
    DateTime? formattedId = DateTime.tryParse(post.id.toString());
    String formattedMyPostId = DateFormat.yMMMd().format(formattedId!);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 700),
          opacity: _isMySelected ? 1 : 0,
          child: Column(
            children: [
              SizedBox(height: 730.h),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0.r)),
                width: 660.w,
                height: 660.w,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.r)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36.r)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 32.w, top: 43.5.h, right: 32.w, bottom: 30.h),
                        child: Screenshot(
                          controller: _myScreenshotController,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 32.w,
                                  top: 43.5.h,
                                  right: 32.w,
                                  bottom: 30.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      post.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              child: SizedBox(
                                                width: 72.w,
                                                height: 72.w,
                                                child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      'assets/images/shimmer.gif',
                                                  image:
                                                      post.imageUrl.toString(),
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  post.imageUrl != null
                                                      ? Colors.transparent
                                                      : Colors.tealAccent,
                                              radius: 37.r,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.r),
                                                child: Center(
                                                  child: post.imageUrl != null
                                                      ? Image.network(
                                                          post.imageUrl
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/logo_small.png',
                                                        ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 15.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                post.title.toString(),
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
                                                height: 25.w,
                                                child: Image.asset(
                                                    'assets/images/pngkit_twitter-png_189183.png'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
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
                                  SizedBox(height: 18.h),
                                  Container(
                                    height: 270.h,
                                    width: 523.w,
                                    child: Text(post.content.toString(),
                                        style: GoogleFonts.notoSans(
                                            fontSize: 25.sp,
                                            letterSpacing: -1.sp,
                                            height: 1.3),
                                        maxLines: 8,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    height: 18.h,
                                  ),
                                  Text(
                                    '${formattedMyPostId}',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 25.sp,
                                      letterSpacing: -1.13.sp,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 0.5.h,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Visibility(
                                    visible: _clickedMySave,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final imageSave =
                                                await _myScreenshotController
                                                    .capture();
                                            saveAndShare(imageSave);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xFF707070)),
                                            ),
                                            width: 50.w,
                                            height: 50.w,
                                            child: const Center(
                                                child: Icon(
                                              Icons.share_outlined,
                                              size: 18,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 11.w,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            _clickedMySave = !_clickedMySave;
                                            setState(() {});
                                            final imageSave =
                                                await _myScreenshotController
                                                    .capture();
                                            if (imageSave == null) {}
                                            await saveImage(imageSave);
                                            _clickedMySave = !_clickedMySave;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF707070))),
                                            width: 50.w,
                                            height: 50.w,
                                            child: const Center(
                                                child: Icon(
                                              Icons.file_download_outlined,
                                              size: 18,
                                            )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 11.w,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            List<String> savedIds =
                                                appData.getIdsOfSavedPost();

                                            if (savedIds.contains(post.id) ==
                                                false) {
                                              appData.savedPost.add(Post(
                                                id: post.id,
                                                title: post.title,
                                                subtitle: post.subtitle,
                                                content: post.content,
                                              ));
                                              List<String> ids =
                                                  appData.getIdsOfSavedPost();
                                              localStorageController
                                                  .setSavedPostIds(ids);
                                              setState(() {});
                                            } else {
                                              appData.savedPost.removeWhere(
                                                  (element) =>
                                                      element.id == post.id);
                                              log(appData.savedPost.length
                                                  .toString());

                                              List<String> ids =
                                                  appData.getIdsOfSavedPost();
                                              localStorageController
                                                  .setSavedPostIds(ids);
                                              _isMySelected = !_isMySelected;
                                              setState(() {});
                                            }
                                            appData.update();
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF707070)),
                                              ),
                                              width: 50.w,
                                              height: 50.w,
                                              child: const Center(
                                                child: Icon(
                                                  Icons.bookmark_rounded,
                                                  size: 18,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ShowCalendar(BuildContext context, AppData appData) {
    showDialog(
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
                    // width: 654.w,
                    // height: 1000.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
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
                                            FocusScope.of(context).unfocus();
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

                                          SharedPreferences _prefsSelectedDay =
                                              await SharedPreferences
                                                  .getInstance();
                                          _prefsSelectedDay.setString(
                                              'selectedDate',
                                              appData.currentSelectedDay
                                                  .toString());

                                          appData.currentNow = DateTime(
                                              now.year, now.month, now.day);

                                          appData.currentDDay =
                                              _dateRangePickerController
                                                  .selectedDate!
                                                  .difference(
                                                      appData.currentNow!)
                                                  .inDays;

                                          print(appData.currentNow);
                                          print(appData.currentDDay);
                                          print(appData.currentSelectedDay
                                              .toString());

                                          // SharedPreferences _prefsDDay =
                                          //     await SharedPreferences
                                          //         .getInstance();
                                          // _prefsDDay.setInt(
                                          //     'dDay', appData.currentDDay!);

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

    return Container(
      width: 660.w,
      height: 660.w,
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
            String id = (snapshot.data!.data() as Map<String, dynamic>)['id'];
            String? imageUrl =
                (snapshot.data!.data() as Map<String, dynamic>)['imageUrl'];

            return Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.grey,
                  ),
                ],
                borderRadius: BorderRadius.circular(36.0.r),
              ),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.r)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 32.w, top: 43.5.h, right: 32.w, bottom: 30.h),
                      child: Screenshot(
                        controller: _screenshotController,
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 32.w,
                                top: 43.5.h,
                                right: 32.w,
                                bottom: 30.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    imageUrl != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            child: SizedBox(
                                              width: 72.w,
                                              height: 72.w,
                                              child: FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    'assets/images/shimmer.gif',
                                                image: imageUrl,
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: imageUrl != null
                                                ? Colors.transparent
                                                : Colors.tealAccent,
                                            radius: 37.r,
                                            child: Padding(
                                              padding: EdgeInsets.all(5.r),
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/logo_small.png',
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(width: 15.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(title,
                                                style: GoogleFonts.notoSans(
                                                  fontSize: 23.sp,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -1.sp,
                                                  height: 1.1,
                                                )),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Container(
                                              width: 25.w,
                                              height: 25.w,
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
                                              height: 1.1),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18.h),
                                Container(
                                  height: 270.h,
                                  width: 523.w,
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
                                  height: 34.h,
                                ),
                                Text(
                                  '${formatted}',
                                  style: GoogleFonts.notoSans(
                                    fontSize: 25.sp,
                                    letterSpacing: -1.13.sp,
                                    height: 1.1,
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 0.5.h,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Visibility(
                                  visible: _clickedTodaySave,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          final imageSave =
                                              await _screenshotController
                                                  .capture();
                                          saveAndShare(imageSave);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xFF707070)),
                                          ),
                                          width: 50.w,
                                          height: 50.w,
                                          child: Center(
                                              child: Icon(
                                            Icons.share_outlined,
                                            size: 18,
                                          )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 11.w,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          _clickedTodaySave = false;

                                          setState(() {});

                                          final imageSave =
                                              await _screenshotController
                                                  .capture();
                                          if (imageSave == null) return;
                                          await saveImage(imageSave);
                                          await Future.delayed(
                                              Duration(milliseconds: 500));
                                          // .then((value) {

                                          setState(() {
                                            _clickedTodaySave = true;
                                            print('!');
                                          });
                                          // });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xFF707070))),
                                          width: 50.w,
                                          height: 50.w,
                                          child: Center(
                                              child: Icon(
                                                  Icons.file_download_outlined,
                                                  size: 18)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          List<String> savedIds =
                                              appData.getIdsOfSavedPost();

                                          if (savedIds.contains(id) == false) {
                                            log('not contains!');
                                            appData.savedPost.add(Post(
                                              id: id,
                                              title: title,
                                              subtitle: subtitle,
                                              content: content,
                                              imageUrl: imageUrl,
                                            ));
                                            List<String> ids =
                                                appData.getIdsOfSavedPost();
                                            localStorageController
                                                .setSavedPostIds(ids);
                                            setState(() {});
                                          } else {
                                            log('contains!');
                                            log(appData.savedPost.length
                                                .toString());
                                            appData.savedPost.removeWhere(
                                                (element) => element.id == id);
                                            log(appData.savedPost.length
                                                .toString());

                                            List<String> ids =
                                                appData.getIdsOfSavedPost();
                                            localStorageController
                                                .setSavedPostIds(ids);
                                            setState(() {});
                                          }
                                          appData.update();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xFF707070)),
                                          ),
                                          width: 50.w,
                                          height: 50.h,
                                          child: Center(
                                              child: Icon(
                                                  appData
                                                          .getIdsOfSavedPost()
                                                          .contains(id)
                                                      ? Icons.bookmark_rounded
                                                      : Icons
                                                          .bookmark_border_outlined,
                                                  size: 18)),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  color: Colors.white),
            );
          }),
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
        height: MediaQuery.of(context).size.height,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 700),
          opacity: _isSelected ? 1 : 0,
          child: Column(
            children: [
              SizedBox(height: 730.h),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15.0.r)),
                width: 660.w,
                height: 660.w,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.r)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(36.r)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 32.w, top: 43.5.h, right: 32.w, bottom: 30.h),
                        child: Screenshot(
                          controller: _lastScreenshotController,
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 32.w,
                                  top: 43.5.h,
                                  right: 32.w,
                                  bottom: 30.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      post.imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(1000),
                                              child: SizedBox(
                                                width: 72.w,
                                                height: 72.w,
                                                child: FadeInImage.assetNetwork(
                                                  fit: BoxFit.cover,
                                                  placeholder:
                                                      'assets/images/shimmer.gif',
                                                  image:
                                                      post.imageUrl.toString(),
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  post.imageUrl != null
                                                      ? Colors.transparent
                                                      : Colors.tealAccent,
                                              radius: 37.r,
                                              child: Padding(
                                                padding: EdgeInsets.all(5.r),
                                                child: Center(
                                                  child: post.imageUrl != null
                                                      ? Image.network(
                                                          post.imageUrl
                                                              .toString(),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/logo_small.png',
                                                        ),
                                                ),
                                              ),
                                            ),
                                      SizedBox(width: 15.w),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                post.title.toString(),
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
                                                height: 25.w,
                                                child: Image.asset(
                                                    'assets/images/pngkit_twitter-png_189183.png'),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6.h),
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
                                  SizedBox(height: 18.h),
                                  Container(
                                    height: 270.h,
                                    width: 523.w,
                                    child: Text(post.content.toString(),
                                        style: GoogleFonts.notoSans(
                                            fontSize: 25.sp,
                                            letterSpacing: -1.13.sp,
                                            height: 1.3),
                                        maxLines: 8,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    height: 34.h,
                                  ),
                                  Text(
                                    '${formattedPostId}',
                                    style: GoogleFonts.notoSans(
                                      fontSize: 25.sp,
                                      letterSpacing: -1.13.sp,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 0.5.h,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Visibility(
                                    visible: _clickedLastSave,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final imageSave =
                                                await _lastScreenshotController
                                                    .capture();
                                            saveAndShare(imageSave);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xFF707070)),
                                            ),
                                            width: 50.w,
                                            height: 50.h,
                                            child: Center(
                                              child: Icon(Icons.share_outlined,
                                                  size: 18),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 11.w,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            _clickedLastSave =
                                                !_clickedLastSave;
                                            setState(() {});
                                            final imageSave =
                                                await _lastScreenshotController
                                                    .capture();
                                            if (imageSave == null) {}
                                            await saveImage(imageSave);
                                            _clickedLastSave =
                                                !_clickedLastSave;
                                            setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Color(0xFF707070))),
                                            width: 50.w,
                                            height: 50.w,
                                            child: Center(
                                                child: Icon(
                                                    Icons
                                                        .file_download_outlined,
                                                    size: 18)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 11.w,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            List<String> savedIds =
                                                appData.getIdsOfSavedPost();

                                            if (savedIds.contains(post.id) ==
                                                false) {
                                              log('not contains!');
                                              appData.savedPost.add(Post(
                                                id: post.id,
                                                title: post.title,
                                                subtitle: post.subtitle,
                                                content: post.content,
                                                imageUrl: post.imageUrl,
                                              ));
                                              List<String> ids =
                                                  appData.getIdsOfSavedPost();
                                              localStorageController
                                                  .setSavedPostIds(ids);
                                              setState(() {});
                                            } else {
                                              log('contains!');
                                              log(appData.savedPost.length
                                                  .toString());
                                              appData.savedPost.removeWhere(
                                                  (element) =>
                                                      element.id == post.id);
                                              log(appData.savedPost.length
                                                  .toString());

                                              List<String> ids =
                                                  appData.getIdsOfSavedPost();
                                              localStorageController
                                                  .setSavedPostIds(ids);

                                              _isSelected = !_isSelected;
                                              setState(() {});
                                            }
                                            appData.update();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color(0xFF707070)),
                                            ),
                                            width: 50.w,
                                            height: 50.w,
                                            child: Center(
                                                child: Icon(
                                                    appData
                                                            .getIdsOfSavedPost()
                                                            .contains(post.id)
                                                        ? Icons.bookmark_rounded
                                                        : Icons
                                                            .bookmark_outline_outlined,
                                                    size: 18)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    color: Colors.white),
              ),
            ],
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
            if (snapshot.hasError) {
              print(snapshot.error);
              return Container();
            }
            if (!snapshot.hasData) return Container();
            if (snapshot.data?.size == 0) return Container();
            snapshot.data?.docs.forEach((element) {
              log(element.id);
            });

            return Swiper(
              loop: true,
              itemCount: snapshot.data!.docs.length,
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
                String id = post.id ?? '';
                String? imageUrl = post.imageUrl;

                return GestureDetector(
                  onTap: () {
                    setState(() {});
                    _selectedPost = post;
                    _isSelected = !_isSelected;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10.0,
                          color: Colors.grey,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 64.w, top: 87.h, right: 64.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                imageUrl != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: SizedBox(
                                          width: 72.w,
                                          height: 72.w,
                                          child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            placeholder:
                                                'assets/images/shimmer.gif',
                                            image: imageUrl,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: imageUrl != null
                                            ? Colors.transparent
                                            : Colors.tealAccent,
                                        radius: 37.r,
                                        child: Padding(
                                          padding: EdgeInsets.all(5.r),
                                          child: Center(
                                            child: imageUrl != null
                                                ? Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/logo_small.png',
                                                  ),
                                          ),
                                        ),
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
                              width: 523.w,
                              height: 274.h,
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
    String result = '';
    if (appData.currentDDay == null) {
      result = '';
    } else if (appData.currentDDay! > 0) {
      result = 'D - ${appData.currentDDay}';
    } else if (appData.currentDDay == 0) {
      result = 'D - DAY';
    } else {
      result = 'D + ${appData.currentDDay!.abs()}';
    }

    return SizedBox(
      width: 135.w,
      child: Text(
        result,
        style: TextStyle(
          fontSize: 40.sp,
          letterSpacing: -2.25.sp,
        ),
      ),
    );
  }

  SizedBox ShowGoal(AppData appData) {
    return SizedBox(
      width: 420.w,
      child: Text(
        _goalEditingController!.text == ''
            ? '목표를 작성해주세요.'
            : appData.currentGoal.toString(),
        style: TextStyle(
            fontSize: 40.sp,
            letterSpacing: -3.5.sp,
            fontWeight: FontWeight.normal,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '갤러리에 저장되었습니다.',
        ),
        action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
            }),
      ),
    );

    return '';

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
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(36.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  // height:
                  //     admobController.mediumRectangleAd.size.height.toDouble(),
                  child: admobController.createMediumAd(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100.h,
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
                      height: 100.h,
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Color(0xFF777777)))),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                            SystemNavigator.pop();
                          },
                          child: const Text('종료')),
                    ),
                  ),
                ],
              )
            ],
          ));
    });
  }
}
