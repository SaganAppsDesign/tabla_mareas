// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Premium Template';

  @override
  String get homeTitle => 'Home Screen';

  @override
  String get generateNumber => 'Generate Number';

  @override
  String get currentValue => 'Current Value';

  @override
  String get toggleThemeTooltip => 'Toggle theme';

  @override
  String get poweredByTemplate => 'Powered by Clean Architecture';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get navigationErrorPrefix => 'Error';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to continue your journey';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get signUpPrompt => 'Don\'t have an account?';

  @override
  String get signUpAction => 'Create Account';

  @override
  String get forgotPasswordAction => 'Forgot Password?';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get emptyPasswordError => 'Password cannot be empty';

  @override
  String get registerSubtitle => 'Join us and start your journey today';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get passwordTooShortError => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';

  @override
  String get errorUserNotFound => 'No user found with this email.';

  @override
  String get errorWrongPassword => 'Incorrect password. Please try again.';

  @override
  String get errorEmailInUse => 'This email is already registered.';

  @override
  String get errorWeakPassword => 'The password is too weak.';

  @override
  String get errorInvalidEmail => 'The email address is invalid.';

  @override
  String get errorUserDisabled => 'This user account has been disabled.';

  @override
  String get errorNetwork =>
      'A network error occurred. Please check your connection.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get signOutTooltip => 'Sign Out';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a password reset link';

  @override
  String get sendResetLinkButton => 'Send Reset Link';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get nameRequiredError => 'Please enter your name';

  @override
  String get guestLoginAction => 'Continue as Guest';
}
