import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabla_mareas/core/config/app_config.dart';
import 'package:tabla_mareas/core/di/injection_container.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/presentation/viewmodels/home_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/views/home_screen.dart';
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
    di.sl.registerLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore());
  });

  testWidgets('HomeScreen UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => di.sl<HomeViewModel>()),
          ChangeNotifierProvider(create: (_) => di.sl<ThemeViewModel>()),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('es')],
          home: HomeScreen(),
        ),
      ),
    );

    // Wait for the Future.microtask and animations to settle
    await tester.pumpAndSettle();

    // Verify that our app bar has the correct title
    expect(find.text('Tabla de Mareas'), findsOneWidget);

    // Verify the location selector is loaded with "Cádiz"
    expect(find.text('Cádiz'), findsWidgets);

    // Verify that TideCardWidget is displayed by finding its "Pleamar" or "Bajamar" texts
    expect(find.text('Pleamar'), findsWidgets);
    expect(find.text('Bajamar'), findsWidgets);
  });
}
