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
    apiKey: 'AIzaSyBKZV4Ymhn4q1dXFoE-ctBHbqj80lOg_BM',
    appId: '1:782408760749:android:6459354ed9e9d2bf57b524',
    messagingSenderId: '782408760749',
    projectId: 'bandapp-18967',
    storageBucket: 'bandapp-18967.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYVCgRJKiMFw4FuXvRj2MR19VKEPMlN5k',
    appId: '1:782408760749:ios:280a59e38fb4754657b524',
    messagingSenderId: '782408760749',
    projectId: 'bandapp-18967',
    storageBucket: 'bandapp-18967.appspot.com',
    androidClientId: '782408760749-ar2i1bo0e140aq4ot4df9r6495898obq.apps.googleusercontent.com',
    iosClientId: '782408760749-8ge54k4nq4oa13dvbj8scaet2t7is724.apps.googleusercontent.com',
    iosBundleId: 'com.example.myAudioFlutter',
  );
}
