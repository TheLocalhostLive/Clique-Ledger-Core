import 'dart:convert';

import 'package:cliqueledger/models/auth0_id_token.dart';
import 'package:cliqueledger/utility/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  Auth0IdToken? idToken;
  String? accessToken;

  FlutterSecureStorage? secureStorage;

  bool isAuthResultValid(AuthorizationTokenResponse? result) {
    return result != null && result.idToken != null;
  }

  Future<String> _setLocalVariables(AuthorizationTokenResponse? result) async {
    if (isAuthResultValid(result)) {
      accessToken = result!.accessToken!;
      idToken = parseIdToken(result.idToken!);
      

      if (result.refreshToken != null) {
        await secureStorage!.write(
          key: REFRESH_TOKEN_KEY,
          value: result.refreshToken,
        );
      }
      _loginInfo.isLoggedIn = true;
      return 'Success';
    }
    return 'Something is Wrong!';
  }

  login() async {
    final authorizationTokenRequest = AuthorizationTokenRequest(
        AUTH0_CLIENT_ID, AUTH0_REDIRECT_URI,
        issuer: AUTH0_ISSUER,
        scopes: ['openid', 'profile', 'email', 'offline_access']);

    final result =
        await appAuth.authorizeAndExchangeCode(authorizationTokenRequest);

    if (isAuthResultValid(result)) {
      final auth0IdToken = parseIdToken(result!.idToken!);
      print(auth0IdToken);
      _loginInfo._isLoggedIn = true;
    }

    return _setLocalVariables(result);
  }

  Auth0IdToken parseIdToken(String idToken) {
    final parts = idToken.split(r'.');

    final Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]), //body
        ),
      ),
    );

    return Auth0IdToken.fromJson(json);
  }
}
