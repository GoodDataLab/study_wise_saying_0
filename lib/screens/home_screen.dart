import '../common_import.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar'),
      ),
      body: Container(),
    );
  }
}
