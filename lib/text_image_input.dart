import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TextImageInput extends StatefulWidget {

  const TextImageInput({super.key});

  @override
  TextImageInputState createState() => TextImageInputState();
}

class TextImageInputState extends State<TextImageInput> {

  String input = '';
  String output = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text and image input'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
              const SizedBox(height: 10,),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset('assets/images/image-input-1.png', fit: BoxFit.contain, height: 120,),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Image.asset('assets/images/image-input-2.png', fit: BoxFit.contain, height: 120,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Image.asset('assets/images/image-input-3.png', fit: BoxFit.contain, height: 120,),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: generateText,
                child: const Text('Generate text'),
              ),
              const SizedBox(height: 20,),
              (loading) ?
              const Center(
                child: CircularProgressIndicator(),
              ) :
              Text(output),
            ],
          ),
        ),
      ),
    );
  }

  generateText() async {
    setState(() {
      loading = true;
    });
    const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');

    // for text and image input, use gemini-pro-vision model
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final (firstImage, secondImage, thirdImage) = await (
      getImageBytes('assets/images/image-input-1.png'),
      getImageBytes('assets/images/image-input-2.png'),
      getImageBytes('assets/images/image-input-3.png'),
    ).wait;

    if (firstImage == null || secondImage == null || thirdImage == null) {
      setState(() {
        output = 'Error loading images';
        loading = false;
      });
      return;
    }

    final response = await model.generateContent([
      Content.multi(
        [
          TextPart(input),
          DataPart('image/png', firstImage),
          DataPart('image/png', secondImage),
          DataPart('image/png', thirdImage),
        ]
      )
    ]);

    setState(() {
      output = response.text?? 'No response';
      loading = false;
    });
  }

  Future<Uint8List?> getImageBytes(String assetPath) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);
      return byteData.buffer.asUint8List();
    }
    catch (e) {
      debugPrint('Error loading image: $e');
    }
    return null;
  }

}