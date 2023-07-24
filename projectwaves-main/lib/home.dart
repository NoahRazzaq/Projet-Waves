import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_waves/src/Auth/Components/button.dart';
import 'package:project_waves/src/Auth/Components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_waves/src/Auth/Views/login_page.dart';
import 'package:project_waves/src/Auth/Views/logout_page.dart';
import 'package:project_waves/src/Auth/Views/user_profile_page.dart';
import 'package:project_waves/src/Event/View/EventForm.dart';
import 'package:project_waves/src/Event/View/EventList.dart';
import 'package:project_waves/src/Search/View/search_page.dart';
import 'package:project_waves/src/Swipe/View/SwipeView.dart';


GlobalKey bottomBarKey = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String id = 'home';
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    SwipeView(),
    SearchPage(),
    EventList(),
    UserProfileView()

  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            key: bottomBarKey,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 35),
                  activeIcon: Icon(Icons.home, size: 35),
                  label: 'Home'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined, size: 35),
                  activeIcon: Icon(Icons.explore, size: 35),
                  label: 'Search'
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event_available_outlined, size: 35),
                  activeIcon: Icon(Icons.event_available, size: 35),
                  label: "Events"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box_outlined, size: 35),
                  activeIcon: Icon(Icons.account_box, size: 35),
                  label: 'Account'
              ),
            ],
            unselectedLabelStyle: const TextStyle(color: Colors.red, fontSize: 14),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black54,
            onTap: _onItemTapped,

            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );

  }

}
