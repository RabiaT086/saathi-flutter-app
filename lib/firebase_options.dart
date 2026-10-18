// File generated for antiharassmentapp.
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
    apiKey: 'AIzaSyBZBG3QkmHJwyx0EA1q0ljNoHmw-MXRgSQ',
    appId: '1:1078804441521:web:67adc0bf98f6816517f590',
    messagingSenderId: '1078804441521',
    projectId: 'antiharassmentapp',
    authDomain: 'antiharassmentapp.firebaseapp.com',
    storageBucket: 'antiharassmentapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZBG3QkmHJwyx0EA1q0ljNoHmw-MXRgSQ',
    appId: '1:1078804441521:android:67adc0bf98f6816517f590',
    messagingSenderId: '1078804441521',
    projectId: 'antiharassmentapp',
    storageBucket: 'antiharassmentapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZBG3QkmHJwyx0EA1q0ljNoHmw-MXRgSQ',
    appId: '1:1078804441521:ios:67adc0bf98f6816517f590',
    messagingSenderId: '1078804441521',
    projectId: 'antiharassmentapp',
    storageBucket: 'antiharassmentapp.firebasestorage.app',
    iosBundleId: 'com.example.saathiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZBG3QkmHJwyx0EA1q0ljNoHmw-MXRgSQ',
    appId: '1:1078804441521:ios:67adc0bf98f6816517f590',
    messagingSenderId: '1078804441521',
    projectId: 'antiharassmentapp',
    storageBucket: 'antiharassmentapp.firebasestorage.app',
    iosBundleId: 'com.example.saathiApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZBG3QkmHJwyx0EA1q0ljNoHmw-MXRgSQ',
    appId: '1:1078804441521:web:67adc0bf98f6816517f590',
    messagingSenderId: '1078804441521',
    projectId: 'antiharassmentapp',
    authDomain: 'antiharassmentapp.firebaseapp.com',
    storageBucket: 'antiharassmentapp.firebasestorage.app',
  );
}
