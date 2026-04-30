import 'package:flutter/material.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/tide_event.dart';
import '../../domain/usecases/get_tides_usecase.dart';

enum HomeState { initial, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.getTidesUseCase});
  final GetTidesUseCase getTidesUseCase;

  HomeState _state = HomeState.initial;
  HomeState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<TideEvent> _tides = [];
  List<TideEvent> get tides => _tides;

  Location? _selectedLocation;
  Location? get selectedLocation => _selectedLocation;

  final List<Location> _availableLocations = const [
    Location(id: 'sanlucar', name: 'Sanlúcar de Barrameda', latitude: 36.7781, longitude: -6.3506),
    Location(id: 'chipiona', name: 'Chipiona', latitude: 36.7368, longitude: -6.4385),
    Location(id: 'rota', name: 'Rota', latitude: 36.6231, longitude: -6.3582),
    Location(id: 'el_puerto', name: 'El Puerto de Santa María', latitude: 36.5938, longitude: -6.2330),
    Location(id: 'puerto_real', name: 'Puerto Real', latitude: 36.5292, longitude: -6.1911),
    Location(id: 'cadiz', name: 'Cádiz', latitude: 36.5295, longitude: -6.2975),
    Location(id: 'san_fernando', name: 'San Fernando', latitude: 36.4664, longitude: -6.1989),
    Location(id: 'chiclana', name: 'Chiclana de la Frontera', latitude: 36.4182, longitude: -6.1462),
    Location(id: 'conil', name: 'Conil de la Frontera', latitude: 36.2750, longitude: -6.0883),
    Location(id: 'vejer', name: 'Vejer de la Frontera', latitude: 36.2527, longitude: -5.9634),
    Location(id: 'barbate', name: 'Barbate', latitude: 36.1895, longitude: -5.9238),
    Location(id: 'tarifa', name: 'Tarifa', latitude: 36.0139, longitude: -5.6069),
    Location(id: 'algeciras', name: 'Algeciras', latitude: 36.1306, longitude: -5.4475),
    Location(id: 'los_barrios', name: 'Los Barrios', latitude: 36.1844, longitude: -5.4925),
    Location(id: 'san_roque', name: 'San Roque', latitude: 36.2106, longitude: -5.3844),
    Location(id: 'la_linea', name: 'La Línea de la Concepción', latitude: 36.1664, longitude: -5.3486),
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
