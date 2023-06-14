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
    apiKey: 'AIzaSyB_xHZbx4RFZoSEYD2DkwMMfLZ-NOlTMps',
    appId: '1:297019898515:web:c6c1c4bfa55b8b2618ab66',
    messagingSenderId: '297019898515',
    projectId: 'ncti-3f720',
    authDomain: 'ncti-3f720.firebaseapp.com',
    storageBucket: 'ncti-3f720.appspot.com',
    measurementId: 'G-9PZC28KNDM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSKRvW1YcaLJrKucqoVHueqCaRONdDN_8',
    appId: '1:297019898515:android:a390edee6f04046a18ab66',
    messagingSenderId: '297019898515',
    projectId: 'ncti-3f720',
    storageBucket: 'ncti-3f720.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCIpKWIWVSW6zH56AfHkxhjMQypifZapZE',
    appId: '1:297019898515:ios:be7153df853be67d18ab66',
    messagingSenderId: '297019898515',
    projectId: 'ncti-3f720',
    storageBucket: 'ncti-3f720.appspot.com',
    iosClientId: '297019898515-8u5chtd3mtdfshiohkjnmmrg0bv68mv2.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.messaging',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCIpKWIWVSW6zH56AfHkxhjMQypifZapZE',
    appId: '1:297019898515:ios:be7153df853be67d18ab66',
    messagingSenderId: '297019898515',
    projectId: 'ncti-3f720',
    storageBucket: 'ncti-3f720.appspot.com',
    iosClientId: '297019898515-8u5chtd3mtdfshiohkjnmmrg0bv68mv2.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.messaging',
  );
}