import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pet_network/view/explorar.dart';
import 'package:pet_network/view/my_home.dart';

class Home_app extends StatefulWidget {
  const Home_app({super.key});

  @override
  State<Home_app> createState() => _Home_appState();
}

class _Home_appState extends State<Home_app> {

  Widget _buildBottomNavBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
            rippleColor: Colors.grey,
            hoverColor: Colors.grey,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 100),
            haptic: true,
            curve: Curves.easeInOutExpo,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            tabs: [
              GButton(
                icon: LineIcons.home,
                
                text: 'Home',
              ),
               GButton(
                icon: LineIcons.search,
                
                text: 'Explorar',
              ),
              const GButton(
                icon: LineIcons.bell,
                text: 'notificacoes',
              ),
              const GButton(
                icon: LineIcons.user,
                text: 'Perfil',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            }
            ),
      ),
    );
  }
  
  int _selectedIndex = 0;
  static const List<Widget> _screens = <Widget>[
    MyHomePage(),
    Explorar_view(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(),

    );
  }
}