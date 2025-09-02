import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pet_network/view/explorar.dart';
import 'package:pet_network/view/my_home.dart';
import 'package:pet_network/view/notificacoes.dart';
import 'package:pet_network/view/perfil.dart';


// ignore: camel_case_types
class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

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
              // Exemplo de como ficaria na sua lista de GButton
              
              
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
    ExplorePage(),
    NotificationsPage(),
    ProfilePage(),
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(),

    );
  }
}