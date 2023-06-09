import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tensai3/resume.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tensai3/login.dart';
import 'package:tensai3/components.dart';
import 'package:tensai3/list.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyAVRlXeBLcVfcolUId7hDb7jRuKJR4ErIM",
        appId: "1:648049871852:web:62740b30a874209c9a4ec9",
        messagingSenderId: "648049871852",
        projectId: "tensai3-afe03",
        authDomain: "tensai3-afe03.firebaseapp.com",
        databaseURL: "https://tensai3-afe03-default-rtdb.firebaseio.com",
        storageBucket: "tensai3-afe03.appspot.com",
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}