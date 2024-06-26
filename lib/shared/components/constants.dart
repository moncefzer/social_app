import 'dart:io';

import 'package:social_app/layout/cubit/app_cubit.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

/// const String newsApiKey = 'e0c22cd4e7a049a7a87c74b79e007e59';
const String NEWSAPIKEY = '2b3f7d1043a54311b43d176f5ffafc5d';
const String NEWSAPIURL = 'https://newsapi.org/';
const String SHOPAPIURL = 'https://student.valuxapps.com/api/';
const String urlToNoImageAvailable =
    'https://demofree.sirv.com/nope-not-here.jpg';

const String urlToDefaultProfileImage =
    "https://img.freepik.com/premium-photo/little-boy-eats-ice-cream-cone-blue-background-with-free-space-copying-text_548699-1714.jpg?w=1060";
const String urlToDefaultCoverImage =
    "https://img.freepik.com/premium-photo/little-boy-eats-ice-cream-cone-blue-background-with-free-space-copying-text_548699-1714.jpg?w=1060";
const String defaultBioText = 'write your bio ...';
const String SHOPAPPLANG = 'en';

String TOKEN = '';

String UID = '';

///here i had modified this fonction to get an image
/// here is the link to stackoverflow article
/// and i must call it in the main function
/// https://stackoverflow.com/questions/72532835/cant-fetch-networkimage-for-flutter-from-google-cloud-storage-bucket
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void signOut(context) {
  CacheHelper.removeData('uId').then((value) {
    if (value) {
      navigatoAndFinish(context: context, widget: LoginScreen());
      AppCubit.get(context).currentIndex = 0;
    }
  });
}

///if we want to use sendverification email
//if (!FirebaseAuth.instance.currentUser!.emailVerified)
//   Container(
//     color: Colors.amber.withOpacity(0.7),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(
//           horizontal: defaultPadding),
//       child: Row(
//         children: [
//           Icon(Icons.info_outline),
//           SizedBox(
//             width: 10,
//           ),
//           Text('please verify you email'),
//           Spacer(),
//           defaultTextButton(
//               onPressed: () {
//                 FirebaseAuth.instance.currentUser!
//                     .sendEmailVerification()
//                     .then((value) {
//                   showToast(
//                       text: 'check your email',
//                       state: ToastStates.SUCCESS);
//                 }).catchError((error) {
//                   print(error.toString());
//                 });
//               },
//               text: 'send'),
//         ],
//       ),
//     ),
//   ),
