
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
        final isLogging = state.uri.toString() == '/api/auth/signup';

        if(!loggedIn && !isLogging) return '/api/auth/signup';

        if(loggedIn && isLogging) return '/api/auth/dashboard';
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
          path: '/api/auth/signup',
          name: 'Signup',
          builder: (context, state) => const Signup(),
        ),
        GoRoute(
          path: '/api/auth/login',
          name: 'Login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/api/auth/dashboard',
          name: 'Dashboard',
          builder: (context, state) => const Dashbord(),
        ),
      ],
    );
    return router;
  }
}
