import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

Widget backButton(BuildContext context) {
  return IconButton(
    onPressed: () => context.pop(),
    icon: const Icon(
      HugeIcons.strokeRoundedArrowLeft01,
      size: 32,
    ),
  );
}
