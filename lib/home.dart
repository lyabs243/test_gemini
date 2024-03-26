import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_gemini/text_only_input.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String? apiKey = const String.fromEnvironment('API_KEY', defaultValue: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (apiKey == null || apiKey!.isEmpty) {
      // ignore: avoid_print
      print('No \$API_KEY environment variable');
      exit(1);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)
                  => const TextOnlyInput()));
              },
              child: const Text('Generate text from text-only input'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Generate text from text-and-image input (multimodal)'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Build multi-turn conversations (chat)'),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
              },
              child: const Text('Use streaming for faster interactions'),
            ),
          ],
        ),
      ),
    );
  }
}