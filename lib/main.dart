import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:xcare/login/login.dart';
import 'package:xcare/medical_home_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late WebSocketChannel channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('wss://ai-x-care.future-developers.cloud/ws/chatAI/1212/?!xx!?secureKey=team_x_care!xx!'),
      );

      channel.stream.listen(
        (message) {
          final decodedMessage = jsonDecode(message);
          setState(() {
            _isLoading = false;
            _messages.add({'message': decodedMessage['bot_message'], 'sentByUser': false});
          });
        },
        onError: (error) {
          print('WebSocket error: $error');
          setState(() {
            _isLoading = false; // Update loading state if needed
          });
        },
        onDone: () {
          print('WebSocket closed');
          // You might want to reconnect here depending on your app logic
        },
      );
    } catch (e) {
      print('WebSocket connection error: $e');
      setState(() {
        _isLoading = false; // Update loading state if needed
      });
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage(String message) {
    final data = {
      'session': '1122',
      'profile_id': 1,
      'message': message,
      'filename': null,
      'imageData': null,
    };

    setState(() {
      _messages.add({'message': message, 'sentByUser': true});
      _isLoading = true;
    });

    channel.sink.add(jsonEncode(data));
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot'),
        backgroundColor: const Color(0xFF1AB1DD),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/Pasted Graphic.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            color: const Color.fromARGB(38, 0, 0, 0).withOpacity(0.4),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = _messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: message['sentByUser']
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: message['sentByUser'] ? Colors.blue : Colors.green,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Text(
                                message['message'] ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(210, 84, 182, 243),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.white, fontSize: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          controller: _textEditingController,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (String message) {
                            if (message.isNotEmpty) {
                              _sendMessage(message);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final message = _textEditingController.text;
                          if (message.isNotEmpty) {
                            _sendMessage(message);
                          }
                        },
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkAuthToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'Chat Page',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return MaterialApp(
              title: 'Chat Page',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MedicalHomePage(),
            );
          } else {
            return MaterialApp(
              title: 'Chat Page',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const LoginPage(),
            );
          }
        }
      },
    );
  }

  Future<String?> _checkAuthToken() async {
    final storage = const FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }
}
