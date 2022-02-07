class Answer {
  final String id;
  final String answer;
  final int difficulty;

  Answer({
    required this.id,
    required this.answer,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer': answer,
      'difficulty': difficulty,
    };
  }

  @override
  String toString() {
    return 'Answer {id: $id, answer: $answer, difficulty: $difficulty,}\n';
  }
}