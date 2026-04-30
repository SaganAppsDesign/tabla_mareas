import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9OPGQ83---QqizRRl_GAmL4v3IfqV8Qw',
    appId: '1:16330295907:web:273d59b4bce6096a408656',
    messagingSenderId: '16330295907',
    projectId: 'tabla-mareas',
    authDomain: 'tabla-mareas.firebaseapp.com',
    storageBucket: 'tabla-mareas.firebasestorage.app',
    measurementId: 'G-NM6Y05XQEY',
  );
}
