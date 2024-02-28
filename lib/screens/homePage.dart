import 'dart:convert';
import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var _activeScreen = 'login-screen';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void _login(String res) {
    Map<String, dynamic> data = json.decode(res);
    String token = data['token'];
    setToken(token);
    getToken();
  }

  void _logout() {
    deleteToken();
    getToken();
  }

  void setToken(token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
    prefs.setString("token", token);
  }

  void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    prefs.setString("token", '');
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var token = prefs.getString('token') ?? '';
    print('user logged in: $status with token: $token');
    setState(() {
      status ? _activeScreen = 'chat-screen' : _activeScreen = 'login-screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = LoginScreen(submit: _login);

    if (_activeScreen == 'chat-screen') {
      currentWidget = ChatScreen(logout: _logout);
    }

    return currentWidget;
  }
}
