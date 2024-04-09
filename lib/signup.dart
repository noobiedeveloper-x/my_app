import 'package:flutter/material.dart';
import 'package:my_app/database_helper.dart';
import 'package:my_app/main.dart';

void main() {
  runApp(const MyApp());
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

//Get inputed
class _SignupState extends State<Signup> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _obscureText = true;
  String _selectedGender = '';

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void insertData(BuildContext context) async {
    // Store inputed in a var
    String name = _nameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String address = _addressController.text;
    String dateOfBirth = _selectedDate?.toString() ?? '';

    try {
      // Check if the username already exists
      bool usernameExists = await DatabaseHelper.checkUsernameExists(username);
      if (usernameExists) {
        // Show an alert indicating that the username already exists
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Username already exists. Please choose a different username.'),
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
      } else {
        // Function that inserts user
        await DatabaseHelper.insertUser(
          name,
          username,
          password,
          email,
          phone,
          address,
          dateOfBirth,
          _selectedGender,
        );
        print('Insertion successful'); // Print success message Debug purpose

        // Show SnackBar indicating successful sign-up
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error inserting data: $e');
      // Print exception(E)

      // Show AlertDialog for other errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to sign up. Please try again later.'),
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
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  //validate input if its not equals then 6
  String _validateInput(String value) {
    if (value.length != 6) {
      return 'Input must be exactly 6 characters long.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo.jpg',
                  width: 150,
                  height: 130,
                ),
                SizedBox(
                  height: 20,
                ), // Adding some space between the image and text

                // CONTAINER FOR NAME
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 225, 230),
                    borderRadius: BorderRadius.circular(20.0),
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
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // CONTAINER FOR USERNAME
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 225, 230),
                    borderRadius: BorderRadius.circular(20.0),
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
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: TextField(
                    controller: _usernameController,
                    maxLength: 6, // Maximum input length set to 6
                    validator: _validateInput,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16.0, // Reduced font size
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
                  padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 12.0), // Slightly reduced padding
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0), // Slightly reduced margin
                  child: TextField(
                    controller: _passwordController,
                    maxLength: 6, // Maximum input length set to 6
                    validator: _validateInput,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey[
                            600], // Adjusted hint text color for better visibility
                      ),
                      border: InputBorder.none,
                      counterText: '', // Hides the counter text
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

                // CONTAINER FOR EMAIL ADDRESS
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
                  padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 12.0), // Slightly reduced padding
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0), // Slightly reduced margin
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
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

                // CONTAINER FOR PHONE
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
                  padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 12.0), // Slightly reduced padding
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0), // Slightly reduced margin
                  child: TextField(
                    controller: _phoneController,
                    maxLength: 11, // Maximum input length set to 11
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                          color: Colors.grey[
                              600]), // Adjusted hint text color for better visibility
                      border: InputBorder.none, // Removed border
                      counterText: '', // Hides the counter text
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // CONTAINER FOR ADDRESS
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
                  padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 12.0), // Slightly reduced padding
                  margin: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0), // Slightly reduced marginz1
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
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

                // CONTAINER FOR DATE OF BIRTH
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
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: _selectedDate == null
                              ? 'Date of Birth'
                              : 'Date of Birth: ${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),

                // CONTAINER FOR GENDER
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
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedGender = 'Male';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: _selectedGender == 'Male'
                              ? Colors.blue
                              : Colors.grey[300],
                          disabledBackgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        icon: Icon(Icons.male,
                            color: _selectedGender == 'Male'
                                ? Colors.blue
                                : Colors.black87),
                        label: Text(
                          'Male',
                          style: TextStyle(
                            color: _selectedGender == 'Male'
                                ? Colors.blue
                                : Colors.black87,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedGender = 'Female';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: _selectedGender == 'Female'
                              ? Colors.blue
                              : Colors.grey[300],
                          disabledBackgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        icon: Icon(Icons.female,
                            color: _selectedGender == 'Female'
                                ? Colors.blue
                                : Colors.black87),
                        label: Text(
                          'Female',
                          style: TextStyle(
                            color: _selectedGender == 'Female'
                                ? Colors.blue
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // LOGIN BUTTON SA BABA
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  padding: EdgeInsets.only(top: 70.0),
                  child: ElevatedButton(
                    onPressed: () => insertData(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 80.0, right: 80.0),
                      backgroundColor: Color.fromARGB(255, 235, 225,
                          230), // Same color as TextField containers
                    ),
                    // Adjust padding around the child (Text)
                    child: Text(
                      'Signup',
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
