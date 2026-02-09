import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/models/user_model.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:karaba/features/auth/data/models/complete_profile_params_model.dart';
import 'package:karaba/features/auth/data/models/sign_up_params_model.dart';
import 'package:karaba/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:karaba/features/auth/domain/usecases/complete_profile_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 1. Mocks and Fakes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class FakeSignUpParamsModel extends Fake implements SignUpParamsModel {}

class FakeCompleteProfileParamsModel extends Fake
    implements CompleteProfileParamsModel {}

void main() {
  late AuthRepositoryImp repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeSignUpParamsModel());
    registerFallbackValue(FakeCompleteProfileParamsModel());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImp(authRemoteDataSource: mockRemoteDataSource);
  });

  // --- Test Data ---
  const tUserModel = UserModel(
    id: 'uuid-123',
    email: 'test@karaba.com',
    fullName: 'Test User',
    hasFinishedProfile: false,
    role: UserRole.owner,
    idCardUrl: '',
    phoneNumber: '',
    isVerified: false,
  );

  final tSignUpParams = SignUpParams(
    email: 'test@test.com',
    password: 'password123',
    fullName: 'Mohamed',
    role: UserRole.renter,
    phoneNumber: '',
    idCardUrl: '',
  );

  const tCompleteParams = CompleteProfileParams(
    role: UserRole.renter,
    phoneNumber: '123456',
    userId: 'uuid-123',
    idCardPath: '/path/to/id.jpg',
  );

  // --- Tests ---

  group('signInWithEmail', () {
    const tSignInParams = SignInParams(
      email: 'test@test.com',
      password: 'password',
    );

    test('should return UserEntity on success', () async {
      when(
        () => mockRemoteDataSource.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithEmail(params: tSignInParams);

      expect(result, const Right(tUserModel));
    });

    test('should return Failure on AuthException', () async {
      when(
        () => mockRemoteDataSource.signInWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Invalid login'));

      final result = await repository.signInWithEmail(params: tSignInParams);

      expect(result.isLeft(), true);
    });
  });

  group('signUpWithEmail', () {
    test('should return UserEntity on success', () async {
      when(
        () =>
            mockRemoteDataSource.signUpWithEmail(params: any(named: 'params')),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signUpWithEmail(params: tSignUpParams);

      expect(result, const Right(tUserModel));
    });

    test('should return Failure on exception', () async {
      when(
        () =>
            mockRemoteDataSource.signUpWithEmail(params: any(named: 'params')),
      ).thenThrow(const AuthException('User exists'));

      final result = await repository.signUpWithEmail(params: tSignUpParams);

      expect(result.isLeft(), true);
    });
  });

  group('signInWithGoogle', () {
    test('should return UserEntity on success', () async {
      when(
        () => mockRemoteDataSource.signInWithGoogle(),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.signInWithGoogle();

      expect(result, const Right(tUserModel));
    });

    test('should return Failure on exception', () async {
      when(
        () => mockRemoteDataSource.signInWithGoogle(),
      ).thenThrow(const AuthException('Google Cancelled'));

      final result = await repository.signInWithGoogle();

      expect(result.isLeft(), true);
    });
  });

  group('getCurrentUser', () {
    test('should return UserEntity when session exists', () async {
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, const Right(tUserModel));
    });

    test('should return null (Right(null)) when no session exists', () async {
      when(
        () => mockRemoteDataSource.getCurrentUser(),
      ).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result, const Right(null));
    });
  });

  group('completeProfile', () {
    test('should return UserEntity on successful update', () async {
      when(
        () =>
            mockRemoteDataSource.completeProfile(params: any(named: 'params')),
      ).thenAnswer((_) async => tUserModel);

      final result = await repository.completeProfile(params: tCompleteParams);

      expect(result, const Right(tUserModel));
    });

    test('should return Failure on StorageException', () async {
      when(
        () =>
            mockRemoteDataSource.completeProfile(params: any(named: 'params')),
      ).thenThrow(const StorageException('Upload error'));

      final result = await repository.completeProfile(params: tCompleteParams);

      expect(result.isLeft(), true);
    });
  });

  group('resetPassword', () {
    test('should return Unit on success', () async {
      when(
        () => mockRemoteDataSource.resetPassword(email: any(named: 'email')),
      ).thenAnswer((_) async => unit);

      final result = await repository.resetPassword(email: 'test@test.com');

      expect(result, const Right(unit));
    });

    test('should return Failure on exception', () async {
      when(
        () => mockRemoteDataSource.resetPassword(email: any(named: 'email')),
      ).thenThrow(const AuthException('Email not found'));

      final result = await repository.resetPassword(email: 'test@test.com');

      expect(result.isLeft(), true);
    });
  });

  group('logout', () {
    test('should return Unit on successful logout', () async {
      when(() => mockRemoteDataSource.logout()).thenAnswer((_) async => unit);

      final result = await repository.logout();

      expect(result, const Right(unit));
    });

    test('should return Failure when logout fails', () async {
      when(() => mockRemoteDataSource.logout()).thenThrow(Exception());

      final result = await repository.logout();

      expect(result.isLeft(), true);
    });
  });
}
