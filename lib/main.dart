import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterGemmaPlugin.instance.init(
    maxTokens: 512,
    temperature: 1.0,
    topK: 1,
    randomSeed: 1,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  String _currentResponse = '';

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Add user's message
    setState(() {
      _messages.add({'user': _controller.text});
      _controller.clear();
      _isTyping = true;
      _currentResponse = ''; // Reset current response for new message
    });

    final flutterGemma = FlutterGemmaPlugin.instance;
    final responseController = StreamController<String>();

    _scrollToBottom();

    // Start streaming tokens from the API
    final messages = <Message>[];
    messages.add(Message(text: _messages.last['user']!));
    flutterGemma.getChatResponseAsync(messages: messages).listen(
      (String? token) {
        if (token != null) {
          responseController.add(token);
        }
      },
      onDone: () {
        responseController.close();
      },
    );

    // Listen to the response stream and update the UI
    responseController.stream.listen(
      (String token) {
        setState(() {
          _currentResponse += token;
        });
      },
      onDone: () {
        // Add the completed AI response to the messages list
        setState(() {
          messages.add(Message(text: _currentResponse));
          _messages.add({'ai': _currentResponse});
          _isTyping = false;
        });
        _scrollToBottom(); // Ensure scrolling to bottom after response is complete
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat with Gemma'),
          backgroundColor: Colors.grey[900],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(_currentResponse),
                            ),
                          ),
                        );
                      }

                      final isUserMessage =
                          _messages[index].containsKey('user');
                      final message = isUserMessage
                          ? _messages[index]['user']!
                          : _messages[index]['ai']!;

                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: isUserMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? Colors.blue[700]
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'Copy') {
                                    Clipboard.setData(
                                        ClipboardData(text: message));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Copied to clipboard')),
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return ['Copy'].map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                                child: Text(message),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isTyping)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey[850],
                          ),
                          onSubmitted: (_) => _sendMessage(),
                          autofocus: true,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
