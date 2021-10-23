import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';

class AppCubit extends Cubit<SocialStates>{
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);


}