import 'package:ecommerce/provider/signup_provider.dart';
import 'package:ecommerce/screens/home_page.dart';
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
              title: const Text('Sign Up'),
            ),
            body: Flexible(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        errorText: provider.nameError,
                        labelText: 'Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                      controller: _addressController,
                      decoration: InputDecoration(
                        errorText: provider.addressError,
                        labelText: 'Address',
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
                        // Implement your sign up logic here
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String address = _addressController.text.trim();
                        String password = _passwordController.text.trim();

                        // Call your provider method to handle signup
                        bool navigate = await provider.checkValidity(
                            email, password, address, name);
                        getToast(context, provider.toastMessage, provider.icon);
                        if (navigate) {
                          await pref.setString('jwt_token', provider.jwt);
                          print(provider.jwt);
                          pushReplacement(
                              context,
                              HomeScreen(
                                token: provider.jwt,
                              ));
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        pushReplacement(context, SigninScreen());
                      },
                      child: const Text(
                        'Already registered? Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
