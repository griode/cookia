import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ErrorGenerate extends StatelessWidget {
  final Function() onPressed;

  const ErrorGenerate({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48.0),
        const Text(
          "😔 Oops, we encountered a problem.",
          style: TextStyle(fontSize: 24.0),
        ),
        const SizedBox(height: 4.0),
        const Text("Please try again later."),
        const SizedBox(height: 12.0),
        Center(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodySmall,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 0.0,
              ),
              side: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                width: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
            onPressed: onPressed,
            icon: const Icon(
              HugeIcons.strokeRoundedRefresh,
              size: 16.0,
            ),
            label: const Text("Retry"),
          ),
        ),
      ],
    );
  }
}
