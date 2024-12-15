import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysaiph/Screens/HomeScreen.dart';
import 'package:mysaiph/utils/utils.dart';
import 'package:mysaiph/resources/auth-methode.dart';

import '../Responsive/mobile_screen_layout.dart';
import '../Responsive/responsive_layout_screen.dart';
import '../Responsive/web_screen_layout.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController dateNaissanceController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController pharmacieController = TextEditingController();
  TextEditingController CodeClientController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  List<String> professions = [
    'Profession',
    'Pharmacist',
    'Doctor',
    'Profession 3',
    // Add more professions as needed
  ];

  String selectedProfession = 'Profession'; // Default selected profession

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    CodeClientController.dispose();
    pseudoController.dispose();
    pharmacieController.dispose();
    telController.dispose();
  }

  void selectImage() async {
    // Show a dialog to choose between camera and gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List img = await pickImage(ImageSource.camera);
                  if (img != null) {
                    setState(() {
                      _image = img;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List im = await pickImage(ImageSource.gallery);
                  if (im != null) {
                    setState(() {
                      _image = im;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void updateUserInfo() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // Call the AuthMethods updateUser function
    String result = await AuthMethodes().updateUser(
      pseudo: pseudoController.text,
      CodeClient: CodeClientController.text,
      phoneNumber: telController.text,
      pharmacy: pharmacieController.text,
      Datedenaissance: _dateController.text,
      photoUrl: _image!,
      Verified: '1',

      newPassword: _passwordController.text,
      Profession: selectedProfession,
    );

    // Check the result and show appropriate messages or navigate to another screen
    if (result == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
      // User data updated successfully
      // You can navigate to another screen or show a success message
    } else {

      // Some error occurred
      // Display an error message to the user
    }

    // set loading to false after the operation is complete
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(


      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(36 * fem, 37 * fem, 36.83 * fem, 43 * fem),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(20 * fem),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0.17 * fem, 12 * fem),
                child: Text(
                  'Merci de remplir le formulaire',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.red,
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: Colors.red,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 60,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Color(0xff273085),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0.83 * fem, 0 * fem, 0 * fem, 19 * fem),
                child: Text(
                  'Ajouter une photo',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Colors.grey,
                  ),
                ),
              ),
              // Your remaining UI components
              Center(

                child: Text(
                  'informations profil',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 9 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: pseudoController,

                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Pseudo',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Pseudo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


          Container(
            margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
            width: double.infinity,
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 332,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xff273085)),
                      ),
                      child: TextFormField(
                        controller: _dateController,
                        keyboardType: TextInputType.datetime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff273085),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Date de Naissance',

                          hintStyle: TextStyle(

                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                            color: Color(0xff273085),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Date de Naissance';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 13 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                           controller: telController,

                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Numero du telephone',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Numero du telephone';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                width: double.infinity,
                height: 54 * fem,
                child:Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Entrez un nouveau mot de passe',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Entrez un nouveau mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(

                child: Text(
                  'informations pharmacie',
                  style: TextStyle(
                    fontSize: 16 * ffem,
                    color: Color(0xff273085),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 11 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: pharmacieController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Nom de la pharmacie',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Nom de la pharmacie';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 19 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0 * fem,
                      top: 0 * fem,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 307.17 * fem,
                          height: 54 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            border: Border.all(color: Color(0xff273085)),
                          ),
                          child: TextFormField(
                            controller: CodeClientController,
                            textAlign: TextAlign.center,
                            style: TextStyle(

                              fontSize: 16 * ffem,
                              color: Color(0xff273085),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(

                              border: InputBorder.none,
                              hintText: 'Code Client CRM',
                              hintStyle: TextStyle(
                                fontSize: 16 * ffem,
                                color:Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the Code';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 19 * fem),
                width: double.infinity,
                height: 54 * fem,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 307.17 * fem,
                    height: 54 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50 * fem),
                      border: Border.all(color: Color(0xff273085)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value: selectedProfession,
                        icon: Icon(Icons.arrow_drop_down, color: Color(0xff273085)),
                        iconSize: 24 * ffem,
                        elevation: 16,
                        style: TextStyle(
                          fontSize: 16 * ffem,
                          color: Color(0xff273085),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProfession = newValue!;
                          });
                        },
                        items: professions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                textAlign: TextAlign.center, // Center the text
                                style: TextStyle(
                                  fontSize: 16 * ffem,
                                  color: Color(0xff273085),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        underline: Container(), // Remove the underline
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
              ),



              Container(
                margin: EdgeInsets.fromLTRB(79 * fem, 0 * fem, 78.28 * fem, 0 * fem),
                width: double.infinity,
                height: 54 * fem,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0 * fem, 4 * fem),
                      blurRadius: 2 * fem,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                     updateUserInfo();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff273085),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50 * fem),
                    ),
                    elevation: 2 * fem,
                  ),
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 16 * ffem,
                      color: Colors.white,
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
