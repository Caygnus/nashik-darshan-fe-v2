import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nashik/core/auth/unauthorized_notifier.dart';
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/core/network/api_client.dart';
import 'package:nashik/core/storage/secure_token_storage.dart';
import 'package:nashik/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nashik/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:nashik/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nashik/features/auth/domain/repositories/auth_repository.dart';
import 'package:nashik/features/auth/domain/use_cases/complete_oauth_callback.dart';
import 'package:nashik/features/auth/domain/use_cases/get_current_user.dart';
import 'package:nashik/features/auth/domain/use_cases/reset_password.dart';
import 'package:nashik/features/auth/domain/use_cases/sign_in_with_google.dart';
import 'package:nashik/features/auth/domain/use_cases/sign_out.dart';
import 'package:nashik/features/auth/domain/use_cases/signin_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/signup_with_email.dart';
import 'package:nashik/features/auth/domain/use_cases/verify_email.dart';
import 'package:nashik/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nashik/features/category/data/datasources/category_remote_datasource.dart';
import 'package:nashik/features/category/data/repositories/category_repository_impl.dart';
import 'package:nashik/features/category/domain/repositories/category_repository.dart';
import 'package:nashik/features/category/domain/usecases/get_categories.dart';
import 'package:nashik/features/category/domain/usecases/get_category_by_id.dart';
import 'package:nashik/features/category/domain/usecases/get_category_by_slug.dart';
import 'package:nashik/features/category/presentation/cubit/category_cubit.dart';
import 'package:nashik/features/health/data/datasources/health_remote_datasource.dart';
import 'package:nashik/features/health/data/repositories/health_repository_impl.dart';
import 'package:nashik/features/health/domain/repositories/health_repository.dart';
import 'package:nashik/features/health/domain/usecases/check_health.dart';
import 'package:nashik/features/places/data/datasources/place_remote_datasource.dart';
import 'package:nashik/features/places/data/repositories/place_repository_impl.dart';
import 'package:nashik/features/places/domain/repositories/place_repository.dart';

final locator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  locator.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  locator.registerLazySingleton<DioClient>(() => DioClient());

  // ===== CORE: Token storage & API client =====
  locator.registerLazySingleton<SecureTokenStorage>(
    () => SecureTokenStorageImpl(storage: locator<FlutterSecureStorage>()),
  );

  locator.registerLazySingleton<UnauthorizedNotifier>(
    () => UnauthorizedNotifier(),
  );

  locator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      tokenStorage: locator<SecureTokenStorage>(),
      onUnauthorized: () => locator<UnauthorizedNotifier>().trigger(),
    ),
  );

  // ===== AUTH FEATURE =====
  locator.registerLazySingleton<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImpl(),
  );

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: locator<ApiClient>(),
      tokenStorage: locator<SecureTokenStorage>(),
    ),
  );

  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      supabaseDataSource: locator<AuthSupabaseDataSource>(),
      tokenStorage: locator<SecureTokenStorage>(),
    ),
  );

  locator.registerLazySingleton<SignupWithEmail>(
    () => SignupWithEmail(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SigninWithEmail>(
    () => SigninWithEmail(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SignOut>(
    () => SignOut(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<SignInWithGoogle>(
    () => SignInWithGoogle(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<ResetPassword>(
    () => ResetPassword(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<VerifyEmail>(
    () => VerifyEmail(repository: locator<AuthRepository>()),
  );

  locator.registerLazySingleton<CompleteOAuthCallback>(
    () => CompleteOAuthCallback(repository: locator<AuthRepository>()),
  );

  locator.registerFactory<AuthCubit>(
    () => AuthCubit(
      signupWithEmail: locator<SignupWithEmail>(),
      signinWithEmail: locator<SigninWithEmail>(),
      getCurrentUser: locator<GetCurrentUser>(),
      signOut: locator<SignOut>(),
      signInWithGoogle: locator<SignInWithGoogle>(),
      resetPassword: locator<ResetPassword>(),
      verifyEmail: locator<VerifyEmail>(),
      unauthorizedNotifier: locator<UnauthorizedNotifier>(),
    ),
  );

  // ===== CATEGORY FEATURE =====
  locator.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiClient: locator<ApiClient>()),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: locator<CategoryRemoteDataSource>(),
    ),
  );
  locator.registerLazySingleton<GetCategories>(
    () => GetCategories(locator<CategoryRepository>()),
  );
  locator.registerLazySingleton<GetCategoryById>(
    () => GetCategoryById(locator<CategoryRepository>()),
  );
  locator.registerLazySingleton<GetCategoryBySlug>(
    () => GetCategoryBySlug(locator<CategoryRepository>()),
  );
  locator.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      getCategories: locator<GetCategories>(),
      getCategoryById: locator<GetCategoryById>(),
      getCategoryBySlug: locator<GetCategoryBySlug>(),
    ),
  );

  // ===== PLACE FEATURE (API) =====
  locator.registerLazySingleton<PlaceRemoteDataSource>(
    () => PlaceRemoteDataSourceImpl(apiClient: locator<ApiClient>()),
  );
  locator.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(
      remoteDataSource: locator<PlaceRemoteDataSource>(),
    ),
  );

  // ===== HEALTH FEATURE =====
  locator.registerLazySingleton<HealthRemoteDataSource>(
    () => HealthRemoteDataSourceImpl(apiClient: locator<ApiClient>()),
  );
  locator.registerLazySingleton<HealthRepository>(
    () => HealthRepositoryImpl(
      remoteDataSource: locator<HealthRemoteDataSource>(),
    ),
  );
  locator.registerLazySingleton<CheckHealth>(
    () => CheckHealth(locator<HealthRepository>()),
  );
}
