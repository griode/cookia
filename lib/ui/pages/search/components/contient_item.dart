import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/utils/router/app_route_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContinentItem extends StatelessWidget {
  final String? recipeImageUrl;
  final String continentName;
  ContinentItem(
      {super.key, this.recipeImageUrl, required this.continentName});

  final random = Random();

  Color getColor(BuildContext context) {
    return Color.fromRGBO(
      random.nextInt(256), // Valeur de rouge
      random.nextInt(256), // Valeur de vert
      random.nextInt(256), // Valeur de bleu
      1.0, // Opacité (1.0 pour une couleur complètement opaque)
    );
  }

  Color contrastingColor(Color color) {
    // Calcul de la luminance
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    // Choix de la couleur de texte en fonction de la luminance
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    late AppLocalizations lang = AppLocalizations.of(context)!;
    var color = getColor(context);
    var colorS = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRouteName.recipeCountryView.name,
        pathParameters: {'continentName': continentName},
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.antiAlias,

        child: Stack(
          children: [
            Container(
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),

                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    recipeImageUrl ?? "",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: colorS.withOpacity(.9),
              ),
            ),
            Container(
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: color.withOpacity(.1),
              ),
            ),
            Positioned(
              right: -16,
              bottom: -12,
              child: Transform.rotate(
                angle: 0.4,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, color: Colors.black12),
                      BoxShadow(blurRadius: 8, color: Colors.black12),
                    ],
                    color: getColor(context),
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        recipeImageUrl ?? "",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lang.continent(continentName),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
