import '../../domain/entities/quiz_entity.dart';

class QuizModel extends QuizEntity {
  const QuizModel({
    required super.id,
    required super.lesson,
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
      lesson: json['lesson'] is int
          ? json['lesson'] as int
          : int.tryParse(json['lesson']?.toString() ?? json['course_id']?.toString() ?? '0') ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      passScorePercent: json['pass_score_percent'] is int
          ? json['pass_score_percent'] as int
          : int.tryParse(json['pass_score_percent']?.toString() ?? json['passing_score']?.toString() ?? '70') ?? 70,
      createdAt: json['created_at'] as String?,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lesson': lesson,
      'title': title,
      'description': description,
      'pass_score_percent': passScorePercent,
      'created_at': createdAt,
      'questions': questions.map((q) => (q as QuestionModel).toJson()).toList(),
    };
  }
}

class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.quiz,
    required super.text,
    super.order = 1,
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
      quiz: json['quiz'] is int
          ? json['quiz'] as int
          : int.tryParse(json['quiz']?.toString() ?? json['quiz_id']?.toString() ?? '0') ?? 0,
      text: json['text'] as String? ?? json['question_text'] as String? ?? '',
      order: json['order'] is int ? json['order'] as int : int.tryParse(json['order']?.toString() ?? '1') ?? 1,
      choices: choices,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz': quiz,
      'text': text,
      'order': order,
      'choices': choices.map((c) => (c as ChoiceModel).toJson()).toList(),
    };
  }
}

class ChoiceModel extends ChoiceEntity {
  const ChoiceModel({
    required super.id,
    required super.text,
    super.isCorrect = false,
  });

  factory ChoiceModel.fromJson(Map<String, dynamic> json) {
    return ChoiceModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      text: json['text'] as String? ?? json['choice_text'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_correct': isCorrect,
    };
  }
}

class AnswerSubmitModel extends AnswerSubmitEntity {
  const AnswerSubmitModel({
    required super.questionId,
    required super.choiceId,
  });

  factory AnswerSubmitModel.fromJson(Map<String, dynamic> json) {
    return AnswerSubmitModel(
      questionId: json['question_id'] is int
          ? json['question_id'] as int
          : int.tryParse(json['question_id']?.toString() ?? '0') ?? 0,
      choiceId: json['choice_id'] is int
          ? json['choice_id'] as int
          : int.tryParse(json['choice_id']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'choice_id': choiceId,
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
    required super.quiz,
    required super.student,
    required super.scorePercent,
    required super.passed,
    required super.submittedAt,
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
      quiz: json['quiz'] is int
          ? json['quiz'] as int
          : int.tryParse(json['quiz']?.toString() ?? '0') ?? 0,
      student: json['student'] is int
          ? json['student'] as int
          : int.tryParse(json['student']?.toString() ?? '0') ?? 0,
      scorePercent: json['score_percent'] != null
          ? double.tryParse(json['score_percent'].toString()) ?? 0.0
          : (json['score'] != null ? double.tryParse(json['score'].toString()) ?? 0.0 : 0.0),
      passed: json['passed'] as bool? ?? json['is_passed'] as bool? ?? false,
      submittedAt: json['submitted_at'] as String? ?? '',
      answers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz': quiz,
      'student': student,
      'score_percent': scorePercent,
      'passed': passed,
      'submitted_at': submittedAt,
      'answers': answers.map((a) => (a as AnswerResultModel).toJson()).toList(),
    };
  }
}

// Backward-compatible alias for existing code
typedef QuizSubmissionResultModel = QuizResultModel;
