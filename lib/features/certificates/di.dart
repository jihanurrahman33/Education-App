import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/certificate_remote_data_source.dart';
import 'data/repositories/certificate_repository_impl.dart';
import 'domain/repositories/certificate_repository.dart';
import 'domain/usecases/generate_certificate_usecase.dart';
import 'domain/usecases/get_certificates_usecase.dart';
import 'presentation/bloc/certificate_bloc.dart';

void initCertificateFeature(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<CertificateRemoteDataSource>(
    () => CertificateRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<CertificateRepository>(
    () => CertificateRepositoryImpl(remoteDataSource: sl<CertificateRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetCertificatesUseCase>(
    () => GetCertificatesUseCase(sl<CertificateRepository>()),
  );
  sl.registerLazySingleton<GenerateCertificateUseCase>(
    () => GenerateCertificateUseCase(sl<CertificateRepository>()),
  );

  // Presentation (Bloc)
  sl.registerFactory(
    () => CertificateBloc(
      getCertificatesUseCase: sl(),
      generateCertificateUseCase: sl(),
    ),
  );
}
