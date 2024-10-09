import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/data/static/country_list.dart';
import 'package:cookia/data/static/meal_list.dart';
import 'package:cookia/ui/pages/search/components/meal_item.dart';
import 'package:cookia/ui/pages/search/components/contient_item.dart';
import 'package:cookia/ui/widgets/grid_adaptive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late AppLocalizations lang = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Colors.transparent,
                elevation: 0.0,
                title: Text(lang.toResearch),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () =>
                          context.pushNamed(AppRouteName.searchModal.name),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                        ),
                        child: Row(
                          children: [
                            const Icon(HugeIcons.strokeRoundedSearch01),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                lang.researchQuestion,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    lang.mealCategory,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    const SizedBox(width: 12),
                    ...mealList
                        .map((meal) => Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: MealItem(
                                mealType: meal["name"] ?? "",
                                imageUrl: meal["imageUrl"],
                              ),
                            ))
                        ,
                  ]),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    lang.browseAll,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                GridAdaptive(
                  spacing: 12,
                  children: countryList.map((country) {
                    return ContinentItem(
                      continentName: country['name'] ?? "",
                      recipeImageUrl: country['imageUrl'],
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
