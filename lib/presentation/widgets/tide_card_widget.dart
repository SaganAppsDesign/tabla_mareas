import 'package:flutter/material.dart';
import '../../domain/entities/tide_event.dart';

class TideCardWidget extends StatelessWidget {
  const TideCardWidget({super.key, required this.tideEvent});

  final TideEvent tideEvent;

  @override
  Widget build(BuildContext context) {
    final isHighTide = tideEvent.type == TideType.high;
    final colorScheme = Theme.of(context).colorScheme;
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final backgroundColor = isHighTide 
        ? Colors.blue.shade100!.withValues(alpha: isDarkMode ? 0.2 : 0.5) 
        : Colors.orange.shade100!.withValues(alpha: isDarkMode ? 0.2 : 0.5);
    final iconColor = isHighTide 
        ? (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700) 
        : (isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700);
    final icon = isHighTide ? Icons.arrow_upward : Icons.arrow_downward;
    final title = isHighTide ? 'Pleamar' : 'Bajamar';

    final timeString = '${tideEvent.time.hour.toString().padLeft(2, '0')}:${tideEvent.time.minute.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Altura',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${tideEvent.height.toStringAsFixed(1)} m',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
