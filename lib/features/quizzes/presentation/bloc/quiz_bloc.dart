import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/usecases/create_question_usecase.dart';
import '../../domain/usecases/create_quiz_usecase.dart';
import '../../domain/usecases/delete_quiz_usecase.dart';
import '../../domain/usecases/get_my_quiz_results_usecase.dart';
import '../../domain/usecases/get_quiz_details_usecase.dart';
import '../../domain/usecases/get_quiz_teacher_results_usecase.dart';
import '../../domain/usecases/get_quizzes_usecase.dart';
import '../../domain/usecases/submit_quiz_usecase.dart';
import '../../domain/usecases/take_quiz_usecase.dart';
import '../../domain/usecases/update_quiz_usecase.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuizzesUseCase getQuizzesUseCase;
  final CreateQuizUseCase createQuizUseCase;
  final GetQuizDetailsUseCase getQuizDetailsUseCase;
  final UpdateQuizUseCase updateQuizUseCase;
  final DeleteQuizUseCase deleteQuizUseCase;
  final TakeQuizUseCase takeQuizUseCase;
  final SubmitQuizUseCase submitQuizUseCase;
  final GetMyQuizResultsUseCase getMyQuizResultsUseCase;
  final GetQuizTeacherResultsUseCase getQuizTeacherResultsUseCase;
  final CreateQuestionUseCase createQuestionUseCase;

  QuizBloc({
    required this.getQuizzesUseCase,
    required this.createQuizUseCase,
    required this.getQuizDetailsUseCase,
    required this.updateQuizUseCase,
    required this.deleteQuizUseCase,
    required this.takeQuizUseCase,
    required this.submitQuizUseCase,
    required this.getMyQuizResultsUseCase,
    required this.getQuizTeacherResultsUseCase,
    required this.createQuestionUseCase,
  }) : super(const QuizState()) {
    on<FetchQuizzesRequested>(_onFetchQuizzesRequested);
    on<FetchQuizDetailsRequested>(_onFetchQuizDetailsRequested);
    on<TakeQuizRequested>(_onTakeQuizRequested);
    on<SelectQuizAnswer>(_onSelectQuizAnswer);
    on<SubmitQuizRequested>(_onSubmitQuizRequested);
    on<FetchMyQuizResultsRequested>(_onFetchMyQuizResultsRequested);
    on<FetchTeacherQuizResultsRequested>(_onFetchTeacherQuizResultsRequested);
    on<CreateQuizSubmitted>(_onCreateQuizSubmitted);
    on<UpdateQuizSubmitted>(_onUpdateQuizSubmitted);
    on<CreateQuestionSubmitted>(_onCreateQuestionSubmitted);
    on<DeleteQuizRequested>(_onDeleteQuizRequested);
  }

  Future<void> _onFetchQuizzesRequested(
    FetchQuizzesRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await getQuizzesUseCase(GetQuizzesParams(page: event.page));

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (quizzes) => emit(state.copyWith(
        status: QuizStatus.loaded,
        quizzes: quizzes,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onFetchQuizDetailsRequested(
    FetchQuizDetailsRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await getQuizDetailsUseCase(GetQuizDetailsParams(quizId: event.quizId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (quiz) => emit(state.copyWith(
        status: QuizStatus.loaded,
        selectedQuiz: quiz,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onTakeQuizRequested(
    TakeQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(
      status: QuizStatus.loading,
      errorMessage: null,
      selectedAnswers: {},
      clearSubmissionResult: true,
    ));

    final result = await takeQuizUseCase(TakeQuizParams(quizId: event.quizId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (quiz) => emit(state.copyWith(
        status: QuizStatus.loaded,
        selectedQuiz: quiz,
        selectedAnswers: {},
        errorMessage: null,
      )),
    );
  }

  void _onSelectQuizAnswer(
    SelectQuizAnswer event,
    Emitter<QuizState> emit,
  ) {
    final updatedAnswers = Map<int, int>.from(state.selectedAnswers);
    updatedAnswers[event.questionId] = event.choiceId;
    emit(state.copyWith(selectedAnswers: updatedAnswers));
  }

  Future<void> _onSubmitQuizRequested(
    SubmitQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.submitting, errorMessage: null));

    final answers = state.selectedAnswers.entries
        .map((e) => AnswerSubmitEntity(questionId: e.key, choiceId: e.value))
        .toList();

    final result = await submitQuizUseCase(
      SubmitQuizParams(quizId: event.quizId, answers: answers),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (result) => emit(state.copyWith(
        status: QuizStatus.submitted,
        submissionResult: result,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onFetchMyQuizResultsRequested(
    FetchMyQuizResultsRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await getMyQuizResultsUseCase(GetMyQuizResultsParams(page: event.page));

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (results) => emit(state.copyWith(
        status: QuizStatus.loaded,
        myResults: results,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onFetchTeacherQuizResultsRequested(
    FetchTeacherQuizResultsRequested event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await getQuizTeacherResultsUseCase(
      GetQuizTeacherResultsParams(quizId: event.quizId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (results) => emit(state.copyWith(
        status: QuizStatus.loaded,
        teacherResults: results,
        errorMessage: null,
      )),
    );
  }

  Future<void> _onCreateQuizSubmitted(
    CreateQuizSubmitted event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await createQuizUseCase(
      CreateQuizParams(
        lessonId: event.lessonId,
        title: event.title,
        description: event.description,
        passScorePercent: event.passScorePercent,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (quiz) {
        final updatedQuizzes = List<QuizEntity>.from(state.quizzes)..add(quiz);
        emit(state.copyWith(
          status: QuizStatus.loaded,
          quizzes: updatedQuizzes,
          successMessage: 'Quiz created successfully',
        ));
      },
    );
  }

  Future<void> _onUpdateQuizSubmitted(
    UpdateQuizSubmitted event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await updateQuizUseCase(
      UpdateQuizParams(
        quizId: event.quizId,
        lessonId: event.lessonId,
        title: event.title,
        description: event.description,
        passScorePercent: event.passScorePercent,
        isPartial: event.isPartial,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (quiz) {
        final updated = state.quizzes.map((q) => q.id == quiz.id ? quiz : q).toList();
        emit(state.copyWith(
          status: QuizStatus.loaded,
          quizzes: updated,
          selectedQuiz: quiz,
          successMessage: 'Quiz updated successfully',
        ));
      },
    );
  }

  Future<void> _onCreateQuestionSubmitted(
    CreateQuestionSubmitted event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(status: QuizStatus.loading, errorMessage: null));

    final result = await createQuestionUseCase(
      CreateQuestionParams(
        quizId: event.quizId,
        text: event.text,
        order: event.order,
        choices: event.choices,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (question) => emit(state.copyWith(
        status: QuizStatus.loaded,
        successMessage: 'Question added successfully',
      )),
    );
  }

  Future<void> _onDeleteQuizRequested(
    DeleteQuizRequested event,
    Emitter<QuizState> emit,
  ) async {
    final result = await deleteQuizUseCase(DeleteQuizParams(quizId: event.quizId));

    result.fold(
      (failure) => emit(state.copyWith(
        status: QuizStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final updated = state.quizzes.where((q) => q.id != event.quizId).toList();
        emit(state.copyWith(
          quizzes: updated,
          successMessage: 'Quiz deleted successfully',
        ));
      },
    );
  }
}
