import 'package:flutter_test/flutter_test.dart';
import 'package:education_app/features/quizzes/data/models/quiz_model.dart';

void main() {
  group('Quiz Models Tests', () {
    test('QuizModel fromJson and toJson serialization', () {
      final json = {
        'id': 101,
        'lesson': 5,
        'title': 'Flutter Clean Architecture Quiz',
        'description': 'Test your architecture knowledge',
        'pass_score_percent': 80,
        'created_at': '2026-08-24T12:00:00Z',
        'questions': [
          {
            'id': 1,
            'quiz': 101,
            'text': 'Which layer contains business logic?',
            'order': 1,
            'choices': [
              {'id': 1, 'text': 'Domain', 'is_correct': true},
              {'id': 2, 'text': 'Presentation', 'is_correct': false},
            ],
          }
        ],
      };

      final model = QuizModel.fromJson(json);

      expect(model.id, equals(101));
      expect(model.lessonId, equals(5));
      expect(model.title, equals('Flutter Clean Architecture Quiz'));
      expect(model.passScorePercent, equals(80));
      expect(model.questions.length, equals(1));
      expect(model.questions.first.choices.length, equals(2));

      final outputJson = model.toJson();
      expect(outputJson['lesson'], equals(5));
      expect(outputJson['title'], equals('Flutter Clean Architecture Quiz'));
      expect(outputJson['pass_score_percent'], equals(80));
    });

    test('QuestionModel fromJson creates valid entities', () {
      final json = {
        'id': 201,
        'quiz': 101,
        'text': 'What is the role of UseCase in Clean Architecture?',
        'order': 2,
        'choices': [
          {'id': 10, 'text': 'Encapsulate single business action', 'is_correct': true},
          {'id': 11, 'text': 'Render widgets', 'is_correct': false},
        ],
      };

      final question = QuestionModel.fromJson(json);

      expect(question.id, equals(201));
      expect(question.quizId, equals(101));
      expect(question.choices.length, equals(2));
      expect(question.choices.first.isCorrect, isTrue);
    });

    test('QuizResultModel fromJson parses score and answers', () {
      final json = {
        'id': 1,
        'quiz': 101,
        'student': 10,
        'score_percent': 100.0,
        'passed': true,
        'submitted_at': '2026-08-24T12:30:00Z',
        'answers': [
          {
            'question_id': '1',
            'question_text': 'Which layer contains business logic?',
            'selected_text': 'Domain',
            'is_correct': true,
          }
        ],
      };

      final result = QuizResultModel.fromJson(json);

      expect(result.id, equals(1));
      expect(result.quizId, equals(101));
      expect(result.studentId, equals(10));
      expect(result.scorePercent, equals(100.0));
      expect(result.passed, isTrue);
      expect(result.answers.length, equals(1));
      expect(result.answers.first.isCorrect, isTrue);
    });
  });
}
