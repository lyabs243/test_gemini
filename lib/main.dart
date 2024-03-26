import 'package:flutter/material.dart';
import 'package:test_gemini/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Gemini Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Gemini Demo'),
    );
  }
}
