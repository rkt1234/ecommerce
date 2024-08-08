import 'package:ecommerce/provider/signin_provider.dart';
import 'package:ecommerce/screens/home_page.dart';
import 'package:ecommerce/screens/signup.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late SharedPreferences pref;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }
   @override
  void dispose() {
    // Clean up the controllers when the State is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SigninProvider>(
      builder: (context, provider, child) {
        return Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
        ),
        body: Flexible(
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      errorText: provider.emailError,
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                   TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText: provider.passwordError,
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                       bool navigate = await provider.checkValidity(
                              _emailController.text, _passwordController.text);
                          print(provider.toastMessage);
                          getToast(
                              context, provider.toastMessage, provider.icon);
                          if (navigate) {
                            await pref.setString('jwt_token', provider.jwt);
                            print(provider.jwt);
                            pushReplacement(
                                context,
                                HomeScreen(
                                  token: provider.jwt,
                                  // token: jwt,
                                ));
                          }
                      // Implement your sign up logic here
                    },
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      pushReplacement(context, SignupScreen());
                    },
                    child: const Text(
                      'New user? Signup',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )),
        )
        );
      }
    );
  }
}
