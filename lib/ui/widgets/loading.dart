import 'package:flutter/material.dart';

class Loading {
  static show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
