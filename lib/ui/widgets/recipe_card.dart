import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  late AppLocalizations lang;

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    var textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRouteName.detailRecipe.name,
        extra: widget.recipe,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Hero(
              tag: widget.recipe.name!,
              child: Container(
                height: 360.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(widget.recipe.image ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.86),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                child: ClipRRect(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.recipe.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedTimeQuarter,
                              size: 16.0,
                              color: textColor,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              lang.minutes(widget.recipe.duration),
                              style: TextStyle(color: textColor),
                            ),
                            const SizedBox(width: 16.0),
                            Icon(
                              HugeIcons.strokeRoundedUserFullView,
                              size: 16.0,
                              color: textColor,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              lang.person(widget.recipe.servings),
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
