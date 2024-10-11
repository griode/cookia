import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/model/week_menu.dart';
import 'package:cookia/data/provider/week_menu_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/ui/widgets/back_button.dart';

class AddToMenu extends StatefulWidget {
  final Recipe recipe;
  const AddToMenu({super.key, required this.recipe});

  @override
  State<AddToMenu> createState() => _AddToMenuState();
}

class _AddToMenuState extends State<AddToMenu> {
  late AppLocalizations _appLocalizations;
  final _user = FirebaseAuth.instance.currentUser;
  late Future<WeekMenu?> _weekMenu;

  final _days = [
    "day1",
    "day2",
    "day3",
    "day4",
    "day5",
    "day6",
    "day7",
  ];

  @override
  void initState() {
    super.initState();
    _weekMenu = WeekMenuProvider.getMenuUser(_user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            _appLocalizations.chooseMenuTitle,
            maxLines: 2,
          ),
          leading: backButton(context),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _weekMenu,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height / 1.5,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                // menuData
                var weekMenu = snapshot.data;
                return Column(
                  children: _days.map((day) {
                    return GestureDetector(
                      onTap: () async {
                        var menu = weekMenu.menu[day];
                        var result = false;
                        if (menu["recipe_ids"].contains(widget.recipe.id) ==
                            false) {
                          menu["recipe_ids"].add(widget.recipe.id);
                          weekMenu.menu[day] = menu;
                          result = await WeekMenuProvider.updateMenuToRecipe(
                              weekMenu.menu);
                        }
                        context.pop(result);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.EEEE().format(
                                        weekMenu!.menu[day]['date'].toDate()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    DateFormat.MMMd().format(
                                        weekMenu.menu[day]['date'].toDate()),
                                  ),
                                ],
                              ),
                              const Icon(HugeIcons.strokeRoundedArrowRight01)
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(_appLocalizations.errorMenu),
                      const SizedBox(height: 16.0),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 0.0,
                          ),
                          side: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!,
                            width: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {});
                          VertexAI.createMenu().then(
                            (value) {
                              setState(() {});
                            },
                          );
                        },
                        icon: const Icon(
                          HugeIcons.strokeRoundedRefresh,
                          size: 16.0,
                        ),
                        label: Text(_appLocalizations.createMenuText),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
