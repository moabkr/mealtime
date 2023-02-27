import 'package:flutter/material.dart';
import 'package:mealtime/models/constants.dart';
import 'package:mealtime/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mealtime',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: whiteColor,
        primaryColor: blackColor,
      ),
      home: const HomeScreen(),
    );
  }
}
