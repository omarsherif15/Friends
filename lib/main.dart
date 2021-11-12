
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/cubit/socialCubit.dart';
import 'package:socialapp/cubit/states.dart';
import 'package:socialapp/layouts/sociallayout.dart';
import 'package:socialapp/modules/splashScreen.dart';
import 'package:socialapp/remoteNetwork/cacheHelper.dart';
import 'package:socialapp/remoteNetwork/dioHelper.dart';
import 'package:socialapp/shared/bloc_observer.dart';
import 'package:socialapp/shared/constants.dart';
import 'package:socialapp/shared/styles/themes.dart';
import 'modules/loginScreen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  //when the app is opened
  FirebaseMessaging.onMessage.listen((event) {});
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  // background notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();


  Widget widget;

  bool ?isDark = CacheHelper.getData('isDark');
  uId = CacheHelper.getData('uId');

    if (uId != null)
      widget = SocialLayout(0);
    else
      widget = LoginScreen();

    if(kDebugMode)
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);

  runApp(
      EasyLocalization(
        supportedLocales: [
          Locale('en'),
          Locale('ar')
        ],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp(
          isDark: isDark,
          startWidget: widget,
  ),
      ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  late final Widget startWidget;
  MyApp({this.isDark, required this.startWidget});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (context) => SocialCubit()..changeMode(fromCache: isDark),
      child:  BlocConsumer<SocialCubit,SocialStates>(
        listener:(context,state){},
        builder: (context,state) {
          return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
                splash: SplashScreen(),
                backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
                nextScreen: startWidget,
                splashTransition: SplashTransition.scaleTransition,
                animationDuration: Duration(milliseconds:2000),
            ),
            theme: lightMode(),
            darkTheme: darkMode(),
            themeMode:appMode
          );
        }
    )
    );
  }
}