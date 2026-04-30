enum TideType { high, low }

class TideEvent {
  const TideEvent({
    required this.time,
    required this.height,
    required this.type,
  });

  final DateTime time;
  final double height;
  final TideType type;
}
