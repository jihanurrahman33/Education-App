import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../../domain/entities/quiz_entity.dart';
import '../models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  // Quiz endpoints
  Future<List<QuizModel>> getQuizzes({int? page});
  Future<QuizModel> createQuiz({
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  });
  Future<QuizModel> getQuizDetails(int quizId);
  Future<QuizModel> updateQuiz({
    required int quizId,
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  });
  Future<QuizModel> partialUpdateQuiz({
    required int quizId,
    int? lessonId,
    String? title,
    String? description,
    int? passScorePercent,
  });
  Future<void> deleteQuiz(int quizId);

  // Student Actions
  Future<QuizModel> takeQuiz(int quizId);
  Future<QuizResultModel> submitQuiz({
    required int quizId,
    required List<AnswerSubmitEntity> answers,
  });
  Future<List<QuizResultModel>> getMyQuizResults({int? page});
  Future<List<QuizResultModel>> getQuizTeacherResults(int quizId);

  // Questions endpoints
  Future<List<QuestionModel>> getQuestions({int? page});
  Future<QuestionModel> createQuestion({
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  });
  Future<QuestionModel> getQuestionDetails(int questionId);
  Future<QuestionModel> updateQuestion({
    required int questionId,
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  });
  Future<QuestionModel> partialUpdateQuestion({
    required int questionId,
    int? quizId,
    String? text,
    int? order,
    List<ChoiceEntity>? choices,
  });
  Future<void> deleteQuestion(int questionId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiClient _apiClient;

  const QuizRemoteDataSourceImpl({required this._apiClient});

  @override
  Future<List<QuizModel>> getQuizzes({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.quizzes,
      queryParameters: queryParams,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<QuizModel> createQuiz({
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.quizzes,
      data: {
        'lesson': lessonId,
        'title': title,
        'description': ?description,
        'pass_score_percent': ?passScorePercent,
      },
    );

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }
    throw Exception('Invalid create quiz response');
  }

  @override
  Future<QuizModel> getQuizDetails(int quizId) async {
    final response = await _apiClient.get(ApiEndpoints.quizDetail(quizId));

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }
    throw Exception('Invalid quiz details response');
  }

  @override
  Future<QuizModel> updateQuiz({
    required int quizId,
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.quizDetail(quizId),
      data: {
        'lesson': lessonId,
        'title': title,
        'description': ?description,
        'pass_score_percent': ?passScorePercent,
      },
    );

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }
    throw Exception('Invalid update quiz response');
  }

  @override
  Future<QuizModel> partialUpdateQuiz({
    required int quizId,
    int? lessonId,
    String? title,
    String? description,
    int? passScorePercent,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.quizDetail(quizId),
      data: {
        'lesson': ?lessonId,
        'title': ?title,
        'description': ?description,
        'pass_score_percent': ?passScorePercent,
      },
    );

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }
    throw Exception('Invalid partial update quiz response');
  }

  @override
  Future<void> deleteQuiz(int quizId) async {
    await _apiClient.delete(ApiEndpoints.quizDetail(quizId));
  }

  @override
  Future<QuizModel> takeQuiz(int quizId) async {
    final response = await _apiClient.get(ApiEndpoints.quizTake(quizId));

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }
    throw Exception('Invalid take quiz response');
  }

  @override
  Future<QuizResultModel> submitQuiz({
    required int quizId,
    required List<AnswerSubmitEntity> answers,
  }) async {
    final formattedAnswers = answers
        .map((a) => {
              'question_id': a.questionId,
              'choice_id': a.choiceId,
            })
        .toList();

    final response = await _apiClient.post(
      ApiEndpoints.quizSubmit(quizId),
      data: {'answers': formattedAnswers},
    );

    if (response is Map<String, dynamic>) {
      return QuizResultModel.fromJson(response);
    }
    throw Exception('Invalid quiz submit response');
  }

  @override
  Future<List<QuizResultModel>> getMyQuizResults({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.myQuizResults,
      queryParameters: queryParams,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizResultModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizResultModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<QuizResultModel>> getQuizTeacherResults(int quizId) async {
    final response = await _apiClient.get(ApiEndpoints.quizResults(quizId));

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizResultModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => QuizResultModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<QuestionModel>> getQuestions({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.questions,
      queryParameters: queryParams,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => QuestionModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => QuestionModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<QuestionModel> createQuestion({
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.questions,
      data: {
        'quiz': quizId,
        'text': text,
        'order': ?order,
        'choices': choices
            .map((c) => {
                  'text': c.text,
                  'is_correct': c.isCorrect,
                })
            .toList(),
      },
    );

    if (response is Map<String, dynamic>) {
      return QuestionModel.fromJson(response);
    }
    throw Exception('Invalid create question response');
  }

  @override
  Future<QuestionModel> getQuestionDetails(int questionId) async {
    final response = await _apiClient.get(ApiEndpoints.questionDetail(questionId));

    if (response is Map<String, dynamic>) {
      return QuestionModel.fromJson(response);
    }
    throw Exception('Invalid question details response');
  }

  @override
  Future<QuestionModel> updateQuestion({
    required int questionId,
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.questionDetail(questionId),
      data: {
        'quiz': quizId,
        'text': text,
        'order': ?order,
        'choices': choices
            .map((c) => {
                  if (c.id != null) 'id': c.id,
                  'text': c.text,
                  'is_correct': c.isCorrect,
                })
            .toList(),
      },
    );

    if (response is Map<String, dynamic>) {
      return QuestionModel.fromJson(response);
    }
    throw Exception('Invalid update question response');
  }

  @override
  Future<QuestionModel> partialUpdateQuestion({
    required int questionId,
    int? quizId,
    String? text,
    int? order,
    List<ChoiceEntity>? choices,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.questionDetail(questionId),
      data: {
        'quiz': ?quizId,
        'text': ?text,
        'order': ?order,
        if (choices != null)
          'choices': choices
              .map((c) => {
                    if (c.id != null) 'id': c.id,
                    'text': c.text,
                    'is_correct': c.isCorrect,
                  })
              .toList(),
      },
    );

    if (response is Map<String, dynamic>) {
      return QuestionModel.fromJson(response);
    }
    throw Exception('Invalid partial update question response');
  }

  @override
  Future<void> deleteQuestion(int questionId) async {
    await _apiClient.delete(ApiEndpoints.questionDetail(questionId));
  }
}
