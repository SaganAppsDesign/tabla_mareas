import 'package:dio/dio.dart';
import '../models/tide_event_model.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/tide_event.dart';

abstract class TideRemoteDataSource {
  Future<List<TideEventModel>> getTides(Location location, DateTime date);
}

class TideRemoteDataSourceImpl implements TideRemoteDataSource {
  final Dio dio;

  TideRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TideEventModel>> getTides(Location location, DateTime date) async {
    try {
      // TODO: Conectar a una API real (ej. StormGlass, WorldTides u Open-Meteo).
      // Por ahora devolvemos datos falsos simulando la respuesta para poder armar la UI.
      
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        TideEventModel(
          time: DateTime(date.year, date.month, date.day, 4, 15), 
          height: 0.8, 
          type: TideType.low
        ),
        TideEventModel(
          time: DateTime(date.year, date.month, date.day, 10, 30), 
          height: 3.2, 
          type: TideType.high
        ),
        TideEventModel(
          time: DateTime(date.year, date.month, date.day, 16, 45), 
          height: 0.9, 
          type: TideType.low
        ),
        TideEventModel(
          time: DateTime(date.year, date.month, date.day, 22, 50), 
          height: 3.1, 
          type: TideType.high
        ),
      ];
    } catch (e) {
      throw Exception('Error al conectar con la API');
    }
  }
}
