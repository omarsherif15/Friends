import 'dart:ui';

import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/LoginCubit.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/modules/forgetPasswordScreen.dart';
import 'package:socialapp/modules/registerScreen.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';

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
            then((value) async {
              uId =state.uId;
              navigateAndKill(context, SocialLayout(0));
              SocialCubit.get(context).getMyData();
              print (await FirebaseMessaging.instance.getToken());
            });
          else if(state is CreateGoogleUserSuccessState)
            CacheHelper.saveData(key: 'uId', value: state.uId).
            then((value) async {
              uId =state.uId;
              navigateAndKill(context, SocialLayout(0));
              SocialCubit.get(context).getMyData();
              print (await FirebaseMessaging.instance.getToken());
            });
          else if(state is LoginGoogleUserSuccessState)
            CacheHelper.saveData(key: 'uId', value: state.uId).
            then((value) async {
              uId =state.uId;
              navigateAndKill(context, SocialLayout(0));
              SocialCubit.get(context).getMyData();
              print (await FirebaseMessaging.instance.getToken());
            });
        },
        builder: (context, state) {
          return  Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              actions: [
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PopupMenuButton(
                  onSelected: (value){
                    if(value == 'Arabic')
                      SocialCubit.get(context).changeLocalToAr(context);
                    else
                      SocialCubit.get(context).changeLocalToEn(context);
                  } ,
                  color: SocialCubit.get(context).backgroundColor.withOpacity(1),
                  icon: Icon(Icons.language,color: Colors.white,),
                  itemBuilder: (context) =>  [
                    PopupMenuItem(
                      value: 'Arabic',
                      child: Text('عربي',style: TextStyle(color: SocialCubit.get(context).textColor),),),
                    PopupMenuItem(
                      value: 'English',
                      child: Text('English',style: TextStyle(color: SocialCubit.get(context).textColor)),),
                  ],
                )
                )
              ],
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
                          image: AssetImage('assets/images/background.jpeg'),fit: BoxFit.cover
                      )
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 60,),
                            Container(
                                width: 270,
                                child: Text(LocaleKeys.WelcomeBack.tr() + '!',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white))),
                            SizedBox(height: 10,),
                            Text(LocaleKeys.Logintocommunicatewithyourfriends.tr(),style: TextStyle(fontSize: 20,color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        height: 500,
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            color: SocialCubit.get(context).backgroundColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                            )),
                        child: Form(
                          key: loginFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              SizedBox(height: 10,),
                              defaultFormField(
                                  context: context,
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  hintText: LocaleKeys.EmailAddress.tr(),
                                  prefix: Icons.email_outlined,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                      return LocaleKeys.ThisFieldMustBeFilled.tr();
                                  }
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              defaultFormField(
                                  context: context,
                                  controller: passwordController,
                                  hintText: LocaleKeys.password.tr(),
                                  prefix: IconBroken.Lock,
                                  isPassword: !LoginCubit.get(context).showPassword ? true : false,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                      return LocaleKeys.ThisFieldMustBeFilled.tr();
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
                                    onPressed: (){
                                      navigateTo(context, ForgotPasswordScreen());
                                    },
                                    child: Text(LocaleKeys.ForgetYourPassword.tr() +'?',
                                      style: TextStyle(
                                          color: SocialCubit.get(context).textColor.withOpacity(0.5)),
                                    )
                                ),
                              ),
                              state is LoginLoadingState ?
                              Center(child: CircularProgressIndicator())
                                  :defaultButton(
                                      text: LocaleKeys.login.tr(),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey[300],
                                      height: 1,
                                    ),
                                ),
                                  Container(
                                    color: SocialCubit.get(context).backgroundColor.withOpacity(0),
                                    padding: EdgeInsets.all(8),
                                      child: Text(LocaleKeys.OrSignInwith.tr(),
                                        style: TextStyle(color: SocialCubit.get(context).textColor
                                            , fontSize: 18,fontWeight: FontWeight.bold),)),
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey[300],
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      InkWell(
                                        onTap: (){
                                          SocialCubit.get(context).changeMode();
                                        },
                                        child: CircleAvatar(
                                          child:Image(image:AssetImage('assets/images/facebook_logo.png',),width: 40,height: 40,),
                                          backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(0),
                                        ),
                                      ),
                                      SizedBox(width: 50,),
                                      InkWell(
                                        onTap: (){
                                          LoginCubit.get(context).getGoogleUserCredentials();
                                        },
                                        child: CircleAvatar(
                                          child: state is LoginGoogleUserLoadingState?
                                          CircularProgressIndicator() :
                                          Image(image:AssetImage('assets/images/Google_Logo.png',),width: 50,height: 50,),
                                          backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(0),
                                        ),
                                      ),
                                      SizedBox(width: 50,),
                                      InkWell(
                                        onTap: (){
                                          LoginCubit.get(context).signOut();
                                        },
                                        child: CircleAvatar(
                                          child:Image(image:AssetImage('assets/images/Twitter-Logo.png',),width: 70,height: 70,),
                                          backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(0),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.Donthaveanaccount.tr() + '?',style: TextStyle(color: SocialCubit.get(context).textColor.withOpacity(0.5)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        navigateTo(context, RegisterScreen());
                                      },
                                      child: Text(LocaleKeys.SIGNUP.tr())
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
