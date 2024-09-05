import 'package:ecommerce/screens/cart_page.dart'; // Import the CartPage
import 'package:ecommerce/screens/home_screen.dart';
import 'package:ecommerce/screens/profile_page.dart';
import 'package:ecommerce/screens/signin.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  final String token;
  const LandingScreen({super.key, required this.token});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late SharedPreferences pref;
  int _selectedIndex = 0;
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    print(widget.token);
    _pages.addAll([
      HomePage(token: widget.token),
      CartPage(token: widget.token), // CartPage widget
      ProfilePage(token: widget.token),
    ]);
  }

    void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await pref.remove('jwt_token');
                pushReplacement(context, const SigninScreen());
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("Shopnow"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
