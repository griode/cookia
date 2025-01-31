import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:cookia/data/model/week_menu.dart';
import 'package:cookia/data/provider/week_menu_provider.dart';
import 'package:cookia/data/services/vertex_ai.dart';
import 'package:cookia/utils/router/app_route_name.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalizations.menu),
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
                    onTap: () {
                      context.pushNamed(
                        AppRouteName.menuContent.name,
                        extra: weekMenu.menu[day],
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${DateFormat.EEEE().format(weekMenu!.menu[day]['date'].toDate())} ${weekMenu.menu[day]['date'].toDate().day}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                  ],
                                ),
                                const Icon(HugeIcons.strokeRoundedArrowRight01)
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),
                            FutureBuilder(
                              future: _buildRecipers(weekMenu.menu[day]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Column(
                                    children: snapshot.data!.map((recipe) {
                                      return Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          recipe.image ?? ""),
                                                )),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              recipe.name ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                }
                                return const SizedBox();
                              },
                            )
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
                          color: Theme.of(context).textTheme.bodyLarge!.color!,
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                      ),
                      onPressed: () {
                        VertexAI.createMenu().then((value) {
                          if (value) {
                            _weekMenu =
                                WeekMenuProvider.getMenuUser(_user!.uid);
                            setState(() {});
                          }
                        });
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
    );
  }

  Future<List<Recipe>> _buildRecipers(Map<String, dynamic> menu) async {
    if (menu['recipe_ids'] == null || menu['recipe_ids'].isEmpty) {
      return [];
    }

    var recipeIds = menu['recipe_ids'] as List;
    if (menu['recipe_ids'].length == 1) {
      recipeIds = recipeIds = [recipeIds[0]];
    } else {
      recipeIds = recipeIds = [recipeIds[0], recipeIds[1]];
    }

    List<Recipe> recipers = [];
    for (String id in recipeIds) {
      recipers.add((await RecipeProvider.getById(id))!);
    }
    return recipers;
  }
}
