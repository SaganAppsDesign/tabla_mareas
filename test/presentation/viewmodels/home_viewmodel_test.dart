import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:tabla_mareas/core/errors/failures.dart';
import 'package:tabla_mareas/domain/entities/location.dart';
import 'package:tabla_mareas/domain/entities/tide_event.dart';
import 'package:tabla_mareas/domain/usecases/get_tides_usecase.dart';
import 'package:tabla_mareas/presentation/viewmodels/home_viewmodel.dart';

class MockGetTidesUseCase extends Mock implements GetTidesUseCase {}
class FakeLocation extends Fake implements Location {}

void main() {
  late HomeViewModel viewModel;
  late MockGetTidesUseCase mockGetTidesUseCase;

  setUpAll(() {
    registerFallbackValue(FakeLocation());
  });

  setUp(() {
    mockGetTidesUseCase = MockGetTidesUseCase();
    viewModel = HomeViewModel(getTidesUseCase: mockGetTidesUseCase);
  });

  final tLocation = const Location(id: '1', name: 'Test', latitude: 0.0, longitude: 0.0);
  final tDate = DateTime.now();
  final tTides = [
    TideEvent(time: tDate, height: 1.0, type: TideType.high)
  ];

  test('estado inicial debe ser initial', () {
    expect(viewModel.state, HomeState.initial);
  });

  test('debe actualizar estado a loaded y cargar mareas cuando es exitoso', () async {
    when(() => mockGetTidesUseCase(any(), any()))
        .thenAnswer((_) async => Right(tTides));

    viewModel.selectLocation(tLocation);
    await Future.delayed(Duration.zero);

    expect(viewModel.state, HomeState.loaded);
    expect(viewModel.tides, tTides);
  });

  test('debe actualizar estado a error cuando falla', () async {
    when(() => mockGetTidesUseCase(any(), any()))
        .thenAnswer((_) async => const Left(NetworkFailure('Error de red')));

    viewModel.selectLocation(tLocation);
    await Future.delayed(Duration.zero);

    expect(viewModel.state, HomeState.error);
    expect(viewModel.errorMessage, 'Error de red');
  });
}
