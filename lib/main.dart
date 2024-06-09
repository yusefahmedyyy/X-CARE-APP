import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  final ScrollController _scrollController = ScrollController();
  late WebSocketChannel channel;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

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
            _scrollToBottom();
          });
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket closed');
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (channel.closeCode == null) {
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
        _scrollToBottom();
      });

      channel.sink.add(jsonEncode(data));
      _textEditingController.clear();
    } else {
      print('Cannot send message, WebSocket is closed.');
    }
  }

  void _sendImage(File image) {
    if (channel.closeCode == null) {
      final bytes = image.readAsBytesSync();
      final base64Image = base64Encode(bytes);
      final data = {
        'session': '1122',
        'profile_id': 1,
        'message': null,
        'filename': image.path.split('/').last,
        'imageData': base64Image,
      };

      setState(() {
        _messages.add({'message': 'Image: ${image.path.split('/').last}', 'sentByUser': true});
        _isLoading = true;
        _scrollToBottom();
      });

      channel.sink.add(jsonEncode(data));
    } else {
      print('Cannot send image, WebSocket is closed.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _sendImage(File(pickedFile.path));
      }
    } catch (e) {
      print('Image picking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Bot',style: TextStyle(color: Colors.white,),),
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
                  controller: _scrollController,
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
                      IconButton(
                        icon: const Icon(Icons.image, color: Colors.white),
                        onPressed: _pickImage,
                      ),
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