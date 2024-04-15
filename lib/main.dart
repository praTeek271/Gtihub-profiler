import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = '';
  String avatarUrl = '';
  int reposCount = 0;
  int followers = 0;
  bool isButtonCross = false;

  Future<void> fetchUserData(String username) async {
    final response =
    await http.get(Uri.https('api.github.com', 'users/$username'));
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        reposCount = userData['public_repos'];
        followers = userData['followers'];
        avatarUrl = userData['avatar_url'];
        isButtonCross = true;
      });
    } else {
      setState(() {
        reposCount = 0;
        followers = 0;
        avatarUrl = '';
        isButtonCross = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 150,
                height: 80,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Enter GitHub Username'),
                        content: TextField(
                          onChanged: (value) {
                            username = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(username);
                            },
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    );

                    if (result != null && result.isNotEmpty) {
                      fetchUserData(result);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.transparent; // Change color for pressed state if needed
                        }
                        return Colors.transparent;
                      },
                    ),
                    shape: MaterialStateProperty.all(
                      isButtonCross
                          ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      )
                          : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: isButtonCross
                      ? Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.black,
                    shadows: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  )
                      : Text(
                    'Enable',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.5,
                      fontFamily: 'Ariel',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (isButtonCross) ...[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                SizedBox(height: 20),
                Text('Username: $username',
                    style: TextStyle(color: Colors.white)),
                Text('Total Repos: $reposCount',
                    style: TextStyle(color: Colors.white)),
                Text('Followers: $followers',
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (username.isNotEmpty) {
                      final url = 'https://github.com/$username';
                      // Use package 'url_launcher' to launch the URL in a browser
                      // Example: https://pub.dev/packages/url_launcher
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'View on GitHub',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
