import 'package:flutter/material.dart';
import 'package:round2/features/app/widgets/event_card.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;
  const MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventCard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle:
            LineStyle(color: isPast ? Colors.black54 : Colors.grey),
        indicatorStyle: IndicatorStyle(
          color: isPast ? Colors.black : Colors.grey,
          width: 40,
          iconStyle: IconStyle(
              iconData: Icons.done,
              color: isPast ? Colors.white : Colors.deepPurple.shade100),
        ),
        endChild: EventCard(
          isPast: isPast,
          child: eventCard,
        ),
      ),
    );
  }
}
