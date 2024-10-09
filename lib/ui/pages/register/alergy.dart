import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/ui/widgets/back_button.dart';

import '../../../utils/router/router_config.dart';

class AllergyPage extends StatefulWidget {
  final UserAuth user;

  const AllergyPage({super.key, required this.user});

  @override
  State<AllergyPage> createState() => _AllergyPageState();
}

class _AllergyPageState extends State<AllergyPage> {
  final List _listAllergy = [];
  final _allergyTextController = TextEditingController();
  final _dietController = TextEditingController();
  bool initData = true;
  bool showLoading = false;

  @override
  void initState() {
    if (initData) {
      _listAllergy.addAll(widget.user.allergens);
      _dietController.text = widget.user.diet;
      initData = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    _allergyTextController.dispose();
    _dietController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allergens),
        leading: backButton(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.selectDiet),
            TextField(
              readOnly: true,
              controller: _dietController,
              onTap: () => _selectDiet(),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.diet,
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(AppLocalizations.of(context)!.allergens),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return AppLocalizations.of(context)!
                    .allergenProductExample
                    .split(', ')
                    .where(
                      (element) => element.contains(textEditingValue.text),
                    );
              },
              onSelected: (String selection) {
                setState(() {
                  _allergyTextController.text = selection;
                });
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onChanged: (value) {
                    setState(() {
                      _allergyTextController.text = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.allergens,
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_allergyTextController.text.isNotEmpty) {
                          setState(() {
                            _listAllergy.add(_allergyTextController.text);
                            _allergyTextController.clear();
                            fieldTextEditingController.clear();
                          });
                        }
                      },
                      icon: const Icon(CupertinoIcons.add),
                    ),
                  ),
                  onSubmitted: (String value) {},
                );
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
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _listAllergy.map((e) {
                return Chip(
                  label: Text(e),
                  onDeleted: () => setState(() => _listAllergy.remove(e)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: _register,
          label: showLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).scaffoldBackgroundColor)
              : Text(AppLocalizations.of(context)!.save),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _selectDiet() {
    final listDiet = ["vegan", "vegetarian", "other"];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  AppLocalizations.of(context)!.diet,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...listDiet.map((e) {
                return RadioListTile(
                  value: e,
                  title: Text(AppLocalizations.of(context)!.dietList(e)),
                  groupValue: _dietController.text,
                  onChanged: (value) {
                    setState(() {
                      _dietController.text = value!;
                      context.pop();
                    });
                  },
                );
              }),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    setState(() {
      showLoading = true;
    });
    var response = await UserProvider.update(
        {"allergens": _listAllergy, "diet": _dietController.text});
    if (response) {
      currentUserAuth?.allergens = _listAllergy;
      currentUserAuth?.diet = _dietController.text;
      setState(() {
        showLoading = false;
      });
      context.pop();
    }
  }
}
