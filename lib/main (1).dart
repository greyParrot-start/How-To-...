import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isLoggedIn ? HomeScreen() : InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Container(
        color: const Color.fromARGB(255, 136, 51, 248), // Replace with any color you prefer
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text('Go to Login'),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameCAController = TextEditingController();
  final  _passwordCAController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameLIController = TextEditingController();
  final TextEditingController _passwordLIController = TextEditingController();

  String _userWarnCA = '';
  String _passWarnCA = '';
  String _conPassWarnCA = '';
  String _userWarnLI = '';
  String _passWarnLI = '';

  bool _isLoggedIn = false;
  String? _loggedInUser;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    final loggedInUser = prefs.getString("loggedInUser");

    setState(() {
      _isLoggedIn = isLoggedIn;
      _loggedInUser = loggedInUser;
    });
  }

  Future<void> _createAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String username = _usernameCAController.text;
    String password = _passwordCAController.text;
    String confirmPassword = _confirmPasswordController.text;

    setState(() {
      _userWarnCA = '';
      _passWarnCA = '';
      _conPassWarnCA = '';
    });

    if (username.isEmpty) {
      setState(() => _userWarnCA = "Insert Username");
      return;
    } else if (prefs.containsKey(username)) {
      setState(() => _userWarnCA = "Username taken!");
      return;
    } else if (password.length < 8) {
      setState(() => _passWarnCA = "Password must be at least 8 characters!");
      return;
    } else if (confirmPassword != password) {
      setState(() => _conPassWarnCA = "Passwords do not match!");
      return;
    }

    // Save user credentials
    await prefs.setString(username, password);
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("loggedInUser", username);

    setState(() {
      _isLoggedIn = true;
      _loggedInUser = username;
    });
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    String username = _usernameLIController.text;
    String password = _passwordLIController.text;

    setState(() {
      _userWarnLI = '';
      _passWarnLI = '';
    });

    if (username.isEmpty) {
      setState(() => _userWarnLI = "Insert Username");
      return;
    } else if (password.isEmpty) {
      setState(() => _passWarnLI = "Insert Password");
      return;
    } else if (prefs.getString(username) == password) {
      await prefs.setBool("isLoggedIn", true);
      await prefs.setString("loggedInUser", username);

      setState(() {
        _isLoggedIn = true;
        _loggedInUser = username;
      });
    } else {
      setState(() => _passWarnLI = "Incorrect login information");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
    await prefs.remove("loggedInUser");

    setState(() {
      _isLoggedIn = false;
      _loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      body: Center(
        child: _isLoggedIn ? _buildUserInfo() : _buildLoginSection(),
      ),
    );
  }

  Widget _buildLoginSection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "User Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            _buildCreateAccountSection(),
            SizedBox(height: 20),
            _buildLoginSectionFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create an account", style: TextStyle(fontSize: 20, color: Colors.white)),
        TextField(controller: _usernameCAController, decoration: InputDecoration(hintText: "Username")),
        Text(_userWarnCA, style: TextStyle(color: Colors.red)),
        TextField(controller: _passwordCAController, obscureText: true, decoration: InputDecoration(hintText: "Password")),
        Text(_passWarnCA, style: TextStyle(color: Colors.red)),
        TextField(controller: _confirmPasswordController, obscureText: true, decoration: InputDecoration(hintText: "Confirm Password")),
        Text(_conPassWarnCA, style: TextStyle(color: Colors.red)),
        SizedBox(height: 10),
        ElevatedButton(onPressed: _createAccount, child: Text("Create Account")),
      ],
    );
  }

  Widget _buildLoginSectionFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Already have an account? Log in!", style: TextStyle(fontSize: 20, color: Colors.white)),
        TextField(controller: _usernameLIController, decoration: InputDecoration(hintText: "Username")),
        Text(_userWarnLI, style: TextStyle(color: Colors.red)),
        TextField(controller: _passwordLIController, obscureText: true, decoration: InputDecoration(hintText: "Password")),
        Text(_passWarnLI, style: TextStyle(color: Colors.red)),
        SizedBox(height: 10),
        ElevatedButton(onPressed: _login, child: Text("Log in")),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adds 20 pixels of padding at the top
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InitialScreen()),
              );
            },
            child: Text('Back to Home'),
          ),
        )
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Welcome, $_loggedInUser!", style: TextStyle(fontSize: 24, color: Colors.white)),
        SizedBox(height: 10),
        ElevatedButton(onPressed: _logout, child: Text("Log out")),
        Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adds 20 pixels of padding at the top
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InitialScreen()),
              );
            },
            child: Text('Back to Home'),
          ),
        )
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitialScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: Text('Logout'),
        ),
      ),
    );
  }
}
