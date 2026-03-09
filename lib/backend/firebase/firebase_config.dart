import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBjAgDWhXgB4NpvHlp7jJXtO3zcTfuHHOU",
            authDomain: "co2e-eb9b9.firebaseapp.com",
            projectId: "co2e-eb9b9",
            storageBucket: "co2e-eb9b9.appspot.com",
            messagingSenderId: "235111100328",
            appId: "1:235111100328:web:13bbf8a40a437c355e779d",
            measurementId: "G-3GXNGSNC03"));
  } else {
    await Firebase.initializeApp();
  }
}
