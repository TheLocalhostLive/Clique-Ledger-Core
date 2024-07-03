

import 'package:cliqueledger/pages/dashbord.dart';
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
        if (!isAuth&& state.uri.toString().startsWith('/api/auth/')) {
          return context.namedLocation(RoutersConstants.signUpPageRoute);
        }
        return null;
      },
      refreshListenable: Authservice.instance.loginInfo,
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          name: 'Welcome',
          builder: (context, state) => WelcomePage(),
        ),
        GoRoute(
          path: '/api/auth/signup',
          name: 'Signup',
          builder: (context, state) => Signup(),
        ),
        GoRoute(
          path: '/api/auth/login',
          name: 'Login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/api/auth/dashboard',
          name: 'Dashboard',
          builder: (context, state) => Dashbord(),
        ),
      ],
    );
    return router;
  }
}
