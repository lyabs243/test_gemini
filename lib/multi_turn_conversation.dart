import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

class MultiTurnConversation extends StatefulWidget {

  const MultiTurnConversation({super.key});

  @override
  MultiTurnConversationState createState() => MultiTurnConversationState();
}

class MultiTurnConversationState extends State<MultiTurnConversation> {

  bool loading = false;
  List<MessageItem> messages = [];
  late final ChatSession chat;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 100)
    );

    messages = [
      MessageItem('Hello how can I help you?', false),
      MessageItem('Hello,', true),
    ];

    chat = model.startChat(
      history: List.generate(messages.reversed.length, (index) => messages.reversed.toList()[index].content),
    );
  }

  @override
  Widget build(BuildContext context) {

    int totalMessages = messages.length;
    if (loading) {
      totalMessages++;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-turn conversation'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: totalMessages,
                reverse: true,
                itemBuilder: (context, index) {

                  if (index == 0 && loading) {
                    return loadingWidget;
                  }

                  int messageIndex = index;
                  if (loading) {
                    messageIndex--;
                  }

                  return getBubble(
                    messages[messageIndex].text,
                    messages[messageIndex].isSender,
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: () {
                    send(controller.text);
                  },
                  child: Icon(
                    Icons.send,
                    color: (loading)? Colors.grey: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  send(String input) async {
    if (loading) {
      return;
    }

    controller.clear();
    setState(() {
      loading = true;
    });

    MessageItem newMessage = MessageItem(input, true);

    setState(() {
      messages.insert(0, MessageItem(input, true));
    });

    final response = await chat.sendMessage(newMessage.content);

    if (response.text?.isNotEmpty?? false) {
      messages.insert(0, MessageItem(response.text!, false));
    }

    setState(() {
      loading = false;
    });
  }

  Widget getBubble(String text, bool isSender,) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: BubbleSpecialThree(
        text: text,
        color: (isSender)? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        tail: false,
        isSender: isSender,
        textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16
        ),
      ),
    );
  }

  Widget get loadingWidget {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      alignment: Alignment.centerLeft,
      child: Lottie.asset(
        'assets/animations/typing.json',
        height: 80,
      ),
    );
  }

}

class MessageItem {

  final String text;
  final bool isSender;

  MessageItem(this.text, this.isSender);

  Content get content {
    if (isSender) {
      return Content.text(text,);
    }
    return Content.model([TextPart(text)]);
  }

}