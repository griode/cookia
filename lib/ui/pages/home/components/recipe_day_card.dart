import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/model/recipe_day.dart';
import 'package:cookia/data/provider/recipe_day_provider.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/utils/router/app_route_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeDayCard extends StatefulWidget {
  const RecipeDayCard({super.key});

  @override
  State<RecipeDayCard> createState() => _RecipeDayCardState();
}

class _RecipeDayCardState extends State<RecipeDayCard> {
  late Stream<DocumentSnapshot<RecipeDay>>? recipeDayStream;
  late AppLocalizations? lang = AppLocalizations.of(context);
  // Color
  late Color colorBack = Theme.of(context).colorScheme.primary.withOpacity(0.1);

  @override
  void initState() {
    super.initState();
    recipeDayStream = RecipeDayProvider.getRecipesDay();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recipeDayStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingCard();
        }

        if (snapshot.hasData && snapshot.data != null) {
          var recipeDay = snapshot.data!.data();

          if (recipeDay == null) {
            return loadingCard();
          }

          return FutureBuilder(
            future: RecipeProvider.getById(recipeDay.recipeId ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                var recipe = snapshot.data;
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRouteName.detailRecipe.name,
                    extra: recipe,
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe!.name ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    recipe.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    lang!.learnMore,
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                      bottomLeft: Radius.circular(100),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    border: Border(
                                      left: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: colorBack,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(100),
                                      bottomLeft: Radius.circular(100),
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        recipe.image ?? "",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return loadingCard();
            },
          );
        }
        return loadingCard();
      },
    );
  }

  Widget loadingCard() {
    var colorBack = Theme.of(context).colorScheme.primary.withOpacity(0.2);
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// Suggested code may be subject to a license. Learn more: ~LicenseLog:651350065.
                  Container(
                    width: double.infinity,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorBack,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorBack,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colorBack,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  height: 200,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomLeft: Radius.circular(100),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
