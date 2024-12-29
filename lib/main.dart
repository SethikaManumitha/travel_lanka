import 'package:flutter/material.dart';
import 'package:travel_lanka/services/FirebaseService.dart';
import "view/HomePage.dart";
import 'package:travel_lanka/view/MainPage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Lanka',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
