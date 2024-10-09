import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cookia/data/function/upload_file.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/pages/home/components/text_result_generate.dart';

class CreateRecipeWitchText extends StatefulWidget {
  const CreateRecipeWitchText({super.key});

  @override
  State<CreateRecipeWitchText> createState() => _CreateRecipeWitchTextState();
}

class _CreateRecipeWitchTextState extends State<CreateRecipeWitchText> {
  bool disableButton = true;
  final TextEditingController _controller = TextEditingController();
  double textSize = 20;
  late AppLocalizations lang = AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (value) {
                if (value.length > 50 && textSize == 20) {
                  setState(() {
                    textSize -= 2;
                  });
                } else if (value.length > 100 && textSize == 18) {
                  setState(() {
                    textSize -= 2;
                  });
                } else if (value.length < 100 && textSize == 16) {
                  setState(() {
                    textSize += 2;
                  });
                } else if (value.length < 50 && textSize == 18) {
                  setState(() {
                    textSize = 20;
                  });
                }

                if (value.isNotEmpty) {
                  setState(() {
                    disableButton = false;
                  });
                } else {
                  setState(() {
                    disableButton = true;
                  });
                }
              },
              style: TextStyle(
                fontSize: textSize,
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(200),
              ],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(24),
                hintText: lang.typeDescription,
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                errorBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: disableButton ? null : _showResult,
                    icon: const Icon(HugeIcons.strokeRoundedAiBeautify),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showResult() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return TextResultGenerate(text: _controller.text);
      },
    ).then((value) {
      if (value != null) {
        for (var element in value) {
          _saveRecipe(element);
        }
      }
      if (context.mounted) {
        context.pop();
      }
    });
  }

  Future<void> _saveRecipe(Recipe recipe) async {
    recipe.image = await uploadImageFromUrl(recipe.image!, "recipes", "png");
    recipe.createdBy = FirebaseAuth.instance.currentUser!.uid;
    await RecipeProvider().add(recipe);
  }
}
