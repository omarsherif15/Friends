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
                SocialCubit.get(context).setUserToken();
              });
            }
          },
          builder: (context, state) {
            return  Scaffold(
              backgroundColor: Colors.transparent,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light),
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
                        SizedBox(height: 50,),
                        Text('Register',style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white)),
                        SizedBox(height: 10,),
                        Text('Create a new Account to communicate with your friends',style: TextStyle(fontSize: 20,color: Colors.white)),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: 560,
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
                        key: signUpFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                          [
                            defaultFormField(
                                context: context,
                                controller:nameController ,
                                keyboardType: TextInputType.text,
                                hintText: 'User Name',
                                prefix: Icons.person,
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
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                hintText: 'Phone Number',
                                prefix: Icons.phone,
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
                                prefix: Icons.lock,
                                isPassword: !SignUpCubit.get(context).showPassword ? true : false,
                                validate: (value)
                                {
                                  if(value!.isEmpty)
                                    return'Password must be filled';
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
                              text: 'SIGN UP',
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
                                  'Already have an Account?',style: TextStyle(color: Colors.black.withOpacity(0.5)),
                                ),
                                TextButton(
                                    onPressed: () {
                                      pop(context);
                                    },
                                    child: Text('Sign In')
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
            );
          },
        )
    );
  }
}
