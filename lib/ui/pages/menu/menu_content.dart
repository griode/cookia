import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/week_menu_provider.dart';
import 'package:cookia/ui/widgets/larg_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';

class MenuContent extends StatefulWidget {
  final Map<String, dynamic> menu;
  const MenuContent({super.key, required this.menu});

  @override
  State<MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<MenuContent> {
  List recipes = [];
  late Map<String, dynamic> menu;
  int currentPage = 0;
  List<String> tabLabel = ["Dinner", "Breakfast", "Meal", "Dessert", "Snack"];

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    recipes = menu['recipe_ids'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLabel.length,
      child: Scaffold(
        appBar: AppBar(
          leading: backButton(context),
          title: Text(
            "${DateFormat.EEEE().format(menu['date'].toDate())} ${menu['date'].toDate().day}",
          ),
          bottom: TabBar(
            onTap: (value) {
              setState(() {
                currentPage = value;
              });
            },
            isScrollable: true, // Rend le TabBar scrollable
            labelPadding: const EdgeInsets.only(right: 4, left: 8),

            tabAlignment: TabAlignment.start,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).scaffoldBackgroundColor,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.primary,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabLabel
                .map(
                  (e) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: (tabLabel[currentPage] == e)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).textTheme.bodyLarge!.color!,
                          width: 0.4,
                        )),
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (int i = 0; i < tabLabel.length; i++)
              buildRecipeList(), // Affiche la liste des recettes pour chaque Tab
          ],
        ),
      ),
    );
  }

  // Widget pour la liste des recettes
  Widget buildRecipeList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        children: recipes.map((e) {
          return FutureBuilder(
            future: RecipeProvider.getById(e),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                Recipe recipe = snapshot.data!;

                if (recipe.mealType != tabLabel[currentPage].toLowerCase()) {
                  return const SizedBox();
                }

                return Stack(
                  children: [
                    LargeRecipeCard(recipe: recipe),
                    Positioned(
                      right: 20,
                      top: 8,
                      child: FilledButton(
                        onPressed: () {
                          if (menu["recipe_ids"].contains(recipe.id) == true) {
                            menu["recipe_ids"].add(recipe.id);

                            WeekMenuProvider.updateMenuToRecipe(menu)
                                .then((value) {
                              setState(() {});
                            });
                          }
                        },
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text("Remove"),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox();
            },
          );
        }).toList(),
      ),
    );
  }
}
