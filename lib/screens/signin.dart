import 'package:ecommerce/provider/signin_provider.dart';
import 'package:ecommerce/screens/landing_screen.dart';
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
          resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text(
              'Sign In',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ),
        body: Flexible(
          child: Stack(
            children: [
              Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        cursorColor: Colors.grey,
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width:
                                    2.0), // Red border when the TextField is enabled but not focused
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: customize the border radius
                          ),
                          errorText: provider.emailError,
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width:
                                    2.0), // Red border when the TextField is focused
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: customize the border radius
                          ),
                          // border: InputBorder.none
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                          cursorColor: Colors.grey,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width:
                                    2.0), // Red border when the TextField is enabled but not focused
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: customize the border radius
                          ),
                          errorText: provider.passwordError,
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width:
                                    2.0), // Red border when the TextField is focused
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: customize the border radius
                          ),
                          // border: InputBorder.none
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
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
                                  LandingScreen(
                                    token: provider.jwt,
                                    // token: jwt,
                                  ));
                            }
                            // Implement your sign up logic here
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color.fromRGBO(
                                  223, 48, 33, 1), // Text (foreground) color
                            ),
                          child: const Text('CONTINUE')
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            pushReplacement(context, const SignupScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(
                                223, 48, 33, 1), // Text (foreground) color
                          ),
                          child: const Text('SIGNUP'),
                        ),
                      ),
                    ],
                  )),
                  provider.isLoading?const Center(child: CircularProgressIndicator(),):Container()
            ],
          )
        )
        );
      }
    );
  }
}
