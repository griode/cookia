import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: Text("Contact Us"),
            ),
            ListTile(
              title: Text("Conditions and Privacy"),
            ),
          ],
        ),
      ),
    );
  }
}
