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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB8M1zGyMokM885U2Ye41uFHBTmURJQns0',
    appId: '1:317042953274:android:6fa78ec780a9ea9c3cf903',
    messagingSenderId: '317042953274',
    projectId: 'elawapp-b43ad',
    storageBucket: 'elawapp-b43ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAQxBmiuSQf6MgIAMxXBzCpgFnuk71x-yM',
    appId: '1:317042953274:ios:554b0bd11526b1a83cf903',
    messagingSenderId: '317042953274',
    projectId: 'elawapp-b43ad',
    storageBucket: 'elawapp-b43ad.appspot.com',
    androidClientId: '317042953274-i8fstrgte00jd1u08862ld110nq8n76o.apps.googleusercontent.com',
    iosClientId: '317042953274-priaoeepfhbe3nto81jdt1snr26lhvhq.apps.googleusercontent.com',
    iosBundleId: 'com.example.lawApp',
  );
}
