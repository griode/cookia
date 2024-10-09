import 'package:flutter/material.dart';

class NotificationManager extends StatefulWidget {
  const NotificationManager({super.key});

  @override
  State<NotificationManager> createState() => _NotificationManagerState();
}

class _NotificationManagerState extends State<NotificationManager> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Notification",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SwitchListTile(
            title: const Text("Conseil santé notification"),
            value: true,
            onChanged: (v) {},
          ),
          SwitchListTile(
            title: const Text("New menu calandar"),
            value: false,
            onChanged: (v) {},
          ),
          SwitchListTile(
            title: const Text("Promotions"),
            value: true,
            onChanged: (v) {},
          ),
          const SizedBox(height: 32)
        ],
      ),
    );
  }
}
