import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';
class ResetPasswordCubit extends Cubit<SocialStates> {
  ResetPasswordCubit() : super(InitialState());

  static ResetPasswordCubit get(context) => BlocProvider.of(context);


  void resetPassword({
    required String email,
  })
  {
    emit(ResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
    ).then((value) {
      emit(ResetPasswordSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ResetPasswordErrorState());
    });
  }
    
}


