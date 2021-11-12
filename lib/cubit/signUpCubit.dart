import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/models/userModel.dart';

class SignUpCubit extends Cubit<SocialStates> {
  SignUpCubit() : super(InitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  // late UserModel signInModel;

  void signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      print(value.user!.uid);
      createUser(
          uId: value.user!.uid,
          name: name,
          phone: phone,
          email: email,
      );
      emit(SignUpSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(SignUpErrorState());
    });
  }

  


  void createUser({
    required String? uId,
    required String? name,
    required String? phone,
    required String? email,
  }) {
    emit(CreateUserLoadingState());
    UserModel model = UserModel(
        uID: uId,
        name: name,
        phone: phone,
        email: email,
        dateTime: FieldValue.serverTimestamp(),
        coverPic: 'https://media.cdnandroid.com/27/54/bb/52/imagen-cartoon-photo-editor-art-filter-2018-1gal.jpg',
        profilePic: 'https://static.toiimg.com/thumb/resizemode-4,msid-76729536,width-1200,height-900/76729536.jpg',
        bio: 'Write you own bio...'
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState(uId!));
    }).catchError((error) {
      emit(CreateUserErrorState());
    });
  }

  bool showPassword = false;
  IconData suffixIcon = Icons.visibility_off;

  void changeSuffixIcon(context) {
    showPassword = !showPassword;
    if (showPassword)
      suffixIcon = Icons.visibility;
    else
      suffixIcon = Icons.visibility_off;
    emit(ChangeSuffixIconState());
  }
}