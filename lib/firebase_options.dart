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
    apiKey: 'AIzaSyC6FGqqhr5dEWhT3EjrEp1a45Lg43M8Igg',
    appId: '1:242926044459:android:4167a83ea28b5d81c4b16e',
    messagingSenderId: '242926044459',
    projectId: 'yareechatapp',
    databaseURL: 'https://yareechatapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'yareechatapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFTt7o_T5ECN5qjCoLIREw1ZlPhW0gYSw',
    appId: '1:242926044459:ios:a093e20a1ba365c0c4b16e',
    messagingSenderId: '242926044459',
    projectId: 'yareechatapp',
    databaseURL: 'https://yareechatapp-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'yareechatapp.appspot.com',
    androidClientId: '242926044459-cgk8bqqehsnk45h5ha4arghviva01aq7.apps.googleusercontent.com',
    iosClientId: '242926044459-1td4s09tacam0t3ct0vt5vuh6mguoq2q.apps.googleusercontent.com',
    iosBundleId: 'com.example.yareeChatApp',
  );
}
