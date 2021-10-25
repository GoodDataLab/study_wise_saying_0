import 'dart:ui';

import '../common_import.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0.h),
              child: AppBar(
                backgroundColor: Colors.white,
                //iconTheme: IconThemeData(color: Colors.black, size: 10),
                elevation: 0,
              ),
            ),
            backgroundColor: kBackgroundColor,
            bottomNavigationBar: Container(
              color: kBackgroundColor,
              width: MediaQuery.of(context).size.width,
              height: 100.h,
            ),
            body: Builder(builder: (context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'index',
                        child:
                            Image.network('https://picsum.photos/250?image=9'),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
              );
            })),
      ),
    );
  }
}
