import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabla_mareas/core/config/app_config.dart';
import 'package:tabla_mareas/core/di/injection_container.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/presentation/viewmodel/random_number_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodel/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/view/random_number_screen.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  setUpAll(() async {
    // Clear GetIt before all tests
    await di.sl.reset();
    await di.init(AppConfig.dev);
    di.sl.allowReassignment = true;
    di.sl.registerLazySingleton<FirebaseAuth>(() => MockFirebaseAuth());
    di.sl.registerLazySingleton<FirebaseFirestore>(
      () => MockFirebaseFirestore(),
    );
  });

  testWidgets('RandomNumberScreen UI test with Localization', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => di.sl<RandomNumberViewModel>()),
          ChangeNotifierProvider(create: (_) => di.sl<ThemeViewModel>()),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          home: const RandomNumberScreen(),
        ),
      ),
    );

    // Wait for everything to load (including fonts, localization, etc)
    await tester.pumpAndSettle();

    // Verify that our app bar has the correct title from English localization.
    expect(find.text('Flutter Premium Template'), findsOneWidget);

    // Verify that the initial placeholder exists.
    expect(find.text('Current Value'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);

    // Verify the action button exists.
    expect(find.text('Generate Number'), findsOneWidget);
  });
}
