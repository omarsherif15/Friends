import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/userModel.dart';
class LoginCubit extends Cubit<SocialStates> {
  LoginCubit() : super(InitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  UserModel? loginModel;
  void signIn({
    required String email,
    required String password,
  })
  {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
  ).then((value) {
          emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState());
    });
  }



  bool showPassword = false;
  IconData suffixIcon = Icons.visibility_off;
  void changeSuffixIcon(context){
    showPassword =! showPassword;
    if(showPassword)
      suffixIcon = Icons.visibility;
    else
      suffixIcon = Icons.visibility_off;
    emit(ChangeSuffixIconState());
  }

    
}


