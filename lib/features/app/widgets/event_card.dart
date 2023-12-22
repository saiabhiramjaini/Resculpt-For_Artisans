import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.isPast, required this.child});
  final bool isPast;
  final child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isPast ? Colors.black54 : Colors.grey,
      ),
      child: child,
    );
  }
}
