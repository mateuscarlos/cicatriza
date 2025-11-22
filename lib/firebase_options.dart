// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for the Cicatriza application.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// Returns the set of [FirebaseOptions] for the current platform.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. '
        'Run "flutterfire configure" to generate firebase_options.dart for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Android [FirebaseOptions].
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmbo3grB4WcrBswQ0HUNKvS7ylXFvbLgY',
    appId: '1:48729747381:android:57192ff1f79b281c93b3fc',
    messagingSenderId: '48729747381',
    projectId: 'cicatriza-dev-b1085',
    storageBucket: 'cicatriza-dev-b1085.firebasestorage.app',
  );

  /// iOS [FirebaseOptions].
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAa2l0DZHHRxwdi6Wp6y6daJ25-v2-3qGs',
    appId: '1:48729747381:ios:fb7edfded0ee207893b3fc',
    messagingSenderId: '48729747381',
    projectId: 'cicatriza-dev-b1085',
    storageBucket: 'cicatriza-dev-b1085.firebasestorage.app',
    iosClientId:
        '48729747381-1qqkmh8vagrjevc4fbihpa42t13t3fp9.apps.googleusercontent.com',
    iosBundleId: 'com.example.cicatriza',
  );

  /// macOS shares the same configuration as iOS for this project.
  static const FirebaseOptions macos = ios;
}
