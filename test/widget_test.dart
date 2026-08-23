import 'package:flutter_test/flutter_test.dart';
import 'package:education_app/core/utils/either.dart';
import 'package:education_app/features/auth/domain/entities/user_entity.dart';

void main() {
  test('UserEntity instantiation and equality check', () {
    const user1 = UserEntity(
      id: 1,
      email: 'student@example.com',
      username: 'student1',
      role: UserRole.student,
    );

    const user2 = UserEntity(
      id: 1,
      email: 'student@example.com',
      username: 'student1',
      role: UserRole.student,
    );

    expect(user1, equals(user2));
    expect(user1.role, equals(UserRole.student));
  });

  test('Either Right value fold returns expected value', () {
    const Either<String, int> either = Right(42);
    final result = either.fold(
      (left) => 0,
      (right) => right,
    );
    expect(result, equals(42));
  });
}
