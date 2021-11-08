//import 'dart:html';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_wise_saying/controllers/image_pick_uploader.dart';
import 'package:study_wise_saying/controllers/storage_controller.dart';
import 'package:study_wise_saying/model/post.dart';
import 'package:study_wise_saying/screens/common/global_popup.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../common_import.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  final Post? orginalPost;

  const AdminScreen({Key? key, this.orginalPost}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  AppData appData = Get.find();

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateRangePickerController _adiminDateRangeController =
      DateRangePickerController();

  String _date = DateFormat('yyyy MMMM dd').format(DateTime.now()).toString();
  String? _selectedDateDocId;
  XFile? _image;
  bool isImageUpdated = false;

  //var _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 700.h,
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      monthViewSettings:
                          DateRangePickerMonthViewSettings(dayFormat: 'EEE'),
                      toggleDaySelection: false,
                      allowViewNavigation: false,
                      controller: _adiminDateRangeController,
                      initialDisplayDate: DateTime.now(),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        SchedulerBinding.instance!
                            .addPostFrameCallback((duration) async {
                          _date = DateFormat('yyyy MMMM dd')
                              .format(args.value)
                              .toString();
                          _selectedDateDocId = args.value.toString();
                          isImageUpdated = false;

                          DocumentSnapshot snapshot = await FirebaseFirestore
                              .instance
                              .collection('post')
                              .doc(args.value.toString())
                              .get();

                          if (snapshot.exists) {
                            Map<String, dynamic> json =
                                snapshot.data() as Map<String, dynamic>;
                            titleController.text = json['title'];
                            contentController.text = json['content'];
                            subtitleController.text = json['subtitle'];
                            String imageUrl = json['imageUrl'];

                            //print(json);
                          } else {
                            titleController.text = '';
                            subtitleController.text = '';
                            contentController.text = '';
                          }
                          setState(() {});
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w),
                    child: Text('${_date}'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w),
                    child: Container(
                        child: GestureDetector(
                          onTap: () {
                            print('!KM!KN');
                            getImageFromGallery();
                          },
                          child: _image == null
                              ? Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: Colors.black,
                                )
                              : Image.file(File(_image!.path)),
                        ),
                        //width: MediaQuery.of(context).size.width,
                        height: 200.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0.r),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: 'TITLE',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.w),
                            borderRadius: BorderRadius.circular(15.r)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 5.w),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: subtitleController,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: 'SubTitle',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.w),
                            borderRadius: BorderRadius.circular(15.r)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 5.w),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: contentController,
                      onChanged: (value) {},
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 5.w),
                            borderRadius: BorderRadius.circular(15.r)),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 5.w),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('뒤로가기'))),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (databaseController.getPost(
                                          postId: _date) !=
                                      _adiminDateRangeController.selectedDate) {
                                    Post post = Post(
                                        id: _adiminDateRangeController
                                            .selectedDate
                                            .toString(),
                                        // dateCreated: _adiminDateRangeController
                                        //     .selectedDate,
                                        title: titleController.text,
                                        subtitle: subtitleController.text,
                                        content: contentController.text);

                                    await databaseController.addPost(
                                        post: post);
                                    if (isImageUpdated) await uploadImage();
                                    // await firebaseStorageController.uploadFile(
                                    //     filePath: 'profile',
                                    //     uploadPath: DateTime.now().toString());
                                  } else {
                                    await databaseController.updatePost(
                                        postId: _adiminDateRangeController
                                            .selectedDate
                                            .toString(),
                                        postTitle: titleController.text,
                                        postSubtitle: subtitleController.text,
                                        postContent: contentController.text);
                                    if (isImageUpdated) await uploadImage();
                                  }
                                  appData.enterLoading();

                                  appData.exitLoading();

                                  Get.back();
                                },
                                child: Text('업데이트'))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    final _picker = ImagePicker();

    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = image!;
    });

    isImageUpdated = true;
  }

  Future uploadImage() async {
    final uploadPath = '/profile/';
    if (_image == null) return;

    try {
      String? result = await firebaseStorageController.uploadFile(
        filePath: _image!.path,
        uploadPath: uploadPath,
      );
      log(result.toString());
      if (result != null) {
        String docId = _selectedDateDocId!;

        await FirebaseFirestore.instance.collection('post').doc(docId).update({
          'imageUrl': result,
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
