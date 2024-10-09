import 'package:flutter/material.dart';

class ScanIcon extends StatelessWidget {
  const ScanIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _roundedPart(context),
        Divider(
          height: 8,
          endIndent: 8,
          indent: 8,
          color: Theme.of(context).textTheme.bodyLarge!.color!,
        ),
        Transform.rotate(
          angle: 3.1,
          child: _roundedPart(context),
        )
      ],
    );
  }

  Widget _roundedPart(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 12,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
            ),
            border: Border(
              left: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                width: 3,
              ),
              top: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                width: 3,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 14,
          height: 12,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
            ),
            border: Border(
              right: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                width: 3,
              ),
              top: BorderSide(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                width: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
