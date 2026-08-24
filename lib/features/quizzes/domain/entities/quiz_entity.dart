import 'package:equatable/equatable.dart';

class QuizEntity extends Equatable {
  final int id;
  final int lessonId;
  final String title;
  final String description;
  final int passScorePercent;
  final DateTime? createdAt;
  final List<QuestionEntity> questions;

  const QuizEntity({
    required this.id,
    required this.lessonId,
    required this.title,
    this.description = '',
    this.passScorePercent = 70,
    this.createdAt,
    this.questions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        lessonId,
        title,
        description,
        passScorePercent,
        createdAt,
        questions,
      ];
}

class QuestionEntity extends Equatable {
  final int id;
  final int quizId;
  final String text;
  final int order;
  final List<ChoiceEntity> choices;

  const QuestionEntity({
    required this.id,
    required this.quizId,
    required this.text,
    this.order = 0,
    this.choices = const [],
  });

  @override
  List<Object?> get props => [id, quizId, text, order, choices];
}

class ChoiceEntity extends Equatable {
  final int? id;
  final String text;
  final bool isCorrect;

  const ChoiceEntity({
    this.id,
    required this.text,
    this.isCorrect = false,
  });

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
  List<Object?> get props => [
        questionId,
        questionText,
        selectedText,
        isCorrect,
      ];
}

class QuizResultEntity extends Equatable {
  final int id;
  final int quizId;
  final int studentId;
  final double scorePercent;
  final bool passed;
  final DateTime? submittedAt;
  final List<AnswerResultEntity> answers;

  const QuizResultEntity({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.scorePercent,
    required this.passed,
    this.submittedAt,
    this.answers = const [],
  });

  @override
  List<Object?> get props => [
        id,
        quizId,
        studentId,
        scorePercent,
        passed,
        submittedAt,
        answers,
      ];
}
