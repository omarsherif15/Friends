import 'package:flutter/material.dart';
import 'package:socialapp/layouts/sociallayout.dart';

class NotificationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopCallback,
      child: Center(
        child: Image(image: AssetImage('assets/images/underConstruction.png'),),
      ),
    );
  }
  Future<bool> willPopCallback()async {
    SocialLayoutState.tabController.animateTo(0,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
    return false;
  }
}
