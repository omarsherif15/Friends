import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/shared/bloc_observer.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/themes.dart';
import 'cubit/appCubit.dart';
import 'modules/loginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();


  Widget widget;

  bool ?isDark = CacheHelper.getData('isDark');
  uId = CacheHelper.getData('uId');

    if (uId != null)
      widget = SocialLayout(0);
    else
      widget = LoginScreen();

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(create:(context) =>AppCubit()),
          BlocProvider(create: (context) => SocialCubit()
            ..getUserData()
            //..getFriends(SocialCubit.get(context).model!.uID)
          )
        ],
        child: BlocConsumer<AppCubit,SocialStates>(
            listener:(context,state){},
            builder: (context,state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: startWidget,
                theme: lightMode(),
                darkTheme: darkMode(),
                themeMode: ThemeMode.light,
              );
            }
        )
    );
  }
}