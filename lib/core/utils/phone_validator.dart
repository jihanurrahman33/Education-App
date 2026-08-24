import 'package:bd_phone_validator/bd_phone_validator.dart';

/// Centralized Bangladeshi Phone Number Validator utility.
///
/// Uses [BdPhoneValidator] for authenticating carrier prefixes and formats (e.g., 013-019).
class PhoneValidator {
  /// Validates a Bangladeshi phone number using [BdPhoneValidator].
  ///
  /// Returns `null` if valid (or if empty when [isRequired] is `false`).
  /// Returns an error message string if invalid.
  static String? validate(String? value, {bool isRequired = false}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Phone number is required';
      }
      return null;
    }

    final trimmed = value.trim();
    if (!BdPhoneValidator.validate(trimmed)) {
      return 'Enter a valid Bangladeshi phone number (e.g. 017XXXXXXXX)';
    }

    return null;
  }

  /// Checks whether a given string is a valid BD phone number.
  static bool isValid(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    return BdPhoneValidator.validate(value.trim());
  }
}
