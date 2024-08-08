import 'package:ecommerce/provider/signup_provider.dart';
import 'package:ecommerce/screens/home_page.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/screens/signin.dart';
import 'package:ecommerce/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        // ChangeNotifierProvider(create: (context) => SigninProvider()),
        // ChangeNotifierProvider(create: (context) => CreateProvider()),
        // ChangeNotifierProvider(create: (context) => EditProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false, home: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SignupScreen();
  }
}
