import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/domain/usecases/get_auth_state_usecase.dart';
import 'package:tabla_mareas/domain/usecases/reset_password_usecase.dart';
import 'package:tabla_mareas/domain/usecases/sign_in_usecase.dart';
import 'package:tabla_mareas/domain/usecases/sign_out_usecase.dart';
import 'package:tabla_mareas/domain/usecases/sign_up_usecase.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GetAuthStateUseCase getAuthStateUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _getAuthStateUseCase = getAuthStateUseCase {
    _init();
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetAuthStateUseCase _getAuthStateUseCase;

  AuthStatus _status = AuthStatus.unauthenticated;
  AuthStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Failure? _failure;
  Failure? get failure => _failure;

  String mapFailureToMessage(AppLocalizations l10n) {
    if (_failure == null) return '';
    final failure = _failure!;
    if (failure is FirebaseFailure) {
      return switch (failure.code) {
        'user-not-found' => l10n.errorUserNotFound,
        'wrong-password' => l10n.errorWrongPassword,
        'email-already-in-use' => l10n.errorEmailInUse,
        'weak-password' => l10n.errorWeakPassword,
        'invalid-email' => l10n.errorInvalidEmail,
        'user-disabled' => l10n.errorUserDisabled,
        'network-request-failed' => l10n.errorNetwork,
        'too-many-requests' => l10n.errorTooManyRequests,
        _ => failure.message.isNotEmpty ? failure.message : l10n.errorUnknown,
      };
    }
    return failure.message.isNotEmpty ? failure.message : l10n.errorUnknown;
  }

  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  StreamSubscription<bool>? _authSubscription;
  bool _isGuest = false;
  bool get isGuest => _isGuest;

  void _init() {
    _authSubscription = _getAuthStateUseCase().listen((isAuthenticated) {
      if (_isGuest && !isAuthenticated) {
        return;
      }
      _status = isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _signInUseCase(email, password);
    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _failure = failure;
        _errorMessage = failure.message;
      },
      (_) {
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  void signInAsGuest() {
    _isGuest = true;
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, {String? displayName}) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _signUpUseCase(email, password, displayName: displayName);
    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _failure = failure;
        _errorMessage = failure.message;
      },
      (_) {
        _status = AuthStatus.authenticated;
      },
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    _isGuest = false;
    await _signOutUseCase();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _resetPasswordUseCase(email);
    result.fold(
      (failure) {
        _status = AuthStatus.error;
        _failure = failure;
        _errorMessage = failure.message;
      },
      (_) {
        _status = AuthStatus.unauthenticated; // Or a specific status for success
      },
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
