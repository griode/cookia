import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/ui/pages/recipe/add_to_menu.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late AppLocalizations lang = AppLocalizations.of(context)!;
  int _currentPage = 0;
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    _i = 0;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Hero(
              tag: widget.recipe.name!,
              child: Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.recipe.image ?? "",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(HugeIcons.strokeRoundedCancel01),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    widget.recipe.id == null
                        ? Container()
                        : IconButton(
                            onPressed: _showMore,
                            icon: const Icon(
                                HugeIcons.strokeRoundedMoreVerticalCircle01),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.72,
              minChildSize: 0.7,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return SafeArea(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  widget.recipe.name ?? "",
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          HugeIcons.strokeRoundedTimeQuarter,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          lang.minutes(
                                              widget.recipe.duration),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16.0),
                                    Row(
                                      children: [
                                        Icon(
                                          HugeIcons.strokeRoundedUserFullView,
                                          size: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          lang.person(widget.recipe.servings),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  lang.cuisine(widget.recipe.cuisine),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(widget.recipe.description ?? ""),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 100,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 4,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      _nutrition(
                                        HugeIcons.strokeRoundedNaturalFood,
                                        "${widget.recipe.nutritionFacts["carbohydrates"]} ${lang.carbohydrates}",
                                      ),
                                      _nutrition(
                                        HugeIcons.strokeRoundedSteak,
                                        "${widget.recipe.nutritionFacts["protein"]} ${lang.protein}",
                                      ),
                                      _nutrition(
                                        HugeIcons.strokeRoundedFire,
                                        "${widget.recipe.nutritionFacts["calories"]} ${lang.calories}",
                                      ),
                                      _nutrition(
                                        HugeIcons.strokeRoundedCheese,
                                        "${widget.recipe.nutritionFacts["fat"]} ${lang.fat}",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TabBar(
                                    padding: const EdgeInsets.all(4),
                                    onTap: (value) {
                                      setState(() {
                                        _currentPage = value;
                                      });
                                    },
                                    labelStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                    dividerColor: Colors.transparent,
                                    labelColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: [
                                      Tab(child: Text(lang.ingredients)),
                                      Tab(child: Text(lang.instructions)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // page index
                                _currentPage == 0
                                    ? _buildIngredient()
                                    : _buildInstruction()
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            controller: scrollController,
                            child: Container(

                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Center(
                                    child: Container(
                                      height: 4,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withOpacity(0.8),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.recipe.instructions.map((e) => _buildDirectionItem(e))
      ],
    );
  }

  Widget _buildIngredient() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.recipe.ingredients.map((e) => _buildIngredientItem(e))
      ],
    );
  }

  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(HugeIcons.strokeRoundedCircle, size: 16.0),
              const SizedBox(width: 8.0),
              Expanded(child: Text(text)),
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  Widget _buildDirectionItem(String text) {
    _i += 1;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Text(
              '$_i',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _nutrition(IconData icon, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(icon),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  _showMore() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              ListTile(
                onTap: addTMenu,
                title: Text(lang.addToMenu),
                leading: const Icon(HugeIcons.strokeRoundedAdd01),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }

  addTMenu() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AddToMenu(recipe: widget.recipe);
      },
    ).then((value) {
      if (value == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.recipeAddToMenu),
          ),
        );
      }
      context.pop();
    });
  }
}
