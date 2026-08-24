import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_entity.dart';

enum QuizStatus {
  initial,
  loading,
  loaded,
  submitting,
  submitted,
  error;

  bool get isInitial => this == QuizStatus.initial;
  bool get isLoading => this == QuizStatus.loading;
  bool get isLoaded => this == QuizStatus.loaded;
  bool get isSubmitting => this == QuizStatus.submitting;
  bool get isSubmitted => this == QuizStatus.submitted;
  bool get isError => this == QuizStatus.error;
}

class QuizState extends Equatable {
  final QuizStatus status;
  final List<QuizEntity> quizzes;
  final QuizEntity? selectedQuiz;
  final Map<int, int> selectedAnswers; // questionId -> choiceId
  final QuizResultEntity? submissionResult;
  final List<QuizResultEntity> myResults;
  final List<QuizResultEntity> teacherResults;
  final String? errorMessage;
  final String? successMessage;

  const QuizState({
    this.status = QuizStatus.initial,
    this.quizzes = const [],
    this.selectedQuiz,
    this.selectedAnswers = const {},
    this.submissionResult,
    this.myResults = const [],
    this.teacherResults = const [],
    this.errorMessage,
    this.successMessage,
  });

  QuizState copyWith({
    QuizStatus? status,
    List<QuizEntity>? quizzes,
    QuizEntity? selectedQuiz,
    Map<int, int>? selectedAnswers,
    QuizResultEntity? submissionResult,
    List<QuizResultEntity>? myResults,
    List<QuizResultEntity>? teacherResults,
    String? errorMessage,
    String? successMessage,
    bool clearSelectedQuiz = false,
    bool clearSubmissionResult = false,
  }) {
    return QuizState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      selectedQuiz: clearSelectedQuiz ? null : (selectedQuiz ?? this.selectedQuiz),
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      submissionResult: clearSubmissionResult ? null : (submissionResult ?? this.submissionResult),
      myResults: myResults ?? this.myResults,
      teacherResults: teacherResults ?? this.teacherResults,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quizzes,
        selectedQuiz,
        selectedAnswers,
        submissionResult,
        myResults,
        teacherResults,
        errorMessage,
        successMessage,
      ];
}
