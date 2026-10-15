import 'package:flutter/material.dart';

class StudyPlannerScreen extends StatefulWidget {
const StudyPlannerScreen({super.key});

@override
State<StudyPlannerScreen> createState() =>
_StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
final TextEditingController _controller = TextEditingController();
final List<String> _tasks = [];
final List<bool> _completed = [];

void _addTask() {
final task = _controller.text.trim();

if (task.isEmpty) return;

setState(() {
_tasks.add(task);
_completed.add(false);
_controller.clear();
});

Navigator.pop(context);
}

void _showAddTaskDialog() {
_controller.clear();

showDialog(
context: context,
builder: (dialogContext) {
return AlertDialog(
title: const Text('Add Study Task'),
content: TextField(
controller: _controller,
autofocus: true,
decoration: const InputDecoration(
hintText: 'Enter your study task',
border: OutlineInputBorder(),
),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(dialogContext),
child: const Text('Cancel'),
),
ElevatedButton(
onPressed: _addTask,
child: const Text('Add'),
),
],
);
},
);
}

@override
void dispose() {
_controller.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
final completedCount =
_completed.where((done) => done).length;

return Scaffold(
appBar: AppBar(
title: const Text('Study Planner'),
),
floatingActionButton: FloatingActionButton(
onPressed: _showAddTaskDialog,
child: const Icon(Icons.add),
),
body: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'My Study Tasks',
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Text('Completed: $completedCount / ${_tasks.length}'),
const SizedBox(height: 12),
LinearProgressIndicator(
value: _tasks.isEmpty
? 0
    : completedCount / _tasks.length,
),
const SizedBox(height: 16),
Expanded(
child: _tasks.isEmpty
? const Center(
child: Text(
'No tasks yet. Tap + to add a task.',
),
)
    : ListView.builder(
itemCount: _tasks.length,
itemBuilder: (context, index) {
return Card(
child: CheckboxListTile(
value: _completed[index],
title: Text(
_tasks[index],
style: TextStyle(
decoration: _completed[index]
? TextDecoration.lineThrough
    : TextDecoration.none,
),
),
onChanged: (value) {
setState(() {
_completed[index] = value ?? false;
});
},
secondary: IconButton(
icon: const Icon(
Icons.delete_outline,
color: Colors.red,
),
onPressed: () {
setState(() {
_tasks.removeAt(index);
_completed.removeAt(index);
});
},
),
),
);
},
),
),
],
),
),
);
}
}
