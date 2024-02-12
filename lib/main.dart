import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample/views/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyA4N-gNqDB61TdG8LLaZ82Fuj2Bdj2yOxg', // 実際のAPIキーに置き換えてください
      appId: '1:699499151200:web:47500e35f363cc717ce805', // 実際のアプリIDに置き換えてください
      messagingSenderId: '699499151200', // 実際のメッセージ送信者IDに置き換えてください
      projectId: 'maps-b171f', // 実際のプロジェクトIDに置き換えてください
    ),
  );
  final UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp(userId: userCredential.user!.uid));
}

class MyApp extends StatelessWidget {
  final String userId;

  const MyApp({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(userId: userId),
    );
  }
}
