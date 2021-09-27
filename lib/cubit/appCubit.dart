import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';

class AppCubit extends Cubit<SocialStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  ThemeMode appMode = ThemeMode.light;

  void changeMode({fromCache}) {
    if(fromCache == null)
      isDark =!isDark;
    else
      isDark = fromCache;
    emit(ChangeModeState());
    CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
      if(isDark)
        appMode = ThemeMode.dark;
      else
        appMode = ThemeMode.light;
      emit(ChangeModeState());
    });

  }
}