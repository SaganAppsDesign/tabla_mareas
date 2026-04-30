import 'dart:async';

// ignore_for_file: unused_import

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/repositories/random_number_repository.dart';
import 'package:tabla_mareas/data/repositories_impl/random_number_repository_impl.dart';
import 'package:tabla_mareas/data/datasources/random_number_remote_data_source.dart';
import 'package:tabla_mareas/domain/usecases/get_random_number_usecase.dart';
import 'package:tabla_mareas/presentation/viewmodels/random_number_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/domain/repositories/tide_repository.dart';
import 'package:tabla_mareas/data/datasources/tide_remote_data_source.dart';
import 'package:tabla_mareas/data/repositories/tide_repository_impl.dart';
import 'package:tabla_mareas/domain/usecases/get_tides_usecase.dart';
import 'package:tabla_mareas/presentation/viewmodels/home_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tabla_mareas/core/services/secure_storage_service.dart';
import 'package:tabla_mareas/core/network/dio_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabla_mareas/domain/repositories/auth_repository.dart';
import 'package:tabla_mareas/data/datasources/firebase_auth_service.dart';
import 'package:tabla_mareas/domain/usecases/sign_in_usecase.dart';
import 'package:tabla_mareas/domain/usecases/sign_up_usecase.dart';
import 'package:tabla_mareas/domain/usecases/sign_out_usecase.dart';
import 'package:tabla_mareas/domain/usecases/reset_password_usecase.dart';
import 'package:tabla_mareas/domain/usecases/get_auth_state_usecase.dart';
import 'package:tabla_mareas/presentation/viewmodels/auth_viewmodel.dart';
import 'package:tabla_mareas/core/config/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tabla_mareas/data/datasources/firestore_remote_data_source.dart';
import 'package:tabla_mareas/domain/repositories/firestore_repository.dart';
import 'package:tabla_mareas/data/repositories_impl/firestore_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init(AppConfig appConfig) async {
  // Features - Random Number

  // ViewModels
  sl.registerFactory(() => RandomNumberViewModel(sl()));
  sl.registerFactory(() => HomeViewModel(getTidesUseCase: sl()));
  sl.registerLazySingleton(
    () => AuthViewModel(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      resetPasswordUseCase: sl(),
      getAuthStateUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => ThemeViewModel());

  // Use cases
  sl.registerLazySingleton(() => GetRandomNumberUseCase(sl()));
  sl.registerLazySingleton(() => GetTidesUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStateUseCase(sl()));

  // Data sources
  sl.registerLazySingleton<RandomNumberRemoteDataSource>(
    () => RandomNumberRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<TideRemoteDataSource>(
    () => TideRemoteDataSourceImpl(dio: sl()),
  );
  // sl.registerLazySingleton<FirestoreRemoteDataSource>(
  //   () => FirestoreRemoteDataSourceImpl(sl()),
  // );
  sl.registerLazySingleton<FirestoreRemoteDataSource>(
    () => MockFirestoreRemoteDataSource(),
  );

  // Repository
  sl.registerLazySingleton<RandomNumberRepository>(
    () => RandomNumberRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<TideRepository>(
    () => TideRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FirestoreRepository>(
    () => FirestoreRepositoryImpl(sl()),
  );
  // sl.registerLazySingleton<AuthRepository>(() => FirebaseAuthService(sl()));
  sl.registerLazySingleton<AuthRepository>(() => MockAuthService());

  // Core
  sl.registerLazySingleton<SecurityService>(
    () => SecureStorageService(const FlutterSecureStorage()),
  );
  sl.registerLazySingleton(() => DioClient(sl()));

  // External
  sl.registerLazySingleton(() => Dio());
  // Firebase instances are commented out because initialization is disabled in main.dart
  /*
  sl.registerLazySingleton(() {
    if (Firebase.apps.isEmpty) {
      throw Exception(
        'FirebaseFirestore access attempted but Firebase is not initialized. '
        'Check your Firebase configuration and initialization in main.dart.',
      );
    }
    return FirebaseFirestore.instance;
  });

  sl.registerLazySingleton(() {
    if (Firebase.apps.isEmpty) {
      throw Exception(
        'FirebaseAuth access attempted but Firebase is not initialized. '
        'Check your Firebase configuration and initialization in main.dart.',
      );
    }
    return FirebaseAuth.instance;
  });
  */

  // App Config
  sl.registerLazySingleton(() => appConfig);
}

// --- MOCK IMPLEMENTATIONS FOR TEMPLATE (RUN WITHOUT FIREBASE) ---
class MockAuthService implements AuthRepository {
  MockAuthService() {
    // Add a small delay to allow AuthViewModel to start listening
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_controller.isClosed) {
        _controller.add(_isAuthenticated);
      }
    });
  }
  final _controller = StreamController<bool>.broadcast();
  bool _isAuthenticated = false;

  @override
  Stream<bool> get authStateChanges => _controller.stream;

  @override
  Future<Either<Failure, void>> signIn(String email, String password) async {
    // Simulating a delay
    await Future.delayed(const Duration(seconds: 1));

    // DEMO CREDENTIALS: admin@example.com / admin123
    if (email == 'admin@example.com' && password == 'admin123') {
      _isAuthenticated = true;
      _controller.add(true);
      return const Right(null);
    } else {
      return const Left(
        FirebaseFailure('Invalid email or password', 'wrong-password'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signUp(String email, String password, {String? displayName}) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _controller.add(true);
    return const Right(null);
  }

  @override
  Future<void> signOut() async {
    _isAuthenticated = false;
    _controller.add(false);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    return const Right(null);
  }
}

class MockFirestoreRemoteDataSource implements FirestoreRemoteDataSource {
  @override
  Future<void> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {}

  @override
  Future<void> deleteDocument(String collectionPath, String documentId) async {}

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String documentId,
  ) async {
    // Return a dummy future to avoid unhandled errors in UI initialization
    return Future.error(UnimplementedError('Firestore is disabled in template mode.'));
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(
    String collectionPath,
  ) {
    return const Stream.empty();
  }

  @override
  Future<void> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {}
}
