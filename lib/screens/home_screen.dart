
import 'package:flutter/material.dart';
import 'ai_chat_screen.dart';
import 'ai_quiz_screen.dart';
import 'study_planner_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'AI Study Chat',
        'subtitle': 'Ask study questions',
        'icon': Icons.smart_toy_rounded,
      },
      {
        'title': 'AI Quiz',
        'subtitle': 'Test your knowledge',
        'icon': Icons.quiz_rounded,
      },
      {
        'title': 'Study Planner',
        'subtitle': 'Plan your study time',
        'icon': Icons.calendar_month_rounded,
      },
      {
        'title': 'Subjects',
        'subtitle': 'Manage your subjects',
        'icon': Icons.menu_book_rounded,
      },
      {
        'title': 'PDF Summary',
        'subtitle': 'Summarize study PDFs',
        'icon': Icons.picture_as_pdf_rounded,
      },
      {
        'title': 'Progress',
        'subtitle': 'Track your learning',
        'icon': Icons.bar_chart_rounded,
      },
      {
        'title': 'Pomodoro',
        'subtitle': 'Focus on studying',
        'icon': Icons.timer_rounded,
      },
      {
        'title': 'Notes',
        'subtitle': 'Manage your notes',
        'icon': Icons.note_alt_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'AI Study Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE8F0FE),
              child: Icon(Icons.person, color: Color(0xFF2563EB)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome, Student! 👋',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ready to continue your learning journey?',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Learning",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 10),
                Text(
                  'Keep learning. Keep growing!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final feature = features[index];
              final title = feature['title'] as String;
              final subtitle = feature['subtitle'] as String;
              final icon = feature['icon'] as IconData;

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    Widget? page;

                    if (title == 'AI Study Chat') {
                      page = const AIChatScreen();
                    } else if (title == 'AI Quiz') {
                      page = const AIQuizScreen();
                    } else if (title == 'Study Planner') {
                      page = const StudyPlannerScreen();
                    }

                    if (page != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => page!,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title feature coming soon'),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: const Color(0xFF2563EB),
                            size: 26,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF172033),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
