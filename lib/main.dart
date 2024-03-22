import 'package:flutter/material.dart';
import 'package:my_app/database_helper.dart';
import 'package:my_app/home.dart';
import 'package:my_app/signup.dart';

void main() {
  initializeDatabase();
  runApp(const MyApp());
}

void initializeDatabase() async {
  // Initialize database
  await DatabaseHelper.database;
  //Debug Purpose To Check if The Database iis Open
  print("DATABASE HAS BEEN OPEN");
}

//SessionManagerToCheckLoginOrNot
class SessionManager {
  static bool isLoggedIn = false;
  static String? username;

  static void createSession(String user) {
    isLoggedIn = true;
    username = user;
  }

  static void destroySession() {
    isLoggedIn = false;
    username = null;
  }

  static void logout() {
    destroySession();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  //gettin inputs
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin(BuildContext context) async {
    //Storing inputs in var
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Input validation: Check if username or password is empty
    if (username.isEmpty || password.isEmpty) {
      print('Username or password cannot be empty');
      return;
    }
    //try catch check user exist!
    try {
      bool isValidUser =
          await DatabaseHelper.checkUserCredentials(username, password);
      if (isValidUser) {
        print("LOGIN SUCCESSFUL!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } else {
        print('INVALID USERNAME OR PASSWORD!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Something went wrong. Please try again!: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Something went wrong. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.jpg',
                  width: 200,
                  height: 180,
                ),
                SizedBox(
                  height: 20,
                ), // Adding some space between the image and text
                // LOGIN TEXT ETO
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 40.0,
                        bottom: 50.0), // Adjust left padding as needed
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 33.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // CONTAINER FOR USERNAME
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255, 235, 225, 230), // Same color as ElevatedButton
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Username',
                      hintStyle: TextStyle(
                          color: Colors.grey[
                              600]), // Adjusted hint text color for better visibility
                      border: InputBorder.none, // Removed border
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // CONTAINER FOR PASSWORD
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255, 235, 225, 230), // Same color as ElevatedButton
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(
                          color: Colors.grey[
                              600]), // Adjusted hint text color for better visibility
                      border: InputBorder.none, // Removed border
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // LOGIN BUTTON SA BABA
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: ElevatedButton(
                    onPressed: () {
                      handleLogin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 80.0, right: 80.0),
                      backgroundColor: Color.fromARGB(255, 235, 225,
                          230), // Same color as TextField containers
                    ),
                    // Adjust padding around the child (Text)
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ),
                // Forget password sa baba
                // Signup button
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  padding: EdgeInsets.only(top: 120.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation:
                          0, // Set elevation to 0 to remove the button's shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Optional: You can set borderRadius for rounded corners
                      ),
                    ),
                    child: Text(
                      'Don\'t have an account? Click here to sign up',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
