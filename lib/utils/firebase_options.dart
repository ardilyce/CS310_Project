// File generated using Firebase Console configuration
// To get your Firebase config:
// 1. Go to Firebase Console: https://console.firebase.google.com/
// 2. Select your project
// 3. Go to Project Settings (⚙️ icon)
// 4. Scroll down to "Your apps" section
// 5. For each platform (Android, iOS, Web), copy the configuration values

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
        return ios;
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
    apiKey: 'AIzaSyAVI3e_gm1G0U9NnT6PwcQ-XLSBmDLs2Ew',
    appId: '1:984406170734:web:3ec4ad254e877740941a7f',
    messagingSenderId: '984406170734',
    projectId: 'phishguard-app-cs310',
    authDomain: 'phishguard-app-cs310.firebaseapp.com',
    storageBucket: 'phishguard-app-cs310.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCINSNS3p0G9r3J47IRo82kYV8NJq3iwho',
    appId: '1:984406170734:android:f3464867c06f3f16941a7f',
    messagingSenderId: '984406170734',
    projectId: 'phishguard-app-cs310',
    storageBucket: 'phishguard-app-cs310.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.project',
  );
}
