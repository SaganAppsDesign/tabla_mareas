import '../../domain/entities/tide_event.dart';

class TideEventModel extends TideEvent {
  const TideEventModel({
    required super.time,
    required super.height,
    required super.type,
  });

  factory TideEventModel.fromJson(Map<String, dynamic> json) {
    return TideEventModel(
      time: DateTime.parse(json['time']),
      height: (json['height'] as num).toDouble(),
      type: json['type'] == 'high' ? TideType.high : TideType.low,
    );
  }
}
