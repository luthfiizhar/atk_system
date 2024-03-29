// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGN2Ra2qMFbfXDntNREKbSX_FCIVjOY24',
    appId: '1:859847250491:web:01da83d273e3fbdc83021e',
    messagingSenderId: '859847250491',
    projectId: 'gss-project-dev',
    authDomain: 'gss-project-dev.firebaseapp.com',
    databaseURL: 'https://gss-project-dev-default-rtdb.firebaseio.com',
    storageBucket: 'gss-project-dev.appspot.com',
    measurementId: 'G-H4YP5V6XC8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMgjj_0qP8PAPR5iGom_mgx799RTdFDXo',
    appId: '1:859847250491:android:9482fffc7d0550da83021e',
    messagingSenderId: '859847250491',
    projectId: 'gss-project-dev',
    databaseURL: 'https://gss-project-dev-default-rtdb.firebaseio.com',
    storageBucket: 'gss-project-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmmTXkFN6ibDwS152J69K5PdGc3LQfE7g',
    appId: '1:859847250491:ios:060d6bb2932d667483021e',
    messagingSenderId: '859847250491',
    projectId: 'gss-project-dev',
    databaseURL: 'https://gss-project-dev-default-rtdb.firebaseio.com',
    storageBucket: 'gss-project-dev.appspot.com',
    iosClientId: '859847250491-9n11hbagarr8t98q8f0iqp9kr00lk9k2.apps.googleusercontent.com',
    iosBundleId: 'com.example.atkSystemGa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDmmTXkFN6ibDwS152J69K5PdGc3LQfE7g',
    appId: '1:859847250491:ios:060d6bb2932d667483021e',
    messagingSenderId: '859847250491',
    projectId: 'gss-project-dev',
    databaseURL: 'https://gss-project-dev-default-rtdb.firebaseio.com',
    storageBucket: 'gss-project-dev.appspot.com',
    iosClientId: '859847250491-9n11hbagarr8t98q8f0iqp9kr00lk9k2.apps.googleusercontent.com',
    iosBundleId: 'com.example.atkSystemGa',
  );
}
