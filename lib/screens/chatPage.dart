import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.logout,
      required this.username,
      required this.id});

  final void Function() logout;
  final String username;
  final int id;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final _uuid = Uuid();
  bool _isDisposed = false;
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    super.initState();
    socket = IO.io('<Your Socket App>', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();
    socket.emit("join-room", ["room", widget.username]);
    socket.on('receive-message', _handleReceivedMessage);
  }

  @override
  void dispose() {
    _isDisposed = true;
    socket.disconnect();
    super.dispose();
  }

  void _handleReceivedMessage(dynamic data) {
    final receivedMessage = types.TextMessage(
      id: data['_id'],
      text: data['text'],
      author: types.User(
        id: data['user']['userId'],
        firstName: data['user']['name'],
      ),
    );
    _addMessage(receivedMessage);
  }

  void _addMessage(types.Message message) {
    if (!_isDisposed) {
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: _uuid.v4(),
      text: message.text,
    );

    _addMessage(textMessage);

    final socketMessage = {
      '_id': _uuid.v4(),
      'text': message.text,
      'createdAt': DateTime.now().toIso8601String(),
      'user': {
        '_id': 2,
        'userId': widget.id,
        'name': widget.username,
        'role': 'user',
      },
      'sent': true,
    };
    socket.emit('message', [socketMessage, "room"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Disconnect',
            onPressed: widget.logout,
          ),
        ],
      ),
      body: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          showUserAvatars: true,
          showUserNames: true,
          theme: const DefaultChatTheme(
            backgroundColor: Color.fromARGB(255, 240, 235, 235),
            inputMargin: EdgeInsets.all(10),
            inputPadding: EdgeInsets.all(11),
            inputBorderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(20),
            ),
          )),
    );
  }
}
