enum TideType { high, low }

class TideEvent {
  final DateTime time;
  final double height;
  final TideType type;

  const TideEvent({
    required this.time,
    required this.height,
    required this.type,
  });
}
