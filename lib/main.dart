import 'package:flutter/material.dart';
import 'package:matchapp/ChatlistScreen.dart' as chat;
import 'package:matchapp/LoginScreen.dart';
import 'package:matchapp/MusicScreen.dart';
import 'package:matchapp/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matchapp/ChatlistScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? username = prefs.getString('username');
  final String? email = prefs.getString('email');

  runApp(MyApp(
      token: token,
      username: username,
      email: email)); // token, username ve email'i MyApp'e ilet
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? username;
  final String? email;

  MyApp(
      {required this.token,
      required this.username,
      required this.email}); // token, username ve email parametreleri

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: token != null
          ? HomeScreen(id: "1", username: username ?? '', email: email ?? '')
          : LoginScreen(
              onLogin:
                  (id) {}), // Token varsa HomeScreen'e git, yoksa LoginScreen'e git
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String id;
  final String username;
  final String email;

  HomeScreen(
      {required this.id,
      required this.username,
      required this.email}); // ID, username ve email'i alacak şekilde düzenlendi

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MusicScreen(id: widget.id), // ID'yi MusicScreen'e geç
      ChatListScreen(userId: widget.id),
      ProfileScreen(
          onLogout: _logout,
          username: widget.username,
          email: widget.email), // username ve email'i ProfileScreen'e geç
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    await prefs.remove('email');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen(onLogin: (id) {})),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
