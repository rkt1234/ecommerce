import 'package:ecommerce/provider/signup_provider.dart';
import 'package:ecommerce/screens/landing_screen.dart';
import 'package:ecommerce/screens/signin.dart';
import 'package:ecommerce/services/navigation_service.dart';
import 'package:ecommerce/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Text editing controllers
  late SharedPreferences pref;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Builder(builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                'Sign Up',
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white,
                                width:
                                    2.0), // Red border when the TextField is enabled but not focused
                            borderRadius: BorderRadius.circular(
                                10.0), // Optional: customize the border radius
                          ),
                          errorText: provider.nameError,
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
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
                        controller: _emailController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            errorText: provider.emailError,
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is enabled but not focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        cursorColor: Colors.grey,
                        controller: _addressController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is enabled but not focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            errorText: provider.addressError,
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        cursorColor: Colors.grey,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is enabled but not focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            errorText: provider.passwordError,
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white,
                                  width:
                                      2.0), // Red border when the TextField is focused
                              borderRadius: BorderRadius.circular(
                                  10.0), // Optional: customize the border radius
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            )),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Implement your sign up logic here
                            String name = _nameController.text.trim();
                            String email = _emailController.text.trim();
                            String address = _addressController.text.trim();
                            String password = _passwordController.text.trim();
                        
                            // Call your provider method to handle signup
                            bool navigate = await provider.checkValidity(
                                email, password, address, name);
                            getToast(
                                context, provider.toastMessage, provider.icon);
                            if (navigate) {
                              await pref.setString('jwt_token', provider.jwt);
                              print(provider.jwt);
                              pushReplacement(
                                  context,
                                  LandingScreen(
                                    token: provider.jwt,
                                  ));
                            }
                          },
                          child: const Text('CONTINUE'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Color.fromRGBO(223, 48, 33, 1), // Text (foreground) color
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            pushReplacement(context, SigninScreen());
                          },
                          child: const Text('SIGNIN'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromRGBO(
                                223, 48, 33, 1), // Text (foreground) color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
              ],
            )),
          );
        });
      },
    );
  }
}
