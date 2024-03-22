import 'package:flutter/material.dart';
import 'package:my_app/main.dart';

void main() {
  runApp(const MyApp());
}

void logout(BuildContext context) {
  SessionManager.destroySession();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => MyLoginPage()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.notifications),
    Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false, // Center the title (in this case, the image)
        leadingWidth: MediaQuery.of(context).size.width /
            0, // Set the width of the leading widget area
        leading: Image.asset(
          'assets/images/Logo.jpg',
          width: 90.0,
          height: 90.0,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: <Widget>[
                      TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            print('do nothing');
                          }),
                      TextButton(
                        child: Text("Logout"),
                        onPressed: () {
                          logout(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Change the selected item color
        unselectedItemColor: Colors.grey, // Change the unselected item color
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Notification',
            icon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
