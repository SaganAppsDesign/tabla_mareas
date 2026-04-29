// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Plantilla Flutter Premium';

  @override
  String get homeTitle => 'Pantalla de Inicio';

  @override
  String get generateNumber => 'Generar Número';

  @override
  String get currentValue => 'Valor Actual';

  @override
  String get toggleThemeTooltip => 'Cambiar tema';

  @override
  String get poweredByTemplate => 'Impulsado por Clean Architecture';

  @override
  String get genericError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get navigationErrorPrefix => 'Error';

  @override
  String get loginTitle => 'Bienvenido';

  @override
  String get loginSubtitle => 'Inicia sesión para continuar';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get signInButton => 'Iniciar Sesión';

  @override
  String get signUpPrompt => '¿No tienes cuenta?';

  @override
  String get signUpAction => 'Crear Cuenta';

  @override
  String get forgotPasswordAction => '¿Olvidaste tu contraseña?';

  @override
  String get invalidEmailError => 'Ingresa un correo válido';

  @override
  String get emptyPasswordError => 'La contraseña no puede estar vacía';

  @override
  String get registerSubtitle => 'Únete a nosotros hoy mismo';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get passwordTooShortError => 'Mínimo 6 caracteres';

  @override
  String get passwordsDoNotMatchError => 'Las contraseñas no coinciden';

  @override
  String get errorUserNotFound => 'Usuario no encontrado.';

  @override
  String get errorWrongPassword => 'Contraseña incorrecta.';

  @override
  String get errorEmailInUse => 'Este correo ya está registrado.';

  @override
  String get errorWeakPassword => 'La contraseña es muy débil.';

  @override
  String get errorInvalidEmail => 'El correo no es válido.';

  @override
  String get errorUserDisabled =>
      'Esta cuenta de usuario ha sido deshabilitada.';

  @override
  String get errorNetwork => 'Ocurrió un error de red. Revisa tu conexión.';

  @override
  String get errorTooManyRequests =>
      'Demasiados intentos. Inténtalo más tarde.';

  @override
  String get errorUnknown => 'Ocurrió un error inesperado. Inténtalo de nuevo.';

  @override
  String get signOutTooltip => 'Cerrar sesión';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordSubtitle =>
      'Ingresa tu correo para recibir un enlace de recuperación';

  @override
  String get sendResetLinkButton => 'Enviar enlace';

  @override
  String get fullNameLabel => 'Nombre Completo';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get nameRequiredError => 'Por favor, ingresa tu nombre';
}
