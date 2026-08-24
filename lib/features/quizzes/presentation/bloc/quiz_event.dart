import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_entity.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class FetchQuizzesRequested extends QuizEvent {
  final int? page;

  const FetchQuizzesRequested({this.page});

  @override
  List<Object?> get props => [page];
}

class FetchQuizDetailsRequested extends QuizEvent {
  final int quizId;

  const FetchQuizDetailsRequested(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class TakeQuizRequested extends QuizEvent {
  final int quizId;

  const TakeQuizRequested(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class SelectQuizAnswer extends QuizEvent {
  final int questionId;
  final int choiceId;

  const SelectQuizAnswer({
    required this.questionId,
    required this.choiceId,
  });

  @override
  List<Object?> get props => [questionId, choiceId];
}

class SubmitQuizRequested extends QuizEvent {
  final int quizId;

  const SubmitQuizRequested(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class FetchMyQuizResultsRequested extends QuizEvent {
  final int? page;

  const FetchMyQuizResultsRequested({this.page});

  @override
  List<Object?> get props => [page];
}

class FetchTeacherQuizResultsRequested extends QuizEvent {
  final int quizId;

  const FetchTeacherQuizResultsRequested(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class CreateQuizSubmitted extends QuizEvent {
  final int lessonId;
  final String title;
  final String? description;
  final int? passScorePercent;

  const CreateQuizSubmitted({
    required this.lessonId,
    required this.title,
    this.description,
    this.passScorePercent,
  });

  @override
  List<Object?> get props => [lessonId, title, description, passScorePercent];
}

class UpdateQuizSubmitted extends QuizEvent {
  final int quizId;
  final int lessonId;
  final String title;
  final String? description;
  final int? passScorePercent;
  final bool isPartial;

  const UpdateQuizSubmitted({
    required this.quizId,
    required this.lessonId,
    required this.title,
    this.description,
    this.passScorePercent,
    this.isPartial = false,
  });

  @override
  List<Object?> get props => [
        quizId,
        lessonId,
        title,
        description,
        passScorePercent,
        isPartial,
      ];
}

class CreateQuestionSubmitted extends QuizEvent {
  final int quizId;
  final String text;
  final int? order;
  final List<ChoiceEntity> choices;

  const CreateQuestionSubmitted({
    required this.quizId,
    required this.text,
    this.order,
    required this.choices,
  });

  @override
  List<Object?> get props => [quizId, text, order, choices];
}

class DeleteQuizRequested extends QuizEvent {
  final int quizId;

  const DeleteQuizRequested(this.quizId);

  @override
  List<Object?> get props => [quizId];
}
