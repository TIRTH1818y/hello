import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_history.dart';

void main() {
  runApp(const MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterPythonBackend(),
    );
  }
}

class FlutterPythonBackend extends StatefulWidget {
  const FlutterPythonBackend({super.key});

  @override
  _FlutterPythonBackendState createState() => _FlutterPythonBackendState();
}

class _FlutterPythonBackendState extends State<FlutterPythonBackend> {
  final String baseUrl = 'http://10.0.2.2:5000/api/data'; // Localhost URL
  final TextEditingController promptController = TextEditingController();

  // List to store chat messages
  final List<Map<String, String>> chatMessages = [];

  // ScrollController for ListView
  final ScrollController _scrollController = ScrollController();

  // Send data to the backend
  Future<void> sendData(String userMessage) async {
    setState(() {
      chatMessages.add({'sender': 'user', 'message': userMessage});
      _scrollToBottom(); // Scroll to the bottom after adding user's message
    });

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"message": userMessage}),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        setState(() {
          chatMessages.add({
            'sender': 'bot',
            'message': responseData['response'] ?? 'No response from server',
          });
          _scrollToBottom(); // Scroll to the bottom after adding bot's response
        });
      } else {
        setState(() {
          chatMessages.add({
            'sender': 'bot',
            'message': 'Failed to get a response: ${response.body}',
          });
          _scrollToBottom();
        });
      }
    } catch (error) {
      setState(() {
        chatMessages.add({'sender': 'bot', 'message': 'Error: $error'});
        _scrollToBottom();
      });
    }
  }

  // Function to scroll to the bottom of the ListView
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
  void dispose() {
    // Dispose of the ScrollController when the widget is removed
    _scrollController.dispose();
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: const Text('BoddyBot', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.cyan.shade800,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHistoryScreen(chatMessages),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
              color: Colors.yellow,
            ),
            tooltip: "Chat History",
          ),
          IconButton(
            onPressed: () {
              chatMessages.clear();

              setState(() {

              });
            },
            icon: const Icon(
              Icons.cleaning_services,
              color: Colors.yellow,
            ),
            tooltip: "Clear Chat",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach ScrollController
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final chat = chatMessages[index];
                final isUser = chat['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.greenAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat['message'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promptController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Chat With AI...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    String userMessage = promptController.text.trim();
                    if (userMessage.isNotEmpty) {
                      sendData(userMessage);
                      promptController.clear();
                    }
                  },
                  child: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
