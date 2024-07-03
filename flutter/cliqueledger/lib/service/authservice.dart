
import 'package:cliqueledger/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class _LoginInfo extends ChangeNotifier {
  var _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}

@immutable
class Authservice {
  static final Authservice instance = Authservice._internal();
  factory Authservice() {
    return instance;
  }

  Authservice._internal();

  final _loginInfo = _LoginInfo();
  get loginInfo => _loginInfo;

  final appAuth = FlutterAppAuth();

  login() async {
    final authorizationTokenRequest = AuthorizationTokenRequest(
        AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        scopes: ['openid', 'profile', 'email', 'offline_access']);

    final result =
        await appAuth.authorizeAndExchangeCode(authorizationTokenRequest);
    _loginInfo._isLoggedIn = true;
  }
}
