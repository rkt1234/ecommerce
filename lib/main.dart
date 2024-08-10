import 'package:ecommerce/provider/cart_provider.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/provider/signin_provider.dart';
import 'package:ecommerce/provider/signup_provider.dart';
import 'package:ecommerce/screens/cart_page.dart';
import 'package:ecommerce/screens/home_page.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => SigninProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: MyApp(prefs: prefs))));
}

class MyApp extends StatefulWidget {
  final prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return CartPage();
     String? token = widget.prefs.getString('jwt_token');
    if (token == null || JwtDecoder.isExpired(token)) {
      return const SignupScreen();
    } else {
      return HomeScreen(token: token);
      // return const ProductPage();
      // return CartPage();
    }
  }
  }

