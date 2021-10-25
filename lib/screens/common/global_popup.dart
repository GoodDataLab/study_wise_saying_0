import '../../common_import.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: kSecondaryColor,
    textColor: Colors.white,
  );
}

showCustomCupertinoAlert(String message) {
  Get.dialog(
    AlertDialog(
      contentPadding:
          EdgeInsets.only(top: 32.h, bottom: 0.h, left: 20.w, right: 20.w),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.r))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(color: kGreyCupertino, fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25.12.h),
          Divider(
            height: 1,
          ),
          // SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: kBlueCupertino,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
