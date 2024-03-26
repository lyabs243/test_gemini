import 'dart:math';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MultiTurnConversation extends StatefulWidget {

  const MultiTurnConversation({super.key});

  @override
  MultiTurnConversationState createState() => MultiTurnConversationState();
}

class MultiTurnConversationState extends State<MultiTurnConversation> {

  String input = '';
  String output = '';
  bool loading = true;

  @override
  Widget build(BuildContext context) {

    int totalMessages = 20;
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
                    'Hello world $messageIndex' * 3,
                    Random().nextBool(),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      input = value;
                    },
                  ),
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: () {
                    // send message
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