import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:study_wise_saying/controllers/local_storage_controller.dart';
import 'package:study_wise_saying/handlers/link_share_handler.dart';
import 'package:study_wise_saying/model/post.dart';
import 'package:study_wise_saying/screens/today_screen.dart';

import '../common_import.dart';

class ScreenByDynamicLink extends StatefulWidget {
  final String postId;

  const ScreenByDynamicLink({Key? key, required this.postId}) : super(key: key);
  @override
  _ScreenByDynamicLinkState createState() => _ScreenByDynamicLinkState();
}

class _ScreenByDynamicLinkState extends State<ScreenByDynamicLink> {
  AppData appData = Get.find();
  ScreenshotController _screenshotController = ScreenshotController();
  bool _clickedTodaySave = true;
  //String postId = DateFormat("yyyy-MM-dd 00:00:00.000").format(DateTime.now());
  //String formatted = DateFormat.yMMMd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    String postId = widget.postId.replaceAll('+', ' ');
    DateTime? formattedId = DateTime.tryParse(postId);
    String formattedPostId = DateFormat.yMMMd().format(formattedId!);
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: kBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: Center(
            child: Container(
              child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('post')
                      .doc(postId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.exists) {
                        Post post = Post.fromJson(
                            snapshot.data?.data() as Map<String, dynamic>);
                        //return Text('Hello World, ${post.title}');
                        return Container(
                          width: 660.w,
                          height: 660.w,
                          child: Container(
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
                                      left: 32.w,
                                      top: 43.5.h,
                                      right: 32.w,
                                      bottom: 30.h),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                post.imageUrl != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(1000),
                                                        child: SizedBox(
                                                          width: 72.w,
                                                          height: 72.w,
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                'assets/images/shimmer.gif',
                                                            image:
                                                                post.imageUrl!,
                                                          ),
                                                        ),
                                                      )
                                                    : CircleAvatar(
                                                        backgroundColor: post
                                                                    .imageUrl !=
                                                                null
                                                            ? Colors.transparent
                                                            : Colors.tealAccent,
                                                        radius: 37.r,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.r),
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
                                                        Text(post.title!,
                                                            style: GoogleFonts
                                                                .notoSans(
                                                              fontSize: 23.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  -1.sp,
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
                                                      post.subtitle!,
                                                      style:
                                                          GoogleFonts.notoSans(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing:
                                                                  -1.sp,
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
                                              child: Text(post.content!,
                                                  style: GoogleFonts.notoSans(
                                                    fontSize: 25.sp,
                                                    letterSpacing: -1.13.sp,
                                                    height: 1.3,
                                                  ),
                                                  maxLines: 8,
                                                  overflow:
                                                      TextOverflow.ellipsis),
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 0.5.h,
                                              color: Colors.black,
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            Visibility(
                                              visible: _clickedTodaySave,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      // final imageSave =
                                                      //     await _screenshotController
                                                      //         .capture();
                                                      // saveAndShare(imageSave);
                                                      try {
                                                        log('!' +
                                                            (post.id ??
                                                                'null'));
                                                        await linkShareHandler
                                                            .makeLinkAndShare(
                                                          postId: post.id!,
                                                          title: post.content!,
                                                          content: post.title!,
                                                        );
                                                      } catch (e) {
                                                        log(e.toString());
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFF707070)),
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
                                                      if (imageSave == null)
                                                        return;
                                                      await saveImage(
                                                          imageSave);
                                                      await Future.delayed(
                                                          Duration(
                                                              milliseconds:
                                                                  500));
                                                      // .then((value) {

                                                      setState(() {
                                                        _clickedTodaySave =
                                                            true;
                                                      });
                                                      // });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFF707070))),
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
                                                    width: 12.w,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      List<String> savedIds =
                                                          appData
                                                              .getIdsOfSavedPost();

                                                      if (savedIds.contains(
                                                              post.id) ==
                                                          false) {
                                                        log('not contains!');
                                                        appData.savedPost
                                                            .add(Post(
                                                          id: post.id,
                                                          title: post.title,
                                                          subtitle:
                                                              post.subtitle,
                                                          content: post.content,
                                                          imageUrl:
                                                              post.imageUrl,
                                                        ));
                                                        List<String> ids = appData
                                                            .getIdsOfSavedPost();
                                                        localStorageController
                                                            .setSavedPostIds(
                                                                ids);
                                                        setState(() {});
                                                      } else {
                                                        log('contains!');
                                                        log(appData
                                                            .savedPost.length
                                                            .toString());
                                                        appData.savedPost
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    post.id);
                                                        log(appData
                                                            .savedPost.length
                                                            .toString());

                                                        List<String> ids = appData
                                                            .getIdsOfSavedPost();
                                                        localStorageController
                                                            .setSavedPostIds(
                                                                ids);
                                                        setState(() {});
                                                      }
                                                      appData.update();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFF707070)),
                                                      ),
                                                      width: 50.w,
                                                      height: 50.h,
                                                      child: Center(
                                                          child: Icon(
                                                              appData
                                                                      .getIdsOfSavedPost()
                                                                      .contains(
                                                                          post
                                                                              .id)
                                                                  ? Icons
                                                                      .bookmark_rounded
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
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
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
  bool get wantKeepAlive => throw UnimplementedError();
}
