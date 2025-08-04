import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDnp4lYp237nRp8OYfgtXcLGgENfk8crKc",
    authDomain: "clinic-review-2d919.firebaseapp.com",
    projectId: "clinic-review-2d919",
    storageBucket: "clinic-review-2d919.appspot.com", //  FIXED
    messagingSenderId: "1084289029549",
    appId: "1:1084289029549:web:317623e60229622fd5fd24",
  );
}

