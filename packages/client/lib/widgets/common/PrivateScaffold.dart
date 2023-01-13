import 'dart:convert';

import 'package:client/screens/Discover.dart';
import 'package:flutter/material.dart';
import 'package:client/screens/Messenger.dart';
import 'package:client/widgets/common/CAppBar.dart';
import 'package:vrouter/vrouter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/Ceercles.dart';
import '../../screens/Events.dart';
import '../../screens/Profile.dart';
import '../../screens/Shop.dart';

class PrivateScaffold extends StatefulWidget {
  final Widget body;
  final bool useAppbar;
  final Widget? title;
  final bool useBackButton;

  const PrivateScaffold(
      {Key? key,
      required this.body,
      this.useAppbar = false,
      this.title,
      this.useBackButton = false})
      : super(key: key);

  @override
  State<PrivateScaffold> createState() => _PrivateScaffoldState();
}

const ROUTES_COUNT = 6;

class _PrivateScaffoldState extends State<PrivateScaffold> {
  int _selectedIndex = 0;

  @override
  void initState() {
    fetchLastIndex();
    super.initState();
  }

  fetchLastIndex() async {
    var prefs = await SharedPreferences.getInstance();
    var index = prefs.getInt("lastBottomBarIndex") ?? 0;
    _onItemTapped(index);
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt("lastBottomBarIndex", index);

    switch (index) {
      case 0:
        context.vRouter.to(Discover.route);
        break;

      case 1:
        context.vRouter.to(Events.route);
        break;

      case 2:
        context.vRouter.to(Messenger.route);
        break;

      case 3:
        context.vRouter.to(Ceercles.route);
        break;

      case 4:
        context.vRouter.to(Shop.route);
        break;

      case 5:
        context.vRouter.to(Profile.route);
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox.expand(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              int sensitivity = 20;

              // Swiping in right direction.
              if (details.primaryVelocity! > sensitivity) {
                if (_selectedIndex - 1 >= 0) {
                  _onItemTapped(_selectedIndex - 1);
                }
              }

              // Swiping in left direction.
              if (details.primaryVelocity! < sensitivity) {
                if (_selectedIndex + 1 < ROUTES_COUNT) {
                  _onItemTapped(_selectedIndex + 1);
                }
              }
            },
            child: widget.body,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: widget.useAppbar
          ? CAppBar(useBackButton: widget.useBackButton)
          : null,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        enableFeedback: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Discover.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/DiscoverActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Events.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/EventsActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Messenger.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/MessengerActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Ceercles.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/CeerclesActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Shop.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/ShopActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/Profile.png',
              width: 32,
              height: 32,
            ),
            activeIcon: Image.asset(
              'assets/icons/ProfileActive.png',
              width: 32,
              height: 32,
            ),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
