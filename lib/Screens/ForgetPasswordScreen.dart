import 'package:flutter/material.dart';
import 'package:mysaiph/Screens/SignInScreen.dart';
import 'package:mysaiph/resources/auth-methode.dart'; // Import your AuthMethodes class

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Add this line

  @override
  Widget build(BuildContext context) {
    double baseWidth = 350;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          height: double.infinity, // Use double.infinity for full screen height
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/backgroundSignin.png'),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 32.7479248047 * fem,
                left: (MediaQuery.of(context).size.width - (180.78 * fem)) / 2,
                child: Align(
                  child: SizedBox(
                    width: 180.78 * fem,
                    height: 70.81 * fem,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0 * fem), // Adjust padding
                    child: Form( // Wrap your widgets with Form widget
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Veuillez entrer votre e-mail pour mettre à jour votre mot de passe',
                            style: TextStyle(
                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlign: TextAlign.center, // Center text
                          ),
                          SizedBox(height: 25 * fem),

                          TextFormField( // Use TextFormField for validation
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
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
                          SizedBox(height: 20 * fem),

                          SizedBox(height: 30 * fem),

                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15 * fem), // Adjust button padding
                                backgroundColor: Color(0xff156dc7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50 * fem),
                                ),
                                elevation: 2 * fem,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String email = _emailController.text.trim();
                                  String result = await AuthMethodes().resetPassword(email);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(result),
                                  ));
                                }
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                'Envoyer',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15 * fem),

                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            ),
                            child: Text(
                              'Retour à la page de connexion',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'Inter',
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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
