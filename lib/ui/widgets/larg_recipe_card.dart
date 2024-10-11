import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/utils/router/app_route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class LargeRecipeCard extends StatelessWidget {
  final Recipe recipe;
  const LargeRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    late AppLocalizations lang = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRouteName.detailRecipe.name,
        extra: recipe,
      ),
      child: Column(
        children: [
          Hero(
            tag: recipe.name!,
            child: Container(
              height: 360.0,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(recipe.image ?? ""),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 24,
              top: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recipe.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    const Icon(
                      HugeIcons.strokeRoundedTimeQuarter,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      lang.minutes(recipe.duration),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      HugeIcons.strokeRoundedUserFullView,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(lang.person(recipe.servings)),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  recipe.description ?? "",
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .color!
                        .withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4.0),
                const Divider()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
