import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/utils/router/app_route_name.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

class MealItem extends StatelessWidget {
  final String mealType;
  final String? imageUrl;
  MealItem({super.key, required this.mealType, this.imageUrl});

  final random = Random();

  Color getColor(BuildContext context) {
    return Color.fromRGBO(
      random.nextInt(256), // Valeur de rouge
      random.nextInt(256), // Valeur de vert
      random.nextInt(256), // Valeur de bleu
      1.0, // Opacité (1.0 pour une couleur complètement opaque)
    );
  }

  @override
  Widget build(BuildContext context) {
    late AppLocalizations lang = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRouteName.mealView.name,
        pathParameters: {'mealType': mealType},
      ),
      child: Stack(
        children: [
          Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              color: getColor(context).withOpacity(.2),
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 150,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter, // Point de départ (haut)
                end: Alignment.bottomCenter, // Point d'arrivée (bas)
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0),
                  Colors.black87,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Text(
              lang.mealtype(mealType),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
