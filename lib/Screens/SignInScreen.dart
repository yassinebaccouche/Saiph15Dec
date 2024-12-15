import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysaiph/Screens/ForgetPasswordScreen.dart';
import 'package:mysaiph/Screens/user_formulaire_one.dart';
import 'package:mysaiph/models/user.dart';
import 'package:mysaiph/resources/auth-methode.dart';
import 'package:mysaiph/responsive/responsive_layout_screen.dart';
import 'package:mysaiph/responsive/mobile_screen_layout.dart';
import 'package:mysaiph/responsive/web_screen_layout.dart';
import 'package:mysaiph/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>(); // Added form key

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return; // If the input is invalid, do not proceed further
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String res = await AuthMethodes().loginUser(
        email: _emailController.text.toLowerCase(),
        password: _passwordController.text,
      );

      if (res == 'success') {
        User loggedInUser = await getUserDetailsByEmail(_emailController.text.toLowerCase());
        await saveUserLocally(loggedInUser);

        if (context.mounted) {
          if (loggedInUser.Verified == "0") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserFormulaireOne(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
            );
          }
        }
      } else if (context.mounted) {
        showSnackBar(context, res);
      }
    } catch (e) {
      print("Error during login: $e");
      if (context.mounted) {
        showSnackBar(context, "An error occurred during login.");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<User> getUserDetailsByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return User.fromSnap(querySnapshot.docs[0]);
    } else {
      throw Exception("User not found");
    }
  }

  Future<void> saveUserLocally(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', user.email);
    // Add more user information as needed
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 350;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/backsignin.png'),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 100, // Adjust this value as per your requirement for vertical positioning
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 280 * fem,
                    height: 270 * fem,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Email Input Field
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Utilisateur',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer l\'identifiant';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16),
                              // Password Input Field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isPasswordObscured,
                                decoration: InputDecoration(
                                  hintText: 'Mot de passe',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordObscured
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordObscured = !_isPasswordObscured;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer le mot de passe';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPasswordPage(),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 120.0),
                                    child: Text(
                                      'Mot de passe oublié ?',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24),
                              // Sign In Button
                              Container(
                                width: 120 * fem,
                                child: ElevatedButton(
                                  onPressed: () {
                                    loginUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF00B2FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50 * fem),
                                    ),
                                    elevation: 2 * fem,
                                  ),
                                  child: !_isLoading
                                      ? const Text(
                                    'Connecter',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                  )
                                      : CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
