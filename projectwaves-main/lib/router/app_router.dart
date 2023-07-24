import 'package:go_router/go_router.dart';
import 'package:project_waves/router/route_utils.dart';
import 'package:project_waves/src/Auth/Views/login_page.dart';

import '../home.dart';
import '../services/app_services.dart';
import '../src/Auth/Views/error_page.dart';

class AppRouter {
  late final AppService appService;

  GoRouter get router => _goRouter;

  AppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    initialLocation: APP_PAGE.login.toPath,
    routes: <GoRoute>[
      GoRoute(
        path: APP_PAGE.home.toPath,
        name: APP_PAGE.home.toName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: APP_PAGE.login.toPath,
        name: APP_PAGE.login.toName,
        builder: (context, state) => const LoginPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(),
    redirect: (context, state) {
      final loginLocation = APP_PAGE.login.toPath;
      final homeLocation = APP_PAGE.home.toPath;

      final isLogedIn = appService.loginState;

      final isGoingToLogin = state.subloc == loginLocation;
      final isGoingToInit = state.subloc == loginLocation;

      print('isLogedIn $isLogedIn');
      print('isGoingToLogin $isGoingToLogin');

      // If not Initialized and not going to Initialized redirect to Splash
       if (!isLogedIn && !isGoingToLogin) {
         print('hey');
        return loginLocation;
        // If all the scenarios are cleared but still going to any of that screen redirect to Home
      } else if ((isLogedIn && isGoingToLogin)) {
        print('connect');
        return homeLocation;
      } else {
         print('not worked');
        // Else Don't do anything
        return null;
      }
    },
  );
}