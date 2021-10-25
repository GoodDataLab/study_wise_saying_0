import '../common_import.dart';

class NAMESCREEN extends StatefulWidget {
  @override
  _NAMESCREENState createState() => _NAMESCREENState();
}

class _NAMESCREENState extends State<NAMESCREEN> {
  AppData appData = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (AppData appData) => Loading(
        child: Scaffold(
          body: Container(),
        ),
      ),
    );
  }
}
