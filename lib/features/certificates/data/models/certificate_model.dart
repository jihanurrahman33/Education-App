import '../../domain/entities/certificate_entity.dart';

class CertificateModel extends CertificateEntity {
  const CertificateModel({
    required super.id,
    required super.certificateId,
    required super.student,
    required super.studentName,
    required super.course,
    required super.courseTitle,
    super.progressPercent = 100.0,
    required super.issuedAt,
    super.certificatePdfUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      certificateId: json['certificate_id'] as String? ?? json['certificate_number'] as String? ?? json['code'] as String? ?? '',
      student: json['student'] is int
          ? json['student'] as int
          : int.tryParse(json['student']?.toString() ?? '0') ?? 0,
      studentName: json['student_name'] as String? ?? json['user_name'] as String? ?? '',
      course: json['course'] is int
          ? json['course'] as int
          : int.tryParse(json['course']?.toString() ?? json['course_id']?.toString() ?? '0') ?? 0,
      courseTitle: json['course_title'] as String? ?? json['course_name'] as String? ?? '',
      progressPercent: json['progress_percent'] != null
          ? double.tryParse(json['progress_percent'].toString()) ?? 100.0
          : 100.0,
      issuedAt: json['issued_at'] as String? ?? DateTime.now().toIso8601String(),
      certificatePdfUrl: json['pdf_url'] as String? ?? json['file'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificate_id': certificateId,
      'student': student,
      'student_name': studentName,
      'course': course,
      'course_title': courseTitle,
      'progress_percent': progressPercent,
      'issued_at': issuedAt,
      'pdf_url': certificatePdfUrl,
    };
  }
}
