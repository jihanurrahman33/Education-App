import '../../domain/entities/certificate_entity.dart';

class CertificateModel extends CertificateEntity {
  const CertificateModel({
    required super.id,
    required super.courseId,
    required super.courseTitle,
    required super.studentName,
    required super.certificateNumber,
    required super.issuedAt,
    super.certificatePdfUrl,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      courseId: json['course_id'] is int
          ? json['course_id'] as int
          : int.tryParse(json['course']?.toString() ?? '0') ?? 0,
      courseTitle: json['course_title'] as String? ?? json['course_name'] as String? ?? '',
      studentName: json['student_name'] as String? ?? json['user_name'] as String? ?? '',
      certificateNumber: json['certificate_number'] as String? ?? json['code'] as String? ?? '',
      issuedAt: json['issued_at'] != null
          ? DateTime.tryParse(json['issued_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      certificatePdfUrl: json['pdf_url'] as String? ?? json['file'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_title': courseTitle,
      'student_name': studentName,
      'certificate_number': certificateNumber,
      'issued_at': issuedAt.toIso8601String(),
      'pdf_url': certificatePdfUrl,
    };
  }
}
