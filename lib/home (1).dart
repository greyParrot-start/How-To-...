import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  //Converted to stateful widget.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Home'),
        ),
        body: const Center(
          child: Icon(
            Icons.login, size: 150,
            color: Colors.purple,
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
// Suggested c