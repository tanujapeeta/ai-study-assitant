import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
const AIChatScreen({super.key});

@override
State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
final TextEditingController messageController =
TextEditingController();

final ScrollController scrollController = ScrollController();

final List<Map<String, String>> messages = [];

bool isLoading = false;

// Backend URL
static const String baseUrl = 'http://127.0.0.1:8000';

Future<void> sendMessage() async {
final text = messageController.text.trim();

if (text.isEmpty || isLoading) return;

messageController.clear();

setState(() {
messages.add({
'sender': 'user',
'message': text,
});
isLoading = true;
});

_scrollToBottom();

try {
final response = await http
    .post(
Uri.parse('$baseUrl/chat'),
headers: {
'Content-Type': 'application/json',
},
body: jsonEncode({
'message': text,
}),
)
    .timeout(const Duration(seconds: 60));

if (!mounted) return;

if (response.statusCode == 200) {
final data = jsonDecode(response.body);

String answer = '';

if (data is Map) {
answer = (data['response'] ??
data['message'] ??
data['answer'] ??
'')
    .toString();
}

if (answer.isEmpty) {
answer = 'The server returned no answer.';
}

setState(() {
messages.add({
'sender': 'ai',
'message': answer,
});
});
} else {
setState(() {
messages.add({
'sender': 'ai',
'message':
'Server error: ${response.statusCode}. '
'Please check your backend.',
});
});
}
} catch (e) {
if (!mounted) return;

setState(() {
messages.add({
'sender': 'ai',
'message':
'Cannot connect to the backend. '
'Please start your Python backend and try again.',
});
});
} finally {
if (mounted) {
setState(() {
isLoading = false;
});
_scrollToBottom();
}
}
}

void _scrollToBottom() {
WidgetsBinding.instance.addPostFrameCallback((_) {
if (scrollController.hasClients) {
scrollController.animateTo(
scrollController.position.maxScrollExtent,
duration: const Duration(milliseconds: 250),
curve: Curves.easeOut,
);
}
});
}

@override
void dispose() {
messageController.dispose();
scrollController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),
appBar: AppBar(
title: const Text('AI Study Chat'),
backgroundColor: Colors.white,
foregroundColor: const Color(0xFF172033),
),
body: Column(
children: [
Expanded(
child: messages.isEmpty
? const Center(
child: Padding(
padding: EdgeInsets.all(24),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.smart_toy_rounded,
size: 65,
color: Colors.blue,
),
SizedBox(height: 16),
Text(
'How can I help you?',
style: TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 8),
Text(
'Ask a question about Python, DBMS, '
'Maths, Science or another subject.',
textAlign: TextAlign.center,
),
],
),
),
)
    : ListView.builder(
controller: scrollController,
padding: const EdgeInsets.all(16),
itemCount: messages.length + (isLoading ? 1 : 0),
itemBuilder: (context, index) {
if (index == messages.length) {
return const Padding(
padding: EdgeInsets.all(12),
child: Row(
children: [
SizedBox(
width: 18,
height: 18,
child: CircularProgressIndicator(
strokeWidth: 2,
),
),
SizedBox(width: 12),
Text('AI is thinking...'),
],
),
);
}

final item = messages[index];
final isUser = item['sender'] == 'user';

return Align(
alignment: isUser
? Alignment.centerRight
    : Alignment.centerLeft,
child: Container(
constraints: const BoxConstraints(
maxWidth: 320,
),
margin: const EdgeInsets.only(bottom: 12),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: isUser
? const Color(0xFF2563EB)
    : Colors.white,
borderRadius: BorderRadius.circular(16),
),
child: Text(
item['message'] ?? '',
style: TextStyle(
color: isUser
? Colors.white
    : const Color(0xFF172033),
fontSize: 15,
height: 1.4,
),
),
),
);
},
),
),
Container(
color: Colors.white,
padding: const EdgeInsets.all(12),
child: SafeArea(
top: false,
child: Row(
children: [
Expanded(
child: TextField(
controller: messageController,
enabled: !isLoading,
textInputAction: TextInputAction.send,
onSubmitted: (_) => sendMessage(),
decoration: InputDecoration(
hintText: 'Ask your study question...',
filled: true,
fillColor: const Color(0xFFF1F4F9),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(24),
borderSide: BorderSide.none,
),
),
),
),
const SizedBox(width: 8),
IconButton(
onPressed: isLoading ? null : sendMessage,
icon: const Icon(
Icons.send_rounded,
color: Colors.blue,
),
),
],
),
),
),
],
),
);
}
}