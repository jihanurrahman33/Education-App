import 'package:equatable/equatable.dart';

class CertificateEntity extends Equatable {
  final int id;
  final String certificateId;
  final int student;
  final String studentName;
  final int course;
  final String courseTitle;
  final double progressPercent;
  final String issuedAt;
  final String? certificatePdfUrl;

  const CertificateEntity({
    required this.id,
    required this.certificateId,
    required this.student,
    required this.studentName,
    required this.course,
    required this.courseTitle,
    this.progressPercent = 100.0,
    required this.issuedAt,
    this.certificatePdfUrl,
  });

  // Backward-compatible alias helpers
  int get courseId => course;
  String get certificateNumber => certificateId;

  @override
  List<Object?> get props => [
        id,
        certificateId,
        student,
        studentName,
        course,
        courseTitle,
        progressPercent,
        issuedAt,
        certificatePdfUrl,
      ];
}
