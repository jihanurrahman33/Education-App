import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/quiz_model.dart';

abstract class QuizRemoteDataSource {
  Future<QuizModel> getQuizDetails(int quizId);
  Future<QuizSubmissionResultModel> submitQuiz({
    required int quizId,
    required Map<int, int> selectedAnswers,
  });
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiClient _apiClient;

  const QuizRemoteDataSourceImpl({required this._apiClient});

  @override
  Future<QuizModel> getQuizDetails(int quizId) async {
    final response = await _apiClient.get('${ApiEndpoints.quizzes}$quizId/');

    if (response is Map<String, dynamic>) {
      return QuizModel.fromJson(response);
    }

    throw Exception('Invalid quiz details response');
  }

  @override
  Future<QuizSubmissionResultModel> submitQuiz({
    required int quizId,
    required Map<int, int> selectedAnswers,
  }) async {
    final formattedAnswers = selectedAnswers.entries.map((e) => {
          'question_id': e.key,
          'choice_id': e.value,
        }).toList();

    final response = await _apiClient.post(
      ApiEndpoints.submitQuiz,
      data: {
        'quiz_id': quizId,
        'answers': formattedAnswers,
      },
    );

    if (response is Map<String, dynamic>) {
      return QuizSubmissionResultModel.fromJson(response);
    }

    throw Exception('Invalid quiz submission response');
  }
}
