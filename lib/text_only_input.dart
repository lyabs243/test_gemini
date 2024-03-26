import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TextOnlyInput extends StatefulWidget {

  const TextOnlyInput({super.key});

  @override
  TextOnlyInputState createState() => TextOnlyInputState();
}

class TextOnlyInputState extends State<TextOnlyInput> {

  String input = '';
  String output = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text-only input'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Input text',
              ),
              onChanged: (value) {
                input = value;
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: generateText,
              child: const Text('Generate text'),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Text(output),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateText() async {
    setState(() {
      loading = true;
    });
    const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
    // user gemini-pro model
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final content = [Content.text(input)];
    final response = await model.generateContent(content);
    setState(() {
      output = response.text?? 'No response';
      loading = false;
    });
  }

}