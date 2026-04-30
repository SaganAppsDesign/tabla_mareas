import 'package:dio/dio.dart';
import '../models/tide_event_model.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/tide_event.dart';

abstract class TideRemoteDataSource {
  Future<List<TideEventModel>> getTides(Location location, DateTime date);
}

class TideRemoteDataSourceImpl implements TideRemoteDataSource {
  TideRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<TideEventModel>> getTides(
    Location location,
    DateTime date,
  ) async {
    try {
      // TODO: Configurar la URL base, API Keys y parámetros en un archivo de configuración
      const String baseUrl = 'https://tidesatlas.com/api/v1/tides';
      const String apiKey =
          'ta_fa71e9eceea78aeb82f637cf2470548719d463498ddd665b10eec318a1fd'; // TODO: Mover esto a variables de entorno o Config

      final String formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'lat': location.latitude,
          'lon': location.longitude,
          'date': formattedDate,
          'days': 1,
        },
        options: Options(headers: {'X-API-Key': apiKey}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> extremes = response.data['extremes'] ?? [];

        return extremes.map((dynamic item) {
          final Map<String, dynamic> json = item as Map<String, dynamic>;
          return TideEventModel(
            time: DateTime.parse(json['datetime']),
            height: (json['height_m'] as num).toDouble(),
            type: json['type'] == 'high' ? TideType.high : TideType.low,
          );
        }).toList();
      } else {
        throw Exception(
          'Error al obtener las mareas: Código ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Error de red al conectar con la API: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido al procesar las mareas: $e');
    }
  }
}
