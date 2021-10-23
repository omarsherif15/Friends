import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/cubit/socialCubit.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SocialCubit.get(context).isDark?
        Image(image: AssetImage('assets/images/Dark Logo.png'),width: double.infinity,height: 300,fit: BoxFit.cover,)
            :
        Image(image: AssetImage('assets/images/Light Logo.png'),width: double.infinity,height: 300,fit: BoxFit.cover,)
      ),
    );
  }
}
