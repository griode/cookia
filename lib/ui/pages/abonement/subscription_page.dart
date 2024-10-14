import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

void showSubscriptionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const SubscriptionPage();
    },
  );
}

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    late final lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Image
                  const SizedBox(height: 16),
                  // App Title
                  Text(
                    lang.scan_gourmet_plus,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 16),

                  // Subscription Description
                  Text(
                    lang.unlock_features,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24),

                  // Features List with Icons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feature 1
                        Row(
                          children: [
                            Icon(
                              Icons.block,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lang.remove_ads,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Feature 2
                        Row(
                          children: [
                            Icon(Icons.receipt_long,
                                color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lang.generate_recipes,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Feature 3
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Theme.of(context).colorScheme.primary),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                lang.exclusive_premium_features,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Price Section
                  Text(
                    lang.only_per_month,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.8),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Button to Subscribe
                  FilledButton.icon(
                    onPressed: () {
                      // Logic to handle subscription
                    },
                    label: Text(lang.subscribe_now),
                  ),

                  const SizedBox(height: 16),

                  // Cancel Info
                  Text(
                    lang.cancel_anytime,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(HugeIcons.strokeRoundedCancel01),
              style: IconButton.styleFrom(
                elevation: 4,
                shadowColor: Theme.of(context).canvasColor,
                backgroundColor: Theme.of(context).canvasColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
