
import 'package:flutter/material.dart';

void main() {
  runApp(const AIStudyAssistant());
}

class AIStudyAssistant extends StatelessWidget {
  const AIStudyAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Study Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6657D9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FC),
          centerTitle: false,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class StudyNote {
  String title;
  String content;

  StudyNote(this.title, this.content);
}

class StudyTask {
  String title;
  bool completed;

  StudyTask(this.title, {this.completed = false});
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<StudyNote> notes = [
    StudyNote(
      'Machine Learning',
      'Machine learning enables systems to learn patterns from data.',
    ),
    StudyNote(
      'Computer Networks',
      'A computer network connects devices to share data and resources.',
    ),
  ];

  final List<StudyTask> tasks = [
    StudyTask('Study Python', completed: true),
    StudyTask('Revise Computer Networks'),
    StudyTask('Practice Machine Learning'),
  ];

  final List<String> chatQuestions = [];
  final List<String> chatAnswers = [];

  final List<Map<String, Object>> questions = [
    {
      'question': 'Which language is commonly used for AI?',
      'options': ['HTML', 'Python', 'CSS', 'XML'],
      'answer': 1,
    },
    {
      'question': 'What does CPU stand for?',
      'options': [
        'Central Processing Unit',
        'Computer Personal Unit',
        'Central Program Utility',
        'Control Processing User',
      ],
      'answer': 0,
    },
    {
      'question': 'Which structure follows FIFO?',
      'options': ['Stack', 'Tree', 'Queue', 'Graph'],
      'answer': 2,
    },
    {
      'question': 'Which is a database query language?',
      'options': ['SQL', 'JPEG', 'CSS', 'PNG'],
      'answer': 0,
    },
    {
      'question': 'What is the full form of AI?',
      'options': [
        'Automated Internet',
        'Artificial Intelligence',
        'Advanced Interface',
        'Applied Information',
      ],
      'answer': 1,
    },
  ];

