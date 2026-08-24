import 'package:equatable/equatable.dart';

class QuizEntity extends Equatable {
  final int id;
  final int lesson;
  final String title;
  final String description;
  final int passScorePercent;
  final String? createdAt;
  final List<QuestionEntity> questions;

  const QuizEntity({
    required this.id,
    required this.lesson,
    required this.title,
    this.description = '',
    this.passScorePercent = 70,
    this.createdAt,
    this.questions = const [],
  });

  // Backward-compatible alias helpers
  int get courseId => lesson;
  int get passingScore => passScorePercent;
  int get timeLimitMinutes => 15;

  @override
  List<Object?> get props => [
        id,
        lesson,
        title,
        description,
        passScorePercent,
        createdAt,
        questions,
      ];
}

class QuestionEntity extends Equatable {
  final int id;
  final int quiz;
  final String text;
  final int order;
  final List<ChoiceEntity> choices;

  const QuestionEntity({
    required this.id,
    required this.quiz,
    required this.text,
    this.order = 1,
    this.choices = const [],
  });

  // Backward-compatible alias helpers
  int get quizId => quiz;
  String get questionText => text;

  @override
  List<Object?> get props => [id, quiz, text, order, choices];
}

class ChoiceEntity extends Equatable {
  final int id;
  final String text;
  final bool isCorrect;

  const ChoiceEntity({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  // Backward-compatible alias helpers
  String get choiceText => text;
  int get questionId => 0;

  @override
  List<Object?> get props => [id, text, isCorrect];
}

class AnswerSubmitEntity extends Equatable {
  final int questionId;
  final int choiceId;

  const AnswerSubmitEntity({
    required this.questionId,
    required this.choiceId,
  });

  @override
  List<Object?> get props => [questionId, choiceId];
}

class AnswerResultEntity extends Equatable {
  final String questionId;
  final String questionText;
  final String selectedText;
  final bool isCorrect;

  const AnswerResultEntity({
    required this.questionId,
    required this.questionText,
    required this.selectedText,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [questionId, questionText, selectedText, isCorrect];
}

class QuizResultEntity extends Equatable {
  final int id;
  final int quiz;
  final int student;
  final double scorePercent;
  final bool passed;
  final String submittedAt;
  final List<AnswerResultEntity> answers;

  const QuizResultEntity({
    required this.id,
    required this.quiz,
    required this.student,
    required this.scorePercent,
    required this.passed,
    required this.submittedAt,
    this.answers = const [],
  });

  // Backward-compatible alias helpers
  int get submissionId => id;
  int get score => scorePercent.toInt();
  int get totalQuestions => answers.isNotEmpty ? answers.length : 10;
  bool get isPassed => passed;

  @override
  List<Object?> get props => [
        id,
        quiz,
        student,
        scorePercent,
        passed,
        submittedAt,
        answers,
      ];
}

// Backward-compatible alias for existing controllers
typedef QuizSubmissionResultEntity = QuizResultEntity;
