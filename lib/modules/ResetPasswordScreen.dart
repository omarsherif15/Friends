import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/LoginCubit.dart';
import 'package:socialapp/cubit/restPasswordCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/modules/loginScreen.dart';
import 'package:socialapp/shared/component.dart';
import 'package:socialapp/shared/constants.dart';

class ResetPasswordScreen extends StatelessWidget {
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
                          image: AssetImage('assets/images/3700.jpeg'),fit: BoxFit.cover
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Container(
                        width: double.infinity,
                          child: Image(image: AssetImage('assets/images/pass-removebg-preview.png'),width: 200,height: 200,)),
                      Text('FORGOT PASSWORD?',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white)),
                      SizedBox(height: 10,),
                      Text('Enter the email address associated with your account',style: TextStyle(fontSize: 20,color: Colors.white.withOpacity(0.7))),
                    ],
                  ),
                ),
                Container(
                  height: 290,
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
                          SizedBox(height: 40,),
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
                ),
              ],
            ),

          );
        },
      ),
    );
  }
}
