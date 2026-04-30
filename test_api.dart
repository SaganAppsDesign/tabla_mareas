import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final response = await dio.get('https://tidesatlas.com/api/v1/tides',
      queryParameters: {
        'lat': 36.5271,
        'lon': -6.2886,
        'date': '2024-05-01',
        'days': 1
      },
      options: Options(headers: {
        'X-API-Key':
            'ta_fa71e9eceea78aeb82f637cf2470548719d463498ddd665b10eec318a1fd'
      }));
  print(response.data);
}