  int get completedTasks =>
      tasks.where((task) => task.completed).length;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void addNote(String title, String content) {
    if (title.trim().isEmpty || content.trim().isEmpty) {
      showMessage('Please enter both a title and note.');
      return;
    }

    setState(() {
      notes.insert(0, StudyNote(title.trim(), content.trim()));
    });
    showMessage('Note saved successfully.');
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.add(StudyTask(title.trim()));
    });
    showMessage('Study task added.');
  }

  void showAddNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create study note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Note title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Write your notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = titleController.text;
              final content = contentController.text;

              if (title.trim().isEmpty || content.trim().isEmpty) {
                showMessage('Fill in both fields.');
                return;
              }

              Navigator.pop(dialogContext);
              addNote(title, content);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      titleController.dispose();
      contentController.dispose();
    });
  }

  void showAddTaskDialog() {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add study task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            Navigator.pop(dialogContext);
            addTask(controller.text);
            controller.dispose();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              controller.dispose();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final title = controller.text;
              Navigator.pop(dialogContext);
              addTask(title);
              controller.dispose();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void sendQuestion(String question) {
    if (question.trim().isEmpty) return;

    final normalized = question.toLowerCase();
    String answer;

    if (normalized.contains('python')) {
      answer =
      'Python is a high-level programming language known for its '
          'readable syntax. It is widely used in AI, data science, '
          'automation, and web development.\n\nExample:\nprint("Hello")';
    } else if (normalized.contains('machine learning') ||
        normalized.contains('ml')) {
      answer =
      'Machine learning is a branch of AI that learns patterns '
          'from data. Its main types are supervised learning, '
          'unsupervised learning, and reinforcement learning.';
    } else if (normalized.contains('database') ||
        normalized.contains('sql')) {
      answer =
      'A database stores and organizes data. SQL is used to '
          'create, read, update, and delete data in relational '
          'databases.\n\nExample:\nSELECT * FROM students;';
    } else if (normalized.contains('network')) {
      answer =
      'A computer network connects devices to communicate and '
          'share resources. Common types include LAN, MAN, and WAN.';
    } else if (normalized.contains('exam') ||
        normalized.contains('study')) {
      answer =
      'Try this study method:\n'
          '1. Divide the topic into small sections.\n'
          '2. Study for 25 minutes.\n'
          '3. Recall the main points without looking.\n'
          '4. Solve practice questions and revise.';
    } else {
      answer =
      'I can demonstrate study assistance for Python, machine '
          'learning, SQL, computer networks, and study techniques. '
          'For answers to other questions, connect an AI API to '
          'the application.';
    }

    setState(() {
      chatQuestions.add(question.trim());
      chatAnswers.add(answer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(
        noteCount: notes.length,
        completedTasks: completedTasks,
        totalTasks: tasks.length,
        onNavigate: (index) => setState(() => selectedIndex = index),
      ),
      ChatPage(
        questions: chatQuestions,
        answers: chatAnswers,
        onSend: sendQuestion,
      ),
      NotesPage(
        notes: notes,
        onAdd: showAddNoteDialog,
        onDelete: (index) {
          setState(() => notes.removeAt(index));
          showMessage('Note deleted.');
        },
      ),
      QuizPage(questions: questions),
      PlannerPage(
        tasks: tasks,
        onAdd: showAddTaskDialog,
        onChanged: (index, value) {
          setState(() => tasks[index].completed = value);
        },
        onDelete: (index) {
          setState(() => tasks.removeAt(index));
        },
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Study Assistant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE7E3FF),
              child: Icon(
                Icons.school_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'AI Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -------------------- DASHBOARD MODULE --------------------

class DashboardPage extends StatelessWidget {
  final int noteCount;
  final int completedTasks;
  final int totalTasks;
  final ValueChanged<int> onNavigate;

  const DashboardPage({
    super.key,
    required this.noteCount,
    required this.completedTasks,
    required this.totalTasks,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks == 0
        ? 0.0
        : completedTasks / totalTasks;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6657D9), Color(0xFF9285F0)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 32),
              SizedBox(height: 12),
              Text(
                'Learn smarter with AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ask questions, practice quizzes, and organize your studies.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Your study overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Notes',
                value: '$noteCount',
                icon: Icons.menu_book,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Completed',
                value: '$completedTasks',
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Study task progress',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                LinearProgressIndicator(value: progress, minHeight: 9),
                const SizedBox(height: 10),
                Text(
                  '${(progress * 100).round()}% completed '
                      '($completedTasks of $totalTasks tasks)',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Quick access',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        QuickAction(
          icon: Icons.smart_toy,
          title: 'Ask the study assistant',
          subtitle: 'Explore study topics',
          onTap: () => onNavigate(1),
        ),
        QuickAction(
          icon: Icons.note_add,
          title: 'My study notes',
          subtitle: 'Create and manage notes',
          onTap: () => onNavigate(2),
        ),
        QuickAction(
          icon: Icons.quiz,
          title: 'Practice quiz',
          subtitle: 'Test your knowledge',
          onTap: () => onNavigate(3),
        ),
        QuickAction(
          icon: Icons.calendar_month,
          title: 'Study planner',
          subtitle: 'Organize daily tasks',
          onTap: () => onNavigate(4),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF6657D9)),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE7E3FF),
          child: Icon(icon, color: const Color(0xFF6657D9)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// -------------------- AI CHAT MODULE --------------------

class ChatPage extends StatefulWidget {
  final List<String> questions;
  final List<String> answers;
  final ValueChanged<String> onSend;

  const ChatPage({
    super.key,
    required this.questions,
    required this.answers,
    required this.onSend,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    if (controller.text.trim().isEmpty) return;
    widget.onSend(controller.text);
    controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF6657D9)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Study Chat Demo — try asking about Python, SQL, '
                          'machine learning, or networks.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: widget.questions.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.forum_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 12),
                Text('What would you like to learn today?'),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E3FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(widget.questions[index]),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(widget.answers[index]),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => send(),
                  decoration: InputDecoration(
                    hintText: 'Ask a study question...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -------------------- NOTES MODULE --------------------

class NotesPage extends StatelessWidget {
  final List<StudyNote> notes;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;

  const NotesPage({
    super.key,
    required this.notes,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet. Create your first note!'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.description_outlined),
              ),
              title: Text(
                note.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(note.title),
                    content: SingleChildScrollView(
                      child: Text(note.content),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDelete(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
      ),
    );
  }
}

// -------------------- QUIZ MODULE --------------------

class QuizPage extends StatefulWidget {
  final List<Map<String, Object>> questions;

  const QuizPage({super.key, required this.questions});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;
  bool finished = false;

  void checkAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == widget.questions[currentQuestion]['answer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion == widget.questions.length - 1) {
        finished = true;
      } else {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      }
    });
  }

  void restart() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Color(0xFF6657D9),
              ),
              const SizedBox(height: 16),
              const Text(
                'Quiz completed!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Your score: $score / ${widget.questions.length}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: restart,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final question = widget.questions[currentQuestion];
    final options = question['options'] as List<String>;
    final correctAnswer = question['answer'] as int;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Question ${currentQuestion + 1} of ${widget.questions.length}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: (currentQuestion + 1) / widget.questions.length,
          minHeight: 8,
        ),
        const SizedBox(height: 28),
        Text(
          question['question'] as String,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 22),
        ...List.generate(options.length, (index) {
          Color? tileColor;

          if (answered && index == correctAnswer) {
            tileColor = Colors.green.withValues(alpha: 0.13);
          } else if (answered && index == selectedAnswer) {
            tileColor = Colors.red.withValues(alpha: 0.13);
          }

          return Card(
            color: tileColor,
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(options[index]),
              onTap: () => checkAnswer(index),
            ),
          );
        }),
        if (answered) ...[
          const SizedBox(height: 12),
          Text(
            selectedAnswer == correctAnswer
                ? 'Correct answer!'
                : 'Not quite. The correct answer is ${options[correctAnswer]}.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectedAnswer == correctAnswer
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: nextQuestion,
            child: Text(
              currentQuestion == widget.questions.length - 1
                  ? 'View result'
                  : 'Next question',
            ),
          ),
        ],
      ],
    );
  }
}

// -------------------- STUDY PLANNER MODULE --------------------

class PlannerPage extends StatelessWidget {
  final List<StudyTask> tasks;
  final VoidCallback onAdd;
  final void Function(int, bool) onChanged;
  final ValueChanged<int> onDelete;

  const PlannerPage({
    super.key,
    required this.tasks,
    required this.onAdd,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: tasks.isEmpty
          ? const Center(child: Text('No study tasks. Add one to get started.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: CheckboxListTile(
              value: task.completed,
              onChanged: (value) =>
                  onChanged(index, value ?? false),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                task.completed ? 'Completed' : 'Pending',
              ),
              secondary: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDelete(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }
}

// -------------------- PROFILE MODULE --------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 18),
        const CircleAvatar(
          radius: 48,
          backgroundColor: Color(0xFFE7E3FF),
          child: Icon(
            Icons.person,
            size: 55,
            color: Color(0xFF6657D9),
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Student Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text('AI Study Assistant user'),
        ),
        const SizedBox(height: 28),
        const Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined),
                title: Text('Application'),
                subtitle: Text('AI Study Assistant'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.smart_toy_outlined),
                title: Text('AI integration'),
                subtitle: Text('Demo responses; API not connected'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.storage_outlined),
                title: Text('Data storage'),
                subtitle: Text(
                  'In-memory demo data; resets when app restarts',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
