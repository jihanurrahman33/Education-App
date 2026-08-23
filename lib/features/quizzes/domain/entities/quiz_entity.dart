import 'package:equatable/equatable.dart';

class QuizEntity extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final String description;
  final int passingScore;
  final int timeLimitMinutes;
  final List<QuestionEntity> questions;

  const QuizEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    this.passingScore = 70,
    this.timeLimitMinutes = 30,
    this.questions = const [],
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        title,
        description,
        passingScore,
        timeLimitMinutes,
        questions,
      ];
}

class QuestionEntity extends Equatable {
  final int id;
  final int quizId;
  final String questionText;
  final List<ChoiceEntity> choices;

  const QuestionEntity({
    required this.id,
    required this.quizId,
    required this.questionText,
    this.choices = const [],
  });

  @override
  List<Object?> get props => [id, quizId, questionText, choices];
}

class ChoiceEntity extends Equatable {
  final int id;
  final int questionId;
  final String choiceText;
  final bool isCorrect;

  const ChoiceEntity({
    required this.id,
    required this.questionId,
    required this.choiceText,
    this.isCorrect = false,
  });

  @override
  List<Object?> get props => [id, questionId, choiceText, isCorrect];
}

class QuizSubmissionResultEntity extends Equatable {
  final int submissionId;
  final int score;
  final int totalQuestions;
  final bool isPassed;

  const QuizSubmissionResultEntity({
    required this.submissionId,
    required this.score,
    required this.totalQuestions,
    required this.isPassed,
  });

  @override
  List<Object?> get props => [submissionId, score, totalQuestions, isPassed];
}
