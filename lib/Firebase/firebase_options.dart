// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAWlDvWu_TzByxR3ToeIp6vl9s3c_K96fA',
    appId: '1:760903643072:web:24f477410bc7f6845aa225',
    messagingSenderId: '760903643072',
    projectId: 'emosense-4f21e',
    authDomain: 'emosense-4f21e.firebaseapp.com',
    storageBucket: 'emosense-4f21e.firebasestorage.app',
    measurementId: 'G-GFCC1HK9KQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCB6aUFeQwSuqwlQ8U8otlwXLxOs_uq2OY',
    appId: '1:760903643072:android:b336651b0559bb1c5aa225',
    messagingSenderId: '760903643072',
    projectId: 'emosense-4f21e',
    storageBucket: 'emosense-4f21e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBziQ-TehCxl9MUT8IqWSltub7dQWkJO18',
    appId: '1:760903643072:ios:3eb5e3799caf7f515aa225',
    messagingSenderId: '760903643072',
    projectId: 'emosense-4f21e',
    storageBucket: 'emosense-4f21e.firebasestorage.app',
    iosBundleId: 'com.example.emoSense',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBziQ-TehCxl9MUT8IqWSltub7dQWkJO18',
    appId: '1:760903643072:ios:3eb5e3799caf7f515aa225',
    messagingSenderId: '760903643072',
    projectId: 'emosense-4f21e',
    storageBucket: 'emosense-4f21e.firebasestorage.app',
    iosBundleId: 'com.example.emoSense',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAWlDvWu_TzByxR3ToeIp6vl9s3c_K96fA',
    appId: '1:760903643072:web:31dcf9c684c64dd45aa225',
    messagingSenderId: '760903643072',
    projectId: 'emosense-4f21e',
    authDomain: 'emosense-4f21e.firebaseapp.com',
    storageBucket: 'emosense-4f21e.firebasestorage.app',
    measurementId: 'G-5RCNCM46X2',
  );
}
