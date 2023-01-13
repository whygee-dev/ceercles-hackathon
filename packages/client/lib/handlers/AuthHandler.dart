import 'package:flutter/material.dart';
import 'package:client/graphql/queries/user.dart';
import 'package:vrouter/vrouter.dart';
import '../entities/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/Auth.dart';

class AuthHandler extends ChangeNotifier {
  static AuthHandler? instance;

  AuthHandler(this.bearer, this.user);

  static getStoredToken() async {
    var prefs = await SharedPreferences.getInstance();

    return prefs.getString('accessToken');
  }

  static getBearerFromStore() async {
    var token = await getStoredToken();

    return "Bearer $token";
  }

  static _fetchUser(String bearer) {
    try {
      return Dio().post(
        dotenv.env['GQL_URL']!,
        data: {"query": whoAmI},
        options: Options(
          headers: {"Authorization": bearer},
        ),
      );
    } catch (err) {
      return null;
    }
  }

  Future<void> refetchUser() async {
    var res = await _fetchUser(bearer);

    var user = User.fromJson(res.data['data']['whoAmI']);

    this.user = user;
    notifyListeners();
  }

  static Future<AuthHandler> getInstance() async {
    if (instance != null) return instance!;

    var bearer = await AuthHandler.getBearerFromStore();

    if (bearer != null) {
      try {
        var res = await _fetchUser(bearer);

        instance =
            AuthHandler(bearer, User.fromJson(res.data['data']['whoAmI']));

        return instance!;
      } catch (error) {}
    }

    instance = AuthHandler(bearer, null);

    return instance!;
  }

  User? user;
  String bearer;
  bool get loggedIn => user != null;
  //bool get loggedIn => true;
  bool get hasProfile => user?.profile != null;
  //bool get hasProfile => true;
  bool get emailVerified => user?.emailVerified == true;
  //bool get emailVerified => true;
  String get getBearer => bearer;
  User? get getUser => user;

  setEmailVerified(bool emailVerified) async {
    user!.setEmailVerified(emailVerified);
    notifyListeners();
    return emailVerified;
  }

  Future<User?> login(String email, String password) async {
    try {
      var res = await Dio().post(
        dotenv.env['API_URL']! + '/login',
        data: {"email": email, 'password': password},
      );

      if (res.data["accessToken"] == null) throw Exception("No token");

      bearer = 'Bearer ' + res.data["accessToken"];
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', res.data["accessToken"]);

      print(bearer);

      var userReq = await AuthHandler._fetchUser(bearer);
      user = User.fromJson(userReq.data["data"]["whoAmI"]);

      notifyListeners();
      print("set bearer");
      print("Bearer " + res.data["accessToken"]);
      return user;
    } catch (error) {
      user = null;
      print("login");
      print(error);
    }

    return user;
  }

  logout(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    user = null;
    bearer = "";
    context.vRouter.to(Auth.route);
  }
}
