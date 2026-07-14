import 'package:go_router/go_router.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_list_screen.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_list_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_list_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_list_screen.dart';
import 'package:isimcebimde/features/settings/presentation/screens/company_form_screen.dart';
import 'package:isimcebimde/features/settings/presentation/screens/preparer_form_screen.dart';
import 'package:isimcebimde/features/settings/presentation/screens/settings_screen.dart';
import 'package:isimcebimde/features/splash/presentation/screens/splash_screen.dart';

/// Route yolları tek yerde. Ekranlarda düz string yazılmaz.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String dashboard = '/';
  static const String products = '/products';
  static const String customers = '/customers';
  static const String quotes = '/quotes';
  static const String templates = '/quotes/templates';
  static const String settings = '/settings';
  static const String company = '/settings/company';
  static const String preparer = '/settings/preparer';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'products',
          name: 'products',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: 'customers',
          name: 'customers',
          builder: (context, state) => const CustomerListScreen(),
        ),
        GoRoute(
          path: 'quotes',
          name: 'quotes',
          builder: (context, state) => const OfferListScreen(),
          routes: [
            GoRoute(
              path: 'templates',
              name: 'templates',
              builder: (context, state) => const TemplateListScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'company',
              name: 'company',
              builder: (context, state) => const CompanyFormScreen(),
            ),
            GoRoute(
              path: 'preparer',
              name: 'preparer',
              builder: (context, state) => const PreparerFormScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
