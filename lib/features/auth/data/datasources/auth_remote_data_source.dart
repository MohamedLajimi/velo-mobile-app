import 'package:google_sign_in/google_sign_in.dart';
import 'package:karaba/core/common/models/user_model.dart';
import 'package:karaba/core/services/storage_service.dart';
import 'package:karaba/features/auth/data/models/sign_up_params_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({required SignUpParamsModel params});

  Future<(UserModel, bool)> signInWithGoogle();

  Future<UserModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<void> logout();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final StorageService _storageService;

  SupabaseAuthRemoteDataSource({
    required SupabaseClient supabaseClient,
    required StorageService storageService,
  }) : _supabaseClient = supabaseClient,
       _storageService = storageService;

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('auth.error.user_not_found');
    }

    final profileData = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', response.user!.id)
        .single();

    return UserModel.fromJson(profileData);
  }

  @override
  Future<UserModel> signUpWithEmail({required SignUpParamsModel params}) async {
    final response = await _supabaseClient.auth.signUp(
      email: params.email,
      password: params.password,
      data: params.toJson(),
    );

    final userId = response.user?.id;
    if (userId == null) throw AuthException('auth.error.user_not_found');

    String? avatarUrl;

    if (params.avatarUrl != null) {
      avatarUrl = await _storageService
          .uploadFile(
            bucket: 'avatars',
            localPath: params.avatarUrl!,
            folderPath: userId,
            prefix: 'avatar',
          )
          .catchError((_) => null);
    }

    final String? idCardUrl = await _storageService.uploadFile(
      bucket: 'identity_cards',
      folderPath: userId,
      localPath: params.idCardUrl,
      prefix: 'id_card',
    );

    if (idCardUrl == null) {
      throw const StorageException('auth.error.id_card_upload_failure');
    }

    final profileData = await _supabaseClient
        .from('profiles')
        .upsert({
          ...params.toJson(),
          'id': userId,
          'id_card_url': idCardUrl,
          'avatar_url': avatarUrl,
        })
        .select()
        .single();

    return UserModel.fromJson(profileData);
  }

  @override
  Future<(UserModel, bool)> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    final authResponse = await _supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken!,
    );

    final existingProfile = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', authResponse.user!.id)
        .maybeSingle();

    final profileData = await _supabaseClient
        .from('profiles')
        .upsert({
          'id': authResponse.user!.id,
          'email': googleUser.email,
          if (existingProfile == null) 'full_name': googleUser.displayName,
          if (existingProfile == null) 'avatar_url': googleUser.photoUrl,
        })
        .select()
        .single();

    final unfinishedProfile = existingProfile == null;

    return (UserModel.fromJson(profileData), unfinishedProfile);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final session = _supabaseClient.auth.currentSession;
    if (session == null) return null;

    final profileData = await _supabaseClient
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .single();

    return UserModel.fromJson(profileData);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _supabaseClient.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> logout() async {
    await Future.wait([
      _supabaseClient.auth.signOut(),
      GoogleSignIn.instance.signOut(),
    ]);
  }
}
