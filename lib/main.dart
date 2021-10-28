import 'package:flutter/material.dart';

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

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String> genders = ['male', 'female', 'other', 'rather not say'];
  String? _gender;

  final textControllerName = TextEditingController();
  final textControllerEmail = TextEditingController();
  final textControllerPassword = TextEditingController();

  bool isDisbled = true;

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textControllerName.addListener(isFilled);
    textControllerEmail.addListener(isFilled);
    textControllerPassword.addListener(isFilled);
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
                items: <String>['male', 'female', 'other', 'rather not say']
                    .map<DropdownMenuItem<String>>((String value) {
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
                    },
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
