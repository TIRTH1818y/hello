import 'package:flutter/material.dart';
import 'package:hello/user%20input%20handing/test.dart';
import 'package:hello/user%20input%20handing/user_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("FLUTTER APP"),
      ),
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.cyan),
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (e)=>MyApps()),);},
                child: Text("I AM A BUTTON")),
          ),
          Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.cyan),
                onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (e)=>testapp()),);},
                child: Text("I AM A TEST BUTTON")),
          ),
        ],
      ),
    );
  }
}
