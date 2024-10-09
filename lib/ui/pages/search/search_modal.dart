import 'package:flutter/material.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({super.key});

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final _history = <String>[];
  late Future<List<Recipe>> listResult;
  late final AppLocalizations? _appLocalizations = AppLocalizations.of(context);
  String query = 'Spaghetti';

  @override
  void initState() {
    super.initState();
    listResult = RecipeProvider.searchByNameOrIngredients('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return _history.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    setState(() {
                      _history.add(selection);
                    });
                  },
                  fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    return Column(children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8.0)),
                        child: TextField(
                          controller: fieldTextEditingController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            onFieldSubmitted();
                          },
                          onChanged: (value) {
                            setState(() {
                              query = value;
                            });
                            listResult =
                                RecipeProvider.searchByNameOrIngredients(query);
                          },
                          focusNode: fieldFocusNode,
                          decoration: InputDecoration(
                            hintText: _appLocalizations!.searchW,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            border: InputBorder.none,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: backButton(context),
                          ),
                        ),
                      ),
                      const Divider(height: 0),
                      const SizedBox(height: 8),
                    ]);
                  },
                  optionsViewBuilder: (
                    BuildContext context,
                    AutocompleteOnSelected<String> onSelected,
                    Iterable<String> options,
                  ) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 32.0, top: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Theme.of(context).canvasColor,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow
                                    .withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);
                              return ListTile(
                                title: Text(option),
                                onTap: () {
                                  onSelected(option);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.zero,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: listResult,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(100.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  if (snapshot.hasData) {
                    var recipes = snapshot.data ?? [];
                    return Column(
                      children: recipes
                          .map((recipe) => RecipeCard(recipe: recipe))
                          .toList(),
                    );
                  }
                  return Center(child: Text(snapshot.error.toString()));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
