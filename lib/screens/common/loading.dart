import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../data/app_data.dart';

class Loading extends StatefulWidget {
  final Widget child;

  Loading({required this.child});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Get.find();
    return Stack(
      children: [
        BackdropFilter(
          filter: appData.isLoading
              ? ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0)
              : ImageFilter.blur(),
          child: widget.child,
        ),
        // Visibility(
        //   visible: appData.isLoading,
        //   child: SizedBox.expand(
        //     child: Container(
        //       color: Colors.black.withOpacity(.5),
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: appData.isLoading,
        //   child: Center(
        //     child: CircularProgressIndicator(
        //       color: kPrimaryColor,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
