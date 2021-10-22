import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/restPasswordCubit.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/modules/loginScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/translations/local_keys.g.dart';

class ForgotPasswordScreen extends StatelessWidget {
  var loginFormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit,SocialStates>(
        listener: (context,state){
          if(state is ResetPasswordSuccessState)
            navigateAndKill(context, LoginScreen());
        },
        builder: (context,state){
          return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.light,
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light
              ),

              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: (){
                  emailController.clear();
                  pop(context);
                },
                icon: Icon(Icons.arrow_back,color: Colors.white,),
              ),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30,),
                            Text(LocaleKeys.ForgetYourPassword.tr(),style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white)),
                            SizedBox(height: 10,),
                            Text('Enter the email address associated with your account',style: TextStyle(fontSize: 20,color: Colors.white.withOpacity(0.7))),
                          ],
                        ),
                      ),
                      Container(
                        height: 250,
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
                                  prefix: Icons.email,
                                  validate: (value)
                                  {
                                    if(value!.isEmpty)
                                      return LocaleKeys.ThisFieldMustBeFilled.tr();
                                  }
                              ),
                              SizedBox(height: 40,),
                              state is ResetPasswordLoadingState ?
                              Center(child: CircularProgressIndicator())
                                  :defaultButton(
                                text: 'RESET PASSWORD',
                                onTap: () {
                                  if (loginFormKey.currentState!.validate()) {
                                    ResetPasswordCubit.get(context).resetPassword(
                                      email: emailController.text,
                                    );
                                  }
                                },
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
      ),
    );
  }
}
