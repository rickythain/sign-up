import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var userUsername;
var userEmail;
var userPassword;
var userGender;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: new ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SignUpPage(),
    );
  }
}

// Sign up page
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String> genders = ['male', 'female', 'other', 'rather not say'];
  String? _gender;

  // text input controllers
  final textControllerName = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerPassword = TextEditingController();

  // for sign up button
  bool isDisbled = true;
  // for sign in button
  bool isSignInDisabled = true;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textControllerName.addListener(isFilled);
    textControllerEmail.addListener(isFilled);
    textControllerPassword.addListener(isFilled);

    loadUserData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textControllerName.dispose();
    textControllerEmail.dispose();
    textControllerPassword.dispose();
    super.dispose();
  }

  // enable or disable sign up button
  void isFilled() {
    setState(() {
      if (textControllerName.text != "" &&
          textControllerEmail.text != "" &&
          textControllerPassword.text != "" &&
          _gender != null) {
        isDisbled = false;
      } else {
        isDisbled = true;
      }
    });
  }

  // initialize variables when signing up
  void signUp() {
    userUsername = textControllerName.text;
    userEmail = textControllerEmail.text;
    userGender = _gender;
    userPassword = textControllerPassword.text;

    // call function to write data
    writeUserData();
  }

  // load data from shared preferences
  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userUsername = prefs.getString('username');
      userEmail = prefs.getString('email');
      userGender = prefs.getString('gender');
      userPassword = prefs.getString('password');
    });

    // if there is data, enable sign in button (if a user returns to sign up page from home page)
    // also push to home page
    if (prefs.getString('username') != "") {
      isSignInDisabled = false;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // write user data
  void writeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('username', userUsername);
      prefs.setString('email', userEmail);
      prefs.setString('gender', userGender);
      prefs.setString('password', userPassword);
    });

    isSignInDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to Deriv",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Image.network(
                "https://tradingbrokers.com/wp-content/uploads/2020/11/Deriv-Logo.png"),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Name',
                border: OutlineInputBorder(),
              ),
              controller: textControllerName,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: textControllerEmail,
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              controller: textControllerPassword,
            ),
            Container(
              child: DropdownButton<String>(
                value: _gender,
                items: genders.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text("Select a gender"),
                onChanged: (String? value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: isDisbled
                  ? null
                  : () {
                      final snackBar = SnackBar(
                        content:
                            const Text('You have signed up successfully! :)'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );

                      signUp();
                    },
              child: const Text('Sign up'),
            ),
            ElevatedButton(
              onPressed: isSignInDisabled
                  ? null
                  : () {
                      loadUserData();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                    },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var infoTextStyle = TextStyle(color: Colors.black, fontSize: 20);

  // delete data from sharedPreferences
  void removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    print("delete data");
    setState(() {
      prefs.setString('username', "");
      prefs.setString('email', "");
      prefs.setString('gender', "");
      prefs.setString('password', "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Hello Deriv",
                style: TextStyle(fontSize: 30),
              ),
              margin: EdgeInsets.all(40),
            ),
            Text(
              "Hello $userUsername",
              style: infoTextStyle,
            ),
            Text(
              "Emil: $userEmail",
              style: infoTextStyle,
            ),
            Text(
              "Gender: $userGender",
              style: infoTextStyle,
            ),
            ElevatedButton(
              onPressed: () {
                removeUserData();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: const Text('Delete account'),
            ),
          ],
        ),
      ),
    );
  }
}
