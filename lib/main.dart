import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'shared/components/constants.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// If you're going to use other Firebase services in the background, such as Firestore,
  /// make sure you call `initializeApp` before using other Firebase services.
  /// await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  showToast(text: 'fcm background', state: ToastStates.SUCCESS);
}

void main() {
  BlocOverrides.runZoned(
    () async {
      //we must add this method when the main is async or contains it
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      // HttpOverrides.global = MyHttpOverrides();
      await CacheHelper.init();

      //get fcm token
      var fcmToken = await FirebaseMessaging.instance.getToken();
      print(fcmToken);

      ///forground fcm
      FirebaseMessaging.onMessage.listen((event) {
        print(event.notification!.toMap().toString());
        showToast(
            text: 'on message ${event.notification!.title}',
            state: ToastStates.SUCCESS);
      });

      ///when click on notification to open the app
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print(event.notification!.toMap().toString());
        showToast(text: 'on message open', state: ToastStates.SUCCESS);
      });

      ///background fcm
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      Widget startWidget;
      String? uId = CacheHelper.getData('uId');
      if (uId != null) {
        UID = uId;
        startWidget = HomeLayout();
      } else {
        startWidget = LoginScreen();
      }
      runApp(MyApp(startWidget: startWidget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  Widget startWidget;
  MyApp({Key? key, required this.startWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getUserData()
        ..getPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
