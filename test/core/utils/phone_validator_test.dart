import 'package:education_app/core/utils/phone_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneValidator Tests', () {
    test('Valid BD phone numbers with 01 prefix', () {
      expect(PhoneValidator.isValid('01712345678'), isTrue);
      expect(PhoneValidator.isValid('01812345678'), isTrue);
      expect(PhoneValidator.isValid('01912345678'), isTrue);
      expect(PhoneValidator.isValid('01312345678'), isTrue);
      expect(PhoneValidator.isValid('01412345678'), isTrue);
      expect(PhoneValidator.isValid('01512345678'), isTrue);
      expect(PhoneValidator.isValid('01612345678'), isTrue);
    });

    test('Valid BD phone numbers with country code (+88 / 88)', () {
      expect(PhoneValidator.isValid('+8801712345678'), isTrue);
      expect(PhoneValidator.isValid('8801812345678'), isTrue);
    });

    test('Invalid BD phone numbers', () {
      expect(PhoneValidator.isValid('01212345678'), isFalse); // Invalid prefix (012)
      expect(PhoneValidator.isValid('0171234567'), isFalse); // Too short (10 digits)
      expect(PhoneValidator.isValid('017123456789'), isFalse); // Too long (12 digits)
      expect(PhoneValidator.isValid('abcdefghijk'), isFalse); // Non-numeric
      expect(PhoneValidator.isValid(''), isFalse);
      expect(PhoneValidator.isValid(null), isFalse);
    });

    test('Validator method handles optional vs required', () {
      expect(PhoneValidator.validate(null, isRequired: false), isNull);
      expect(PhoneValidator.validate('', isRequired: false), isNull);
      expect(PhoneValidator.validate('   ', isRequired: false), isNull);
      expect(PhoneValidator.validate(null, isRequired: true), isNotNull);
      expect(PhoneValidator.validate('01712345678'), isNull);
      expect(PhoneValidator.validate('12345'), isNotNull);
    });
  });
}
