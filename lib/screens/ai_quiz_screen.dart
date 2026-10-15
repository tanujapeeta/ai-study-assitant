import 'package:flutter/material.dart';

class AIQuizScreen extends StatefulWidget {
const AIQuizScreen({super.key});

@override
State<AIQuizScreen> createState() => _AIQuizScreenState();
}

class _AIQuizScreenState extends State<AIQuizScreen> {
String selectedDifficulty = 'Easy';

int currentQuestion = 0;
int score = 0;
int? selectedAnswer;

bool quizFinished = false;

final List<Map<String, dynamic>> questions = [
{
'question': 'What does AI stand for?',
'options': [
'Artificial Intelligence',
'Automated Internet',
'Advanced Information',
'Artificial Internet',
],
'answer': 0,
},
{
'question': 'Which language is commonly used for AI?',
'options': [
'Python',
'HTML',
'CSS',
'XML',
],
'answer': 0,
},
{
'question': 'What is the brain of a computer called?',
'options': [
'CPU',
'Keyboard',
'Monitor',
'Mouse',
],
'answer': 0,
},
{
'question': 'Which one is a database?',
'options': [
'MySQL',
'Flutter',
'Python',
'HTML',
],
'answer': 0,
},
{
'question': 'What does DBMS stand for?',
'options': [
'Database Management System',
'Data Backup Management Software',
'Digital Base Management System',
'Database Machine System',
],
'answer': 0,
},
];

void selectAnswer(int index) {
setState(() {
selectedAnswer = index;
});
}

void nextQuestion() {
if (selectedAnswer == null) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please select an answer'),
),
);
return;
}

if (selectedAnswer ==
questions[currentQuestion]['answer']) {
score++;
}

if (currentQuestion < questions.length - 1) {
setState(() {
currentQuestion++;
selectedAnswer = null;
});
} else {
setState(() {
quizFinished = true;
});
}
}

void restartQuiz() {
setState(() {
currentQuestion = 0;
score = 0;
selectedAnswer = null;
quizFinished = false;
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF6F8FC),

appBar: AppBar(
backgroundColor: Colors.white,
foregroundColor: const Color(0xFF172033),
elevation: 0,

title: const Text(
'AI Quiz Generator',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: quizFinished
? _buildResult()
    : _buildQuiz(),
);
}

Widget _buildQuiz() {
final question = questions[currentQuestion];

return SingleChildScrollView(
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Choose Difficulty',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
color: Color(0xFF172033),
),
),

const SizedBox(height: 12),

Row(
children: [
_difficultyButton('Easy'),
const SizedBox(width: 8),
_difficultyButton('Medium'),
const SizedBox(width: 8),
_difficultyButton('Hard'),
],
),

const SizedBox(height: 25),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Text(
'Question ${currentQuestion + 1}',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Color(0xFF2563EB),
),
),

Text(
'${currentQuestion + 1}/${questions.length}',
style: const TextStyle(
color: Colors.grey,
),
),
],
),

const SizedBox(height: 10),

LinearProgressIndicator(
value:
(currentQuestion + 1) / questions.length,
minHeight: 7,
borderRadius: BorderRadius.circular(10),
),

const SizedBox(height: 25),

Container(
width: double.infinity,
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),

boxShadow: [
BoxShadow(
color: Colors.black.withValues(alpha: 0.04),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),

child: Text(
question['question'],
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Color(0xFF172033),
),
),
),

const SizedBox(height: 20),

...List.generate(
question['options'].length,
(index) {
return _optionCard(
question['options'][index],
index,
);
},
),

const SizedBox(height: 15),

SizedBox(
width: double.infinity,
height: 52,

child: ElevatedButton(
onPressed: nextQuestion,

style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF2563EB),
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
),

child: Text(
currentQuestion ==
questions.length - 1
? 'Finish Quiz'
    : 'Next Question',
style: const TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
),
],
),
);
}

Widget _difficultyButton(String difficulty) {
final isSelected =
selectedDifficulty == difficulty;

return Expanded(
child: GestureDetector(
onTap: () {
setState(() {
selectedDifficulty = difficulty;
});
},

child: Container(
padding:
const EdgeInsets.symmetric(vertical: 12),

decoration: BoxDecoration(
color: isSelected
? const Color(0xFF2563EB)
    : Colors.white,

borderRadius: BorderRadius.circular(12),

border: Border.all(
color: isSelected
? const Color(0xFF2563EB)
    : const Color(0xFFE0E5EF),
),
),

child: Text(
difficulty,
textAlign: TextAlign.center,

style: TextStyle(
fontWeight: FontWeight.bold,
color: isSelected
? Colors.white
    : const Color(0xFF172033),
),
),
),
),
);
}

Widget _optionCard(
String option,
int index,
) {
final isSelected =
selectedAnswer == index;

return GestureDetector(
onTap: () {
selectAnswer(index);
},

child: Container(
width: double.infinity,

margin:
const EdgeInsets.only(bottom: 12),

padding: const EdgeInsets.all(16),

decoration: BoxDecoration(
color: isSelected
? const Color(0xFFE8F0FE)
    : Colors.white,

borderRadius:
BorderRadius.circular(14),

border: Border.all(
color: isSelected
? const Color(0xFF2563EB)
    : const Color(0xFFE0E5EF),
width: isSelected ? 2 : 1,
),
),

child: Row(
children: [
Container(
width: 34,
height: 34,

alignment: Alignment.center,

decoration: BoxDecoration(
color: isSelected
? const Color(0xFF2563EB)
    : const Color(0xFFF0F2F7),

shape: BoxShape.circle,
),

child: Text(
String.fromCharCode(
65 + index,
),

style: TextStyle(
fontWeight: FontWeight.bold,
color: isSelected
? Colors.white
    : const Color(0xFF172033),
),
),
),

const SizedBox(width: 14),

Expanded(
child: Text(
option,

style: const TextStyle(
fontSize: 15,
color: Color(0xFF172033),
),
),
),

if (isSelected)
const Icon(
Icons.check_circle,
color: Color(0xFF2563EB),
),
],
),
),
);
}

Widget _buildResult() {
final percentage =
((score / questions.length) * 100).round();

return Center(
child: Padding(
padding: const EdgeInsets.all(25),

child: Column(
mainAxisAlignment:
MainAxisAlignment.center,

children: [
Container(
padding: const EdgeInsets.all(25),

decoration: const BoxDecoration(
color: Color(0xFFE8F0FE),
shape: BoxShape.circle,
),

child: const Icon(
Icons.emoji_events_rounded,
size: 65,
color: Color(0xFF2563EB),
),
),

const SizedBox(height: 25),

const Text(
'Quiz Completed!',
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
color: Color(0xFF172033),
),
),

const SizedBox(height: 12),

Text(
'Your Score: $score / ${questions.length}',
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Color(0xFF2563EB),
),
),

const SizedBox(height: 8),

Text(
'$percentage%',
style: const TextStyle(
fontSize: 42,
fontWeight: FontWeight.bold,
color: Color(0xFF172033),
),
),

const SizedBox(height: 12),

Text(
percentage >= 80
? 'Excellent work! 🎉'
    : percentage >= 50
? 'Good job! Keep practicing! 👍'
    : 'Keep learning and try again! 💪',
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 15,
color: Colors.grey,
),
),

const SizedBox(height: 30),

SizedBox(
width: double.infinity,
height: 52,

child: ElevatedButton(
onPressed: restartQuiz,

style: ElevatedButton.styleFrom(
backgroundColor:
const Color(0xFF2563EB),
foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
),

child: const Text(
'Try Again',
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
),
),
],
),
),
);
}
}
