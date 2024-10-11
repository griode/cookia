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

  @override
  void initState() {
    super.initState();
    menu = widget.menu;
    recipes = menu['recipe_ids'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: backButton(context),
          title: Text(
            "${DateFormat.EEEE().format(menu['date'].toDate())} ${menu['date'].toDate().day}",
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                padding: const EdgeInsets.all(4),
                onTap: (value) {
                  setState(() {});
                },
                labelStyle: Theme.of(context).textTheme.titleMedium,
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).scaffoldBackgroundColor,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(child: Text("Dinner")),
                  Tab(
                    child: Text("Breafast"),
                  ),
                  Tab(
                    child: Text("Meal"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: recipes.map((e) {
              return FutureBuilder(
                future: RecipeProvider.getById(e),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return LargRecipeCard(recipe: snapshot.data!);
                  }
                  return const SizedBox();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
