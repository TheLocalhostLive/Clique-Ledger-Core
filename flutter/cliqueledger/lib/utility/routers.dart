
import 'package:cliqueledger/pages/dashbord.dart';
import 'package:cliqueledger/pages/login.dart';
import 'package:cliqueledger/pages/signup.dart';
import 'package:cliqueledger/pages/welcome_page.dart';
import 'package:cliqueledger/service/authservice.dart';
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
      
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          name: 'Welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/signup',
          name: 'Signup',
          builder: (context, state) =>  Signup(),
        ),
        GoRoute(
          path: '/login',
          name: 'Login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'Dashboard',
          builder: (context, state) => const Dashbord(),
        ),
      ],
    );
    return router;
  }
}
