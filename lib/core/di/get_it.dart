import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/domain/use_cases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/signup_with_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';

final locator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // Initialize encrypted secure storage
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  locator.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  // Register DioClient
  locator.registerLazySingleton<DioClient>(() => DioClient());

  // ===== AUTH FEATURE =====

  // 1. Data Sources
  locator.registerLazySingleton<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImpl(),
  );

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: locator<DioClient>()),
  );

  // 2. Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      supabaseDataSource: locator<AuthSupabaseDataSource>(),
    ),
  );

  // 3. Use Cases
  locator.registerLazySingleton<SignupWithEmail>(
    () => SignupWithEmail(
      repository: locator<AuthRepository>(),
      supabaseDataSource: locator<AuthSupabaseDataSource>(),
    ),
  );

  locator.registerLazySingleton<SigninWithEmail>(
    () => SigninWithEmail(
      repository: locator<AuthRepository>(),
      supabaseDataSource: locator<AuthSupabaseDataSource>(),
    ),
  );

  locator.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(locator<AuthRepository>()),
  );

  locator.registerFactory<AuthCubit>(
    () => AuthCubit(
      signupWithEmail: locator<SignupWithEmail>(),
      signinWithEmail: locator<SigninWithEmail>(),
      getCurrentUser: locator<GetCurrentUser>(),
    ),
  );

  // Register your other features' dependencies here following this pattern:
  // 1. Data Sources
  // 2. Repositories
  // 3. Use Cases
  // 4. Blocs
}
