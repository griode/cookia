import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cookia/data/model/recipe.dart';
import 'package:cookia/data/model/user_model.dart';
import 'package:cookia/data/provider/user_provider.dart';
import 'package:cookia/data/services/firebase_notification.dart';
import 'package:cookia/ui/pages/home/home.dart';
import 'package:cookia/ui/pages/recipe/list_recipe_generate.dart';
import 'package:cookia/ui/pages/home/custom_navigation_bar.dart';
import 'package:cookia/ui/pages/login/login.dart';
import 'package:cookia/ui/pages/menu/menu.dart';
import 'package:cookia/ui/pages/notification/notification.dart';
import 'package:cookia/ui/pages/menu/menu_content.dart';
import 'package:cookia/ui/pages/recipe/reciper_detail.dart';
import 'package:cookia/ui/pages/register/alergy.dart';
import 'package:cookia/ui/pages/register/register.dart';
import 'package:cookia/ui/pages/search/meal_view.dart';
import 'package:cookia/ui/pages/search/recipe_country_view.dart';
import 'package:cookia/ui/pages/search/search.dart';
import 'package:cookia/ui/pages/search/search_modal.dart';
import 'package:cookia/ui/pages/settings/about_app_page.dart';
import 'package:cookia/ui/pages/settings/contact.dart';
import 'package:cookia/ui/pages/settings/profile.dart';
import 'package:cookia/ui/pages/settings/setting.dart';
import 'package:cookia/ui/pages/settings/terms_privacy_page.dart';
import 'package:cookia/utils/router/app_route_name.dart';

UserAuth? currentUserAuth;

GoRouter routerConfig = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (currentUserAuth == null) {
        currentUserAuth = await UserProvider.get();
        await FirebaseNotification.init();
      }
      if (currentUserAuth != null) {
        return state.path;
      } else {
        return '/register';
      }
    }
    return '/login';
  },
  routes: [
    // Pages witch navigation bar
    _shellRoute,
    // Pages nobody navigation bar
    GoRoute(
      path: '/login',
      name: AppRouteName.login.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const LoginPage()),
    ),
    GoRoute(
      path: '/recipeCountryView/:continentName',
      name: AppRouteName.recipeCountryView.name,
      pageBuilder: (context, state) => slideTransitionPage(
        state,
        RecipeCountryView(
          continentName: state.pathParameters['continentName'] ?? '',
        ),
      ),
    ),
    GoRoute(
      path: '/mealView/:mealType',
      name: AppRouteName.mealView.name,
      pageBuilder: (context, state) => slideTransitionPage(
          state, MealView(mealType: state.pathParameters['mealType'] ?? '')),
    ),
    GoRoute(
      path: '/searchModal',
      name: AppRouteName.searchModal.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const SearchModal()),
    ),
    GoRoute(
      path: '/privacyCondition',
      name: AppRouteName.privacyConditions.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const TermsPrivacyPage()),
    ),
    GoRoute(
      path: '/contact',
      name: AppRouteName.contact.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const ContactPage()),
    ),
    GoRoute(
      path: '/register',
      name: AppRouteName.register.name,
      pageBuilder: (context, state) => slideTransitionPage(
        state,
        const RegisterPage(),
      ),
    ),
    GoRoute(
      path: '/allergy',
      name: AppRouteName.alergie.name,
      pageBuilder: (context, state) => slideTransitionPage(
        state,
        AllergyPage(user: state.extra as UserAuth),
      ),
    ),
    GoRoute(
      path: '/detail_recipe',
      name: AppRouteName.detailRecipe.name,
      pageBuilder: (context, state) => slideTransitionPage(
          state, RecipeDetailPage(recipe: state.extra as Recipe)),
    ),
    GoRoute(
      path: '/profile',
      name: AppRouteName.profile.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const ProfilePage()),
    ),
    GoRoute(
      path: '/notifications',
      name: AppRouteName.notifications.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const NotificationPage()),
    ),
    GoRoute(
      path: '/list_recipe_generate',
      name: AppRouteName.listRecipeGenerate.name,
      pageBuilder: (context, state) => slideTransitionPage(
        state,
        const ListRecipeGenerate(),
      ),
    ),
    GoRoute(
      path: '/about',
      name: AppRouteName.about.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const AboutAppPage()),
    ),
  ],
);

// Navigation route page
ShellRoute _shellRoute = ShellRoute(
  builder: (context, state, child) => CustomNavigationBar(child: child),
  routes: [
    GoRoute(
      path: '/',
      name: AppRouteName.home.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const HomePage()),
    ),
    GoRoute(
      path: '/menu',
      name: AppRouteName.menu.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const MenuPage()),
    ),
    GoRoute(
      path: '/setting',
      name: AppRouteName.setting.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const SettingPage()),
    ),
    GoRoute(
      path: '/book',
      name: AppRouteName.book.name,
      pageBuilder: (context, state) =>
          slideTransitionPage(state, const GalleryPage()),
    ),
    GoRoute(
      path: '/menuContent',
      name: AppRouteName.menuContent.name,
      pageBuilder: (context, state) => slideTransitionPage(
        state,
        MenuContent(menu: state.extra as Map<String, dynamic>),
      ),
    ),
  ],
);

Page<dynamic> slideTransitionPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 0),
    reverseTransitionDuration: const Duration(milliseconds: 0),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
