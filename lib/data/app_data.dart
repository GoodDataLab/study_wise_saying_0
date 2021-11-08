import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:study_wise_saying/model/post.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppData extends GetxController {
  bool _isLoadingScreen = false;
  String? currentGoal;
  String titleText = '';
  String subtitleText = '';
  String contentText = '';
  String? currentSelectedDay;
  DateTime? currentNow;
  int? _currentDDay;
  bool isStarted = false;
  // bool isBookMarked = false;
  List<Post> savedPost = [];
  //DateTime? selectedDay;

  // DateRangePickerController _adminDateRangePickerController =
  //     DateRangePickerController();

  int? get currentDDay => _currentDDay;
  set currentDDay(int? currentDDay) {
    _currentDDay = currentDDay;
    update();
  }

  bool get isLoading => _isLoadingScreen;

  void enterLoading() {
    _isLoadingScreen = true;
    update();
  }

  void exitLoading() {
    _isLoadingScreen = false;
    update();
  }

  List<Post> _posts = [];
  List<Post> get posts => _posts;
  set posts(List<Post> posts) {
    _posts = posts;
    update();
  }

  List<String> getIdsOfSavedPost() {
    List<String> ids = [];
    savedPost.forEach((element) {
      if (element.id == null) {
        log('element.id is null error');
      }
      ids.add(element.id ?? '');
    });
    return ids;
  }

  updateSavedPostsByIds(List<String> ids) {
    savedPost.clear();
    ids.forEach((element) async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('post')
          .doc(element)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
        Post post = Post.fromJson(json);
        savedPost.add(post);
      }
    });
  }

  // List<User> _user = [];
  // List<User> get user => _user;
  // set user(List<User> user) {
  //   _user = user;
  //   update();
  // }
}
