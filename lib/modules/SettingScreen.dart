
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/models/userModel.dart';
import 'package:socialapp/modules/aboutMe.dart';
import 'package:socialapp/modules/editProfileScreen.dart';
import 'package:socialapp/modules/resetPasswordScreen.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/iconBroken.dart';
import 'package:socialapp/translations/local_keys.g.dart';
import 'dart:math' as math;

class SettingScreen extends StatefulWidget {
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? languageValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        EasyLocalization.of(context)!.currentLocale == Locale('en') ? languageValue = "English" : languageValue = "Arabic";
        UserModel? myUser = SocialCubit.get(context).model;
        return WillPopScope(
          onWillPop: willPopCallback,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      LocaleKeys.Settings.tr(),
                      style: GoogleFonts.arya(
                          fontWeight: FontWeight.bold,
                          color: SocialCubit.get(context).textColor,
                          fontSize: 30),
                    )),
                InkWell(
                  onTap: () {
                    SocialLayoutState.tabController.animateTo(3,
                        duration: Duration(seconds: 2),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: SocialCubit.get(context).isDark? HexColor('#212121').withOpacity(0.8) : Colors.grey.shade300,
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 27,
                            backgroundImage: NetworkImage('${myUser!.profilePic}')),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${myUser.name}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: SocialCubit.get(context).textColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                LocaleKeys.seeYourProfile.tr(),
                                style: TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              SocialCubit.get(context).signOut(context);
                            },
                            child: Row(
                              children: [
                                Icon(IconBroken.Logout),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  LocaleKeys.SignOut.tr(),
                                  style: TextStyle(
                                      color: SocialCubit.get(context).textColor),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.account.tr(),
                    style: TextStyle(
                        fontSize: 20, color: SocialCubit.get(context).textColor),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  color: SocialCubit.get(context).isDark? HexColor('#212121').withOpacity(0.8) : Colors.grey.shade300,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigateTo(context, EditProfileScreen());
                        },
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                                size: 27,
                              ),
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.personalInfo.tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: SocialCubit.get(context).textColor),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(context, ResetPasswordScreen());
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                IconBroken.Lock,
                                color: Colors.grey[600],
                                size: 27,
                              ),
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.changePassword.tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: SocialCubit.get(context).textColor),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          SocialLayoutState.tabController.animateTo(4,
                              duration: Duration(seconds: 2),
                              curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                IconBroken.Notification,
                                color: Colors.grey[600],
                                size: 27,
                              ),
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.Notifications.tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: SocialCubit.get(context).textColor),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    LocaleKeys.Settings.tr(),
                    style: TextStyle(
                        fontSize: 20, color: SocialCubit.get(context).textColor),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  color: SocialCubit.get(context).isDark? HexColor('#212121').withOpacity(0.8) : Colors.grey.shade300,
                  child: Column(
                    children: [
                      ExpansionWidget(
                          titleBuilder: (double animationValue, _, bool isExpand, toogleFunction) {
                            return InkWell(
                              onTap: () => toogleFunction(animated: true),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: Icon(
                                      Icons.language,
                                      color: Colors.grey[600],
                                      size: 27,
                                    ),
                                    backgroundColor: Colors.grey[400],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    LocaleKeys.language.tr(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: SocialCubit.get(context).textColor),
                                  ),
                                  Spacer(),
                                  Transform.rotate(
                                    child: Icon(Icons.arrow_forward_ios_outlined),
                                    angle: math.pi * animationValue / 2,
                                  ),
                                ],
                              ),
                            );
                          },
                          content: Container(
                            width: 300,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text('عربي',style: TextStyle(color: SocialCubit.get(context).textColor),),
                                    Spacer(),
                                    Radio(
                                      toggleable: true,
                                      value: 'Arabic',
                                      groupValue: languageValue,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value){
                                        setState(() {
                                          languageValue = value.toString();
                                        });
                                        SocialCubit.get(context).changeLocalToAr(context);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("English",style: TextStyle(color: SocialCubit.get(context).textColor),),
                                    Spacer(),
                                    Radio(
                                      toggleable: true,
                                      value: 'English',
                                      groupValue: languageValue,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value){
                                        setState(() {
                                          languageValue = value.toString();
                                        });
                                        SocialCubit.get(context).changeLocalToEn(context);
                                      },
                                    ),
                                  ],
                                ),
                              ],),
                          )
                      ),
                      const SizedBox(height: 15,),
                      ExpansionWidget(
                          titleBuilder: (double animationValue, _, bool isExpand, toogleFunction) {
                            return InkWell(
                              onTap: () => toogleFunction(animated: true),
                              child: Row(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: Icon(
                                      Icons.dark_mode_outlined,
                                      color: Colors.grey[600],
                                      size: 27,
                                    ),
                                    backgroundColor: Colors.grey[400],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    LocaleKeys.darkMode.tr(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: SocialCubit.get(context).textColor),
                                  ),
                                  Spacer(),
                                  Transform.rotate(
                                    child: Icon(Icons.arrow_forward_ios_outlined),
                                    angle: math.pi * animationValue / 2,
                                  ),
                                ],
                              ),
                            );
                          },
                          content: Container(
                            width: 300,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(LocaleKeys.on.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                    Spacer(),
                                    Radio(
                                      toggleable: true,
                                      value: 'On',
                                      groupValue: SocialCubit.get(context).darkModeRadio,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value){
                                        SocialCubit.get(context).changeActiveRadio(value);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(LocaleKeys.off.tr(),style: TextStyle(color: SocialCubit.get(context).textColor),),
                                    Spacer(),
                                    Radio(
                                      toggleable: true,
                                      value: 'Off',
                                      groupValue: SocialCubit.get(context).darkModeRadio,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (value){
                                        SocialCubit.get(context).changeActiveRadio(value);
                                      },
                                    ),
                                  ],
                                ),
                              ],),
                          )
                      ),
                      const SizedBox(height: 15,),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                Icons.help,
                                color: Colors.grey[600],
                                size: 27,
                              ),
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.help.tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: SocialCubit.get(context).textColor),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      InkWell(
                        onTap: () {
                          navigateTo(context, AboutMe());
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                IconBroken.Info_Circle,
                                color: Colors.grey[600],
                                size: 27,
                              ),
                              backgroundColor: Colors.grey[400],
                            ),
                            const SizedBox(width: 10),
                            Text(
                              LocaleKeys.aboutUs.tr(),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: SocialCubit.get(context).textColor),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(SocialCubit.get(context).isDark? HexColor('#212121').withOpacity(0.8) : Colors.grey.shade300,),
                      fixedSize: MaterialStateProperty.all(Size.fromHeight(50))
                  ),
                    onPressed: () => SocialCubit.get(context).deleteAccount(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete,color: Colors.red,),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('DELETE MY ACCOUNT',style: TextStyle(color: Colors.red),),
                      ],
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<bool> willPopCallback()async {
    SocialLayoutState.tabController.animateTo(0,duration: Duration(seconds: 2),curve: Curves.fastLinearToSlowEaseIn);
    return false;
  }
}
