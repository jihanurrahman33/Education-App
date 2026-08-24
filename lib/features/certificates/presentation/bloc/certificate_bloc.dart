import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../progress/domain/entities/progress_entity.dart';
import '../../../progress/domain/usecases/get_my_progress_usecase.dart';
import '../../domain/entities/certificate_entity.dart';
import '../../domain/usecases/generate_certificate_usecase.dart';
import '../../domain/usecases/get_certificates_usecase.dart';
import 'certificate_event.dart';
import 'certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final GetCertificatesUseCase getCertificatesUseCase;
  final GenerateCertificateUseCase generateCertificateUseCase;
  final GetMyProgressUseCase getMyProgressUseCase;

  CertificateBloc({
    required this.getCertificatesUseCase,
    required this.generateCertificateUseCase,
    required this.getMyProgressUseCase,
  }) : super(const CertificateState()) {
    on<LoadCertificatesEvent>(_onLoadCertificates);
    on<ClaimCertificateEvent>(_onClaimCertificate);
  }

  Future<void> _onLoadCertificates(
    LoadCertificatesEvent event,
    Emitter<CertificateState> emit,
  ) async {
    emit(state.copyWith(status: CertificateStatus.loading, clearMessages: true));

    final results = await Future.wait([
      getCertificatesUseCase(const NoParams()),
      getMyProgressUseCase(),
    ]);

    final certsRes = results[0];
    final progressRes = results[1];

    var certsList = certsRes.fold(
      (_) => <CertificateEntity>[],
      (c) => c as List<CertificateEntity>,
    );

    final progressList = progressRes.fold(
      (_) => <CourseProgressEntity>[],
      (p) => p as List<CourseProgressEntity>,
    );

    // Auto-generate certificate for any 100% completed course if not generated yet
    final existingCertCourseIds = certsList.map((c) => c.course).toSet();
    for (final cp in progressList) {
      if ((cp.percentage >= 100.0 || (cp.totalLessons > 0 && cp.completedLessons >= cp.totalLessons)) &&
          !existingCertCourseIds.contains(cp.courseId)) {
        final genRes = await generateCertificateUseCase(
          GenerateCertificateParams(courseId: cp.courseId),
        );
        genRes.fold(
          (_) => null,
          (newCert) {
            certsList = [newCert, ...certsList];
            existingCertCourseIds.add(newCert.course);
          },
        );
      }
    }

    emit(state.copyWith(
      status: CertificateStatus.success,
      certificates: certsList,
    ));
  }

  Future<void> _onClaimCertificate(
    ClaimCertificateEvent event,
    Emitter<CertificateState> emit,
  ) async {
    emit(state.copyWith(status: CertificateStatus.loading, clearMessages: true));

    final result = await generateCertificateUseCase(
      GenerateCertificateParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CertificateStatus.failure,
        errorMessage: failure.message,
      )),
      (cert) {
        final updated = [cert, ...state.certificates.where((c) => c.id != cert.id)];
        emit(state.copyWith(
          status: CertificateStatus.success,
          certificates: updated,
          latestGeneratedCertificate: cert,
          successMessage: 'Certificate generated for "${cert.courseTitle}"!',
        ));
      },
    );
  }
}
