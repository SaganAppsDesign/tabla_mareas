import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/di/injection_container.dart' as di;
import 'package:tabla_mareas/core/navigation/app_router.dart';
import 'package:tabla_mareas/core/config/app_config.dart';
import 'package:tabla_mareas/presentation/viewmodel/random_number_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodel/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodel/auth_viewmodel.dart';
import 'package:tabla_mareas/core/constants/app_constants.dart';
import 'package:tabla_mareas/core/config/app_theme.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appConfig = AppConfig.fromEnvironment();

  // Firebase is disabled for now in the template to allow it to run without configuration.
  /*
  if (appConfig.enableFirebase) {
    try {
      await Firebase.initializeApp().timeout(
        const Duration(seconds: AppConstants.firebaseTimeoutSeconds),
      );
    } catch (e) {
      debugPrint('Firebase initialization skipped or failed. '
          'Error details: ${e.toString()}');
    }
  }
  */

  try {
    await di.init(appConfig);
  } catch (e) {
    debugPrint('Dependency injection initialization error: ${e.toString()}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<RandomNumberViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<ThemeViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthViewModel>()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: AppConstants.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
