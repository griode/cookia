import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(
          DateFormat.EEEE().format(menu['date'].toDate()),
        ),
        actions: [
          Text(
            DateFormat.Md().format(menu['date'].toDate()),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: recipes.map((e) {
            return FutureBuilder(
              future: RecipeProvider.getById(e),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return RecipeCard(recipe: snapshot.data!);
                }
                return const SizedBox();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
