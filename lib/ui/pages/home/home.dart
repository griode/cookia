import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/provider/message_provider.dart';
import 'package:cookia/data/provider/recipe_provider.dart';
import 'package:cookia/ui/pages/home/components/create_reciper_modal.dart';
import 'package:cookia/ui/pages/home/components/recipe_day_card.dart';
import 'package:cookia/ui/widgets/recipe_card.dart';
import 'package:cookia/ui/widgets/scan_icon.dart';
import 'package:cookia/utils/router/app_route_name.dart';

QueryDocumentSnapshot<Recipe>? recipe;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppLocalizations? lang;

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Row(
              children: [
                Text(
                  "S",
                  style: GoogleFonts.nerkoOne(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "CAN ",
                  style: GoogleFonts.nerkoOne(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "G",
                  style: GoogleFonts.nerkoOne(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset(
                    "assets/icons/logo.svg",
                    // ignore: deprecated_member_use
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  "URMET",
                  style: GoogleFonts.nerkoOne(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRouteName.notifications.name);
            },
            icon: FutureBuilder(
              future: MessageProvider.countUnreadMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data != 0) {
                  return Badge.count(
                    count: snapshot.data ?? 0,
                    child: const Icon(HugeIcons.strokeRoundedNotification01),
                  );
                }
                return const Icon(HugeIcons.strokeRoundedNotification01);
              },
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const RecipeDayCard(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListTile(
                minTileHeight: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                onTap: recipe != null
                    ? () => context.pushNamed(
                          AppRouteName.listRecipeGenerate.name,
                          extra: recipe,
                        )
                    : null,
                title: Text(lang!.recipeGenerateTitle),
                trailing: Text(lang!.showAll),
              ),
            ),
            StreamBuilder<QuerySnapshot<Recipe>>(
              stream: RecipeProvider.limite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return emptyList(context);
                }
                if (snapshot.hasError) {
                  return Center(child: Text(lang!.errorWord));
                }
                if (snapshot.data == null) {
                  return emptyList(context);
                }

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.size > 0) {
                  recipe = snapshot.data!.docs[snapshot.data!.size - 1];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: snapshot.data!.docs
                          .toList()
                          .map(
                            (e) => SizedBox(
                              width: 300,
                              child: RecipeCard(recipe: e.data()),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
                return emptyList(context);
              },
            )
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addRecipe(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const ScanIcon(),
      ),
    );
  }

  void addRecipe(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const CreateRecipe(),
    );
  }

  Widget emptyList(BuildContext context) {
    return Container(
      height: 360.0,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(48.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lang!.fistScanMessage),
        ],
      ),
    );
  }
}