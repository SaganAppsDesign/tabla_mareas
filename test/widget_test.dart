import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tabla_mareas/core/config/app_config.dart';
import 'package:tabla_mareas/core/di/injection_container.dart' as di;
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/domain/usecases/get_tides_usecase.dart';
import 'package:tabla_mareas/presentation/viewmodels/home_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/views/home_screen.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:tabla_mareas/domain/entities/location.dart';
import 'package:tabla_mareas/domain/entities/tide_event.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockHomeViewModel extends ChangeNotifier implements HomeViewModel {
  @override
  HomeState get state => HomeState.loaded;

  @override
  List<TideEvent> get tides => [
    TideEvent(time: DateTime.now(), height: 1, type: TideType.high),
    TideEvent(time: DateTime.now(), height: 0.5, type: TideType.low),
  ];

  @override
  List<Location> get availableLocations => const [
    Location(id: 'cadiz', name: 'Cádiz', latitude: 36.5, longitude: -6.2),
  ];

  @override
  Location? get selectedLocation => availableLocations.first;

  @override
  String get errorMessage => '';

  @override
  Future<void> loadTidesForDate(DateTime date) async {}

  @override
  void selectLocation(Location location) {}

  @override
  // TODO: implement getTidesUseCase
  GetTidesUseCase get getTidesUseCase => throw UnimplementedError();
}

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
    di.sl.registerFactory<HomeViewModel>(() => MockHomeViewModel());
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
