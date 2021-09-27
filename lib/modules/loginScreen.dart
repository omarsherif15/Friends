import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/LoginCubit.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/modules/registerScreen.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child:BlocConsumer<LoginCubit,SocialStates>(
        listener: (context, state) {
          if(state is LoginSuccessState)
            CacheHelper.saveData(key: 'uId', value: state.uId).
            then((value) {
              uId =state.uId;
              navigateAndKill(context, SocialLayout(0));
              SocialCubit.get(context).getUserData();
              SocialCubit.get(context).getAllUsers();

            });
        },
        builder: (context, state) {
          return  Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/3700.jpeg'),fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Text('Welcome Back!',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white)),
                      SizedBox(height: 10,),
                      Text('Login to communicate with your friends',style: TextStyle(fontSize: 20,color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  height: 500,
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                      )),
                  child: Form(
                    key: loginFormKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        [
                          SizedBox(height: 20,),
                          defaultFormField(
                              context: context,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Email Address',
                              prefix: Icons.email,
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                  return 'Email Address must be filled';
                              }
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          defaultFormField(
                              context: context,
                              controller: passwordController,
                              hintText: 'Password',
                              prefix: IconBroken.Category,
                              isPassword: !LoginCubit.get(context).showPassword ? true : false,
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                  return'Password must be filled';
                              },
                              onSubmit: (value)
                              {
                                if (loginFormKey.currentState!.validate()) {
                                  LoginCubit.get(context).signIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              suffix: LoginCubit.get(context).suffixIcon,
                              suffixPressed: ()
                              {
                                LoginCubit.get(context).changeSuffixIcon(context);
                              }
                          ),
                          Container(
                            width: double.infinity,
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                                onPressed: (){},
                                child: Text('Forget Your Password ?',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                )
                            ),
                          ),
                          SizedBox(height: 20,),
                          state is LoginLoadingState ?
                          Center(child: CircularProgressIndicator())
                              :defaultButton(
                                  text: 'SIGN IN',
                                  onTap: () {
                                    if (loginFormKey.currentState!.validate()) {
                                      LoginCubit.get(context).signIn(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                          ),
                          SizedBox(height: 20,),
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              myDivider(),
                              Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(8),
                                  child: Text('Or Sign In with',
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                [
                                  CircleAvatar(
                                    child:Image(image:AssetImage('assets/images/facebook_logo.png',),width: 40,height: 40,),
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(width: 50,),
                                  CircleAvatar(
                                    child:Image(image:AssetImage('assets/images/Google_Logo.png',),width: 50,height: 50,),
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(width: 50,),
                                  CircleAvatar(
                                    child:Image(image:AssetImage('assets/images/Twitter-Logo.png',),width: 70,height: 70,),
                                    backgroundColor: Colors.white,
                                  ),
                                ],
                              )
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '    Don\'t have an account?',style: TextStyle(color: Colors.black.withOpacity(0.5)),
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: Text('Sign Up')
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // bottomSheet: Container(
            //   height: 500,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     border: Border.all(),
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(40.0),
            //         topLeft: Radius.circular(40.0),
            //     )),
            // ),
          );
        },
      )
    );
  }
}
