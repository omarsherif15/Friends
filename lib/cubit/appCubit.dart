import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';

class AppCubit extends Cubit<SocialStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);


}