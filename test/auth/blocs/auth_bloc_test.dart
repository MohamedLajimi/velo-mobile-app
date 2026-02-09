import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:karaba/core/common/entities/user_entity.dart';
import 'package:karaba/core/enums/user_role.dart';
import 'package:karaba/core/error/failure.dart';
import 'package:karaba/features/auth/domain/usecases/complete_profile_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/logout_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_in_with_google_use_case.dart';
import 'package:karaba/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:karaba/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockSignInWithGoogle extends Mock implements SignInWithGoogleUseCase {}

class MockSignInWithEmail extends Mock implements SignInWithEmailUseCase {}

class MockSignUpWithEmail extends Mock implements SignUpWithEmailUseCase {}

class MockCompleteProfile extends Mock implements CompleteProfileUseCase {}

class MockLogout extends Mock implements LogoutUseCase {}

// Fallbacks for any() matchers
class FakeSignInParams extends Fake implements SignInParams {}

class FakeSignUpParams extends Fake implements SignUpParams {}

class FakeCompleteProfileParams extends Fake implements CompleteProfileParams {}

void main() {
  late AuthBloc authBloc;
  late MockSignInWithGoogle mockGoogle;
  late MockSignInWithEmail mockEmail;
  late MockSignUpWithEmail mockSignUp;
  late MockCompleteProfile mockComplete;
  late MockLogout mockLogout;

  setUpAll(() {
    registerFallbackValue(FakeSignInParams());
    registerFallbackValue(FakeSignUpParams());
    registerFallbackValue(FakeCompleteProfileParams());
  });

  setUp(() {
    mockGoogle = MockSignInWithGoogle();
    mockEmail = MockSignInWithEmail();
    mockSignUp = MockSignUpWithEmail();
    mockComplete = MockCompleteProfile();
    mockLogout = MockLogout();

    authBloc = AuthBloc(
      signInWithGoogle: mockGoogle,
      signInWithEmailUseCase: mockEmail,
      signUpWithEmailUseCase: mockSignUp,
      completeProfileUseCase: mockComplete,
      logoutUseCase: mockLogout,
    );
  });

  tearDown(() => authBloc.close());

  const tUser = UserEntity(
    id: '1',
    email: 'test@test.com',
    fullName: 'Test',
    hasFinishedProfile: false,
    role: UserRole.owner,
    phoneNumber: '',
    idCardUrl: '',
  );

  group('AuthBloc - Events', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when SignInWithEmail is successful',
      build: () {
        when(
          () => mockEmail(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const SignInWithEmailRequested(email: 'e', password: 'p')),
      expect: () => [const AuthLoading(), const AuthSuccess(user: tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when SignUp fails',
      build: () {
        when(
          () => mockSignUp(any()),
        ).thenAnswer((_) async => const Left(ServerFailure('Fail')));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const SignUpWithEmailRequested(
          email: 'e',
          password: 'p',
          fullName: 'n',
          role: UserRole.renter,
          phoneNumber: '1',
          idCardUrl: 'u',
          avatarUrl: '',
        ),
      ),
      expect: () => [const AuthLoading(), const AuthError('Fail')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading(withGoogle: true), AuthSuccess] when Google login works',
      build: () {
        when(
          () => mockGoogle.call(),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignInWithGoogleRequested()),
      expect: () => [
        AuthLoading(withGoogle: true),
        const AuthSuccess(user: tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when profile is completed',
      build: () {
        when(
          () => mockComplete(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const CompleteProfileRequested(
          userId: '1',
          role: UserRole.owner,
          phoneNumber: '1',
          idCardPath: 'p',
        ),
      ),
      expect: () => [const AuthLoading(), const AuthSuccess(user: tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInitial] when logout is successful',
      build: () {
        when(() => mockLogout()).thenAnswer((_) async => const Right(unit));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [const AuthLoading(), AuthInitial()],
    );
  });
}
