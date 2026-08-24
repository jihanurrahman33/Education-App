import 'package:equatable/equatable.dart';

abstract class CertificateEvent extends Equatable {
  const CertificateEvent();

  @override
  List<Object?> get props => [];
}

class LoadCertificatesEvent extends CertificateEvent {
  final int? page;

  const LoadCertificatesEvent({this.page});

  @override
  List<Object?> get props => [page];
}

class ClaimCertificateEvent extends CertificateEvent {
  final int courseId;

  const ClaimCertificateEvent(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
