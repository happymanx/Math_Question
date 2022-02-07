import 'dart:convert';

class Question {
  final String id;
  final String question;
  final int difficulty;

  Question({
    required this.id,
    required this.question,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'difficulty': difficulty,
    };
  }

  @override
  String toString() {
    return 'Question {id: $id, question: $question, difficulty: $difficulty,}\n';
  }
}