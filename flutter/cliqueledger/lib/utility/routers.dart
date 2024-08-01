
import 'package:cliqueledger/pages/CliqueSettingsPage.dart';
import 'package:cliqueledger/pages/addMember.dart';
import 'package:cliqueledger/pages/dashboard.dart';
import 'package:cliqueledger/pages/cliquePage.dart';
import 'package:cliqueledger/pages/login.dart';
import 'package:cliqueledger/pages/signup.dart';
import 'package:cliqueledger/pages/welcome_page.dart';
import 'package:cliqueledger/service/authservice.dart';
import 'package:cliqueledger/utility/routers_constant.dart';
import 'package:go_router/go_router.dart';

class Routers {
  static GoRouter routers(bool isAuth) {
    final GoRouter router = GoRouter(
      redirect: (context, state) {
        final loggedIn = Authservice.instance.loginInfo.isLoggedIn;
        final isLogging = state.uri.toString() == '/signup';
        final isOnWelcome = state.uri.toString() == '/';

        if(!loggedIn && !isLogging && !isOnWelcome) return '/signup';

        if(loggedIn && isLogging) return '/dashboard';
        return null;
      },
      refreshListenable: Authservice.instance.loginInfo,
      debugLogDiagnostics: false,
      initialLocation: Authservice.instance.loginInfo.isLoggedIn ? '/dashboard' : '/',
      routes: <GoRoute>[
        GoRoute(
          path: RoutersConstants.WELCOME_ROUTE,
          name: 'Welcome',
          builder: (context, state) => WelcomePage(),
        ),
        GoRoute(
          path: RoutersConstants.SIGNUP_PAGE_ROUTE,
          name: 'Signup',
          builder: (context, state) =>  Signup(),
        ),
        GoRoute(
          path: RoutersConstants.LOGIN_ROUTE,
          name: 'Login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutersConstants.DASHBOARD,
          name: 'Dashboard',
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: RoutersConstants.CLIQUE_ROUTE,
          name: 'clique',
          builder: (context,state)=> Cliquepage()
        ),
        GoRoute(
          path: RoutersConstants.CLIQUE_SETTINGS_ROUTE,
          name: 'cliqueSettings',
          builder: (context,state)=> SettingsPage()
        ),
        GoRoute(
          path: RoutersConstants.ADD_MEMBER_ROUTE,
          name: 'AddMember',
          builder: (context,state)=> AddMember()
        ),
        
      ],
    );
    return router;
  }
}
