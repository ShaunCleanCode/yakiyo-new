import 'package:flutter/material.dart';

class EventLogScreen extends StatelessWidget {
  const EventLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Log'),
      ),
      body: const Center(
        child: Text('Event Log Screen'),
      ),
    );
  }
}
