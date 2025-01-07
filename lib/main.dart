import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:thriftcycle/screens/profile_screen.dart';
import 'package:thriftcycle/screens/search_screen.dart';
import 'package:thriftcycle/screens/uploadscreen.dart';
import 'package:thriftcycle/screens/favorite_screen.dart';
import 'package:thriftcycle/wigedts/splashscreen.dart';
import '../screens/homepage.dart';
import '../screens/time_line.dart';
import '../screens/detail_product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSplashScreen = true;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  void _startSplashScreenTimer() {
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _isSplashScreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _isSplashScreen ?const Splashscreen() : const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool visibleSplashScreen = true;


  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Hero(tag: "Dash", child: const HomePage())),
    SearchScreen(),
    Center(child: Hero(tag: "Upload", child: UploadScreen())),
    Center(child: Hero(tag: "Favorite", child: const FavoriteScreen())),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Menampilkan halaman sesuai indeks
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: const Color(0x2C7C7D),
        buttonBackgroundColor: const Color(0xFF2C7C7D),
        color: const Color(0xFF2C7C7D),
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        height: 45,
        animationDuration: const Duration(milliseconds: 800),
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.add_a_photo,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_2_sharp,
            size: 30,
            color: Colors.white,
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Perbarui indeks saat item diklik
          });
        },
      ),
    );
  }
}