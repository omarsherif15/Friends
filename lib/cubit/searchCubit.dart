import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/states.dart';


class SearchCubit extends Cubit<SocialStates> {
  SearchCubit() : super(InitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  // SearchModel? searchModel;
  // void getSearchData(String searchText){
  //   emit(SearchLoadingState());
  //   DioHelper.postData(
  //       url: SEARCH,
  //       token: token,
  //       data: {
  //         'text':'$searchText',
  //       }
  //   ).then((value){
  //     searchModel = SearchModel.fromJson(value.data);
  //     print('Search '+searchModel!.status.toString());
  //     emit(SearchSuccessState());
  //   }).catchError((error){
  //     emit(SearchErrorState());
  //     print(error.toString());
  //   });
  // }
}