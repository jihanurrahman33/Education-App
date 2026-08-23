import '../../domain/entities/quiz_entity.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.description,
    super.passingScore = 70,
    super.timeLimitMinutes = 30,
    super.questions = const [],
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    var rawQuestions = json['questions'] as List<dynamic>? ?? [];
    List<QuestionModel> questions = rawQuestions
        .whereType<Map<String, dynamic>>()
        .map((q) => QuestionModel.fromJson(q))
        .toList();

    return QuizModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      passingScore: json['passing_score'] is int
          ? json['passing_score'] as int
          : int.tryParse(json['passing_score']?.toString() ?? '70') ?? 70,
      timeLimitMinutes: json['time_limit_minutes'] is int
          ? json['time_limit_minutes'] as int
          : int.tryParse(json['time_limit_minutes']?.toString() ?? '30') ?? 30,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'passing_score': passingScore,
      'time_limit_minutes': timeLimitMinutes,
      'questions': questions.map((q) => (q as QuestionModel).toJson()).toList(),
    };
  }
}

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.quizId,
    required super.questionText,
    super.choices = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var rawChoices = json['choices'] as List<dynamic>? ?? [];
    List<ChoiceModel> choices = rawChoices
        .whereType<Map<String, dynamic>>()
        .map((c) => ChoiceModel.fromJson(c))
        .toList();

    return QuestionModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      quizId: json['quiz_id'] is int
          ? json['quiz_id'] as int
          : int.tryParse(json['quiz']?.toString() ?? '0') ?? 0,
      questionText: json['question_text'] as String? ?? json['text'] as String? ?? '',
      choices: choices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question_text': questionText,
      'choices': choices.map((c) => (c as ChoiceModel).toJson()).toList(),
    };
  }
}

class ChoiceModel extends ChoiceEntity {
  const ChoiceModel({
    required super.id,
    required super.questionId,
    required super.choiceText,
    super.isCorrect = false,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      questionId: json['question_id'] is int
          ? json['question_id'] as int
          : int.tryParse(json['question']?.toString() ?? '0') ?? 0,
      choiceText: json['choice_text'] as String? ?? json['text'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'choice_text': choiceText,
      'is_correct': isCorrect,
    };
  }
}

class QuizSubmissionResultModel extends QuizSubmissionResultEntity {
  const QuizSubmissionResultModel({
    required super.submissionId,
    required super.score,
    required super.totalQuestions,
    required super.isPassed,
  });

  factory QuizSubmissionResultModel.fromJson(Map<String, dynamic> json) {
    return QuizSubmissionResultModel(
      submissionId: json['submission_id'] is int
          ? json['submission_id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      score: json['score'] is int ? json['score'] as int : int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      totalQuestions: json['total_questions'] is int
          ? json['total_questions'] as int
          : int.tryParse(json['total_questions']?.toString() ?? '0') ?? 0,
      isPassed: json['is_passed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submission_id': submissionId,
      'score': score,
      'total_questions': totalQuestions,
      'is_passed': isPassed,
    };
  }
}
