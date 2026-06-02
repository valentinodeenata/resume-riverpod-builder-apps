// IMPORTANT: This file is a placeholder.
// Run `flutterfire configure` to generate the real version after
// linking your Firebase project.
//
// Steps:
//   1. Install FlutterFire CLI:  dart pub global activate flutterfire_cli
//   2. Run:                      flutterfire configure
//   3. Select your Firebase project and platforms (Android, Web)
//   4. This file will be overwritten with real API keys.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform. '
          'Run `flutterfire configure` to generate real options.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBq9TNU4lCccr939dPodD_JU5YP-OPoXmo',
    appId: '1:1014447504546:web:5710e7f6c9345903ce2bfb',
    messagingSenderId: '1014447504546',
    projectId: 'resume-builder-apps',
    authDomain: 'resume-builder-apps.firebaseapp.com',
    storageBucket: 'resume-builder-apps.firebasestorage.app',
    measurementId: 'G-Q7QWZZTNVH',
  );

  // TODO: Replace with real values from `flutterfire configure`

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-OdEkH9sIB3N9H8vm1N89CgqOFRhngJU',
    appId: '1:1014447504546:android:c6d57411b0ef23b5ce2bfb',
    messagingSenderId: '1014447504546',
    projectId: 'resume-builder-apps',
    storageBucket: 'resume-builder-apps.firebasestorage.app',
  );

}