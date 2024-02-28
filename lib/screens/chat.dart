import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.logout});

  final void Function() logout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room"),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Disconnect',
              onPressed: logout),
        ],
      ),
      body: const Center(child: Text('welcome')),
    );
  }
}
