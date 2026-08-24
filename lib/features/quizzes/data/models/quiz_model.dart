import '../../domain/entities/quiz_entity.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.lessonId,
    required super.title,
    super.description = '',
    super.passScorePercent = 70,
    super.createdAt,
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
      lessonId: json['lesson'] is int
          ? json['lesson'] as int
          : int.tryParse(json['lesson_id']?.toString() ?? json['lesson']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      passScorePercent: json['pass_score_percent'] is int
          ? json['pass_score_percent'] as int
          : int.tryParse(json['pass_score_percent']?.toString() ?? '70') ?? 70,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson': lessonId,
      'title': title,
      'description': description,
      'pass_score_percent': passScorePercent,
    };
  }
}

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.quizId,
    required super.text,
    super.order = 0,
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
      quizId: json['quiz'] is int
          ? json['quiz'] as int
          : int.tryParse(json['quiz_id']?.toString() ?? json['quiz']?.toString() ?? '0') ?? 0,
      text: json['text'] as String? ?? '',
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      choices: choices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz': quizId,
      'text': text,
      'order': order,
      'choices': choices.map((c) => (c as ChoiceModel).toJson()).toList(),
    };
  }
}

class ChoiceModel extends ChoiceEntity {
  const ChoiceModel({
    super.id,
    required super.text,
    super.isCorrect = false,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      text: json['text'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'is_correct': isCorrect,
    };
  }
}

class AnswerResultModel extends AnswerResultEntity {
  const AnswerResultModel({
    required super.questionId,
    required super.questionText,
    required super.selectedText,
    required super.isCorrect,
  });

  factory AnswerResultModel.fromJson(Map<String, dynamic> json) {
    return AnswerResultModel(
      questionId: json['question_id']?.toString() ?? '',
      questionText: json['question_text'] as String? ?? '',
      selectedText: json['selected_text'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'question_text': questionText,
      'selected_text': selectedText,
      'is_correct': isCorrect,
    };
  }
}

class QuizResultModel extends QuizResultEntity {
  const QuizResultModel({
    required super.id,
    required super.quizId,
    required super.studentId,
    required super.scorePercent,
    required super.passed,
    super.submittedAt,
    super.answers = const [],
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    var rawAnswers = json['answers'] as List<dynamic>? ?? [];
    List<AnswerResultModel> answers = rawAnswers
        .whereType<Map<String, dynamic>>()
        .map((a) => AnswerResultModel.fromJson(a))
        .toList();

    return QuizResultModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      quizId: json['quiz'] is int
          ? json['quiz'] as int
          : int.tryParse(json['quiz_id']?.toString() ?? json['quiz']?.toString() ?? '0') ?? 0,
      studentId: json['student'] is int
          ? json['student'] as int
          : int.tryParse(json['student_id']?.toString() ?? json['student']?.toString() ?? '0') ?? 0,
      scorePercent: json['score_percent'] != null
          ? double.tryParse(json['score_percent'].toString()) ?? 0.0
          : 0.0,
      passed: json['passed'] as bool? ?? false,
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz': quizId,
      'student': studentId,
      'score_percent': scorePercent,
      'passed': passed,
      'submitted_at': submittedAt?.toIso8601String(),
      'answers': answers.map((a) => (a as AnswerResultModel).toJson()).toList(),
    };
  }
}
