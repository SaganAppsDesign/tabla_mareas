import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/tide_event.dart';
import '../../domain/usecases/get_tides_usecase.dart';

enum HomeState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final GetTidesUseCase getTidesUseCase;

  HomeViewModel({required this.getTidesUseCase});

  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<TideEvent> _tides = [];
  List<TideEvent> get tides => _tides;

  Location? _selectedLocation;
  Location? get selectedLocation => _selectedLocation;

  final List<Location> _availableLocations = const [
    Location(id: 'cadiz', name: 'Cádiz', latitude: 36.5298, longitude: -6.2924),
    Location(id: 'conil', name: 'Conil de la Frontera', latitude: 36.2750, longitude: -6.0883),
  ];
  List<Location> get availableLocations => _availableLocations;

  void selectLocation(Location location) {
    _selectedLocation = location;
    loadTidesForDate(DateTime.now());
  }

  Future<void> loadTidesForDate(DateTime date) async {
    if (_selectedLocation == null) return;

    _state = HomeState.loading;
    notifyListeners();

    final result = await getTidesUseCase(_selectedLocation!, date);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = HomeState.error;
      },
      (tidesList) {
        _tides = tidesList;
        _state = HomeState.loaded;
      },
    );

    notifyListeners();
  }
}
