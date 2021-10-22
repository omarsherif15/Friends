import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/signUpCubit.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var signUpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SignUpCubit(),
        child:BlocConsumer<SignUpCubit,SocialStates>(
          listener: (context, state) {
            if(state is CreateUserSuccessState) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value){
                uId = state.uId;
                navigateAndKill(context, SocialLayout(0));
                SocialCubit.get(context).getMyData();
              });
            }
          },
          builder: (context, state) {
            return  Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light),
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                      icon: Icon(Icons.language),
                      itemBuilder: (context) =>  [
                        PopupMenuItem(
                          value: 'Arabic',
                          child: Text('عربي',style: TextStyle(color: SocialCubit.get(context).textColor),),),
                        PopupMenuItem(
                          value: 'English',
                          child: Text('English',style: TextStyle(color: SocialCubit.get(context).textColor)),)
                      ],
                    )
                  )
                ],
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
                              SizedBox(height: 50,),
                              Text(LocaleKeys.Register.tr(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white)),
                              SizedBox(height: 10,),
                              Text(LocaleKeys.CreateToCommunicate.tr(),style: TextStyle(fontSize: 20,color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                          height: 560,
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
                            key: signUpFormKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                              [
                                defaultFormField(
                                    context: context,
                                    controller:nameController ,
                                    keyboardType: TextInputType.text,
                                    hintText: LocaleKeys.userName.tr(),
                                    prefix: Icons.person,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                        return LocaleKeys.ThisFieldMustBeFilled.tr();
                                    }
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                    context: context,
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    hintText: LocaleKeys.EmailAddress.tr(),
                                    prefix: Icons.email,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                        return LocaleKeys.ThisFieldMustBeFilled.tr();
                                    }
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                    context: context,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    hintText: LocaleKeys.phoneNumber.tr(),
                                    prefix: Icons.phone,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                        return LocaleKeys.ThisFieldMustBeFilled.tr();
                                    }
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultFormField(
                                    context: context,
                                    controller: passwordController,
                                    hintText: LocaleKeys.password.tr(),
                                    prefix: Icons.lock,
                                    isPassword: !SignUpCubit.get(context).showPassword ? true : false,
                                    validate: (value)
                                    {
                                      if(value!.isEmpty)
                                        return LocaleKeys.ThisFieldMustBeFilled.tr();
                                    },
                                    onSubmit: (value)
                                    {
                                      // if (loginFormKey.currentState!.validate()) {
                                      //   LoginCubit.get(context).signIn(
                                      //       email: emailController.text,
                                      //       password: passwordController.text);
                                      // }
                                    },
                                    suffix: SignUpCubit.get(context).suffixIcon,
                                    suffixPressed: ()
                                    {
                                      SignUpCubit.get(context).changeSuffixIcon(context);
                                    }
                                ),

                                SizedBox(height: 40,),
                                state is LoginLoadingState ?
                                Center(child: CircularProgressIndicator())
                                    :defaultButton(
                                  text: LocaleKeys.SIGNUP.tr(),
                                  onTap: () {
                                    if (signUpFormKey.currentState!.validate()) {
                                      SignUpCubit.get(context).signUp(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.alreadyhaveanAccount.tr() + '?',style: TextStyle(color: SocialCubit.get(context).textColor.withOpacity(0.5)),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          pop(context);
                                        },
                                        child: Text(LocaleKeys.SignIn.tr())
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
            );
          },
        )
    );
  }
}
