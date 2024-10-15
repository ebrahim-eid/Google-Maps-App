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
    apiKey: 'AIzaSyCfZfJmi6sOb0tbM6N_7mCTH2zzMqfqvuA',
    appId: '1:457639952099:web:96aad134236ae2bb97cfd6',
    messagingSenderId: '457639952099',
    projectId: 'flutter-maps-8b0f3',
    authDomain: 'flutter-maps-8b0f3.firebaseapp.com',
    storageBucket: 'flutter-maps-8b0f3.appspot.com',
    measurementId: 'G-TJ86S63N7N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1jeYJyNljhylv3DDpshr7ncCRtWXkkYA',
    appId: '1:457639952099:android:2faed8b8861206c097cfd6',
    messagingSenderId: '457639952099',
    projectId: 'flutter-maps-8b0f3',
    storageBucket: 'flutter-maps-8b0f3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDi-PB0EduBXuvlHe5u2N0OpWvazRIqJE0',
    appId: '1:457639952099:ios:6ca0ca02ce27139197cfd6',
    messagingSenderId: '457639952099',
    projectId: 'flutter-maps-8b0f3',
    storageBucket: 'flutter-maps-8b0f3.appspot.com',
    iosBundleId: 'com.example.flutterMaps',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDi-PB0EduBXuvlHe5u2N0OpWvazRIqJE0',
    appId: '1:457639952099:ios:6ca0ca02ce27139197cfd6',
    messagingSenderId: '457639952099',
    projectId: 'flutter-maps-8b0f3',
    storageBucket: 'flutter-maps-8b0f3.appspot.com',
    iosBundleId: 'com.example.flutterMaps',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfZfJmi6sOb0tbM6N_7mCTH2zzMqfqvuA',
    appId: '1:457639952099:web:a0f359638a87de3d97cfd6',
    messagingSenderId: '457639952099',
    projectId: 'flutter-maps-8b0f3',
    authDomain: 'flutter-maps-8b0f3.firebaseapp.com',
    storageBucket: 'flutter-maps-8b0f3.appspot.com',
    measurementId: 'G-TKPJBYFFGD',
  );
}
