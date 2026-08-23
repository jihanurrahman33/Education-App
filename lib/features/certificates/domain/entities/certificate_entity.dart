import 'package:equatable/equatable.dart';

class CertificateEntity extends Equatable {
  final int id;
  final int courseId;
  final String courseTitle;
  final String studentName;
  final String certificateNumber;
  final DateTime issuedAt;
  final String? certificatePdfUrl;

  const CertificateEntity({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.studentName,
    required this.certificateNumber,
    required this.issuedAt,
    this.certificatePdfUrl,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        courseTitle,
        studentName,
        certificateNumber,
        issuedAt,
        certificatePdfUrl,
      ];
}
