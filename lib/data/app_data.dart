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
  String? currentNow;
  int? currentDDay;
  bool isStarted = false;
  bool isBookMarked = false;
  List<Post> savedPost = [];
  //DateTime? selectedDay;

  // DateRangePickerController _adminDateRangePickerController =
  //     DateRangePickerController();

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

  // List<User> _user = [];
  // List<User> get user => _user;
  // set user(List<User> user) {
  //   _user = user;
  //   update();
  // }
}
