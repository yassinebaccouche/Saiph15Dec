import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysaiph/Screens/user_formulaire_two.dart';
import 'package:mysaiph/widgets/custom_text_field.dart';

import '../utils/utils.dart';
import '../widgets/profile_container.dart';

class UserFormulaireOne extends StatefulWidget {
  UserFormulaireOne({super.key});

  @override
  State<UserFormulaireOne> createState() => _UserFormulaireOneState();
}

class _UserFormulaireOneState extends State<UserFormulaireOne> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    pseudoController.dispose();
    telController.dispose();

  }
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


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      left: false,
      bottom: false,
      top: false,
      right: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Veuillez remplir le formulaire",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xff1331C4).withOpacity(0.5),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 0, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileContainer(
                    body: Column(
                      children: [
                        Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                              radius: 95,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor: Colors.grey,
                            )
                                : const CircleAvatar(
                              radius: 95,
                              backgroundImage: NetworkImage(
                                  'https://i.stack.imgur.com/l60Hf.png'),
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 20,
                                child: GestureDetector(
                                  onTap: selectImage,
                                  child: Image.asset(
                                    "assets/images/editpic.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Informations profil",
                      style: TextStyle(
                          color: const Color(0xff1331C4),
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer le Pseudo';
                                }
                                return null;
                              },
                              textController: pseudoController,
                              keyboardType: TextInputType.name,
                              label: "Pseudo",
                              prefixIcon: Icons.perm_identity_outlined),
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer la Date de Naissance';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.datetime,
                              label: "Date de Naissance",
                              prefixIcon: Icons.calendar_month_outlined,
                              textController: _dateController),
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                              textController: telController,
                              validatorFunction: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer le Numero du telephone';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              label: "Numero du téléphone",
                              prefixIcon: Icons.phone_outlined),
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un nouveau mot de passe';
                              }
                              return null;
                            },
                            label: "Nouveau MDP",
                            textController: _passwordController,
                            prefixIcon: Icons.key_outlined,
                            suffix: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          elevation: 0,
                          backgroundColor:
                          const Color(0xff1331C4).withOpacity(0.5),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) {
                                return UserFormulaireTwo(
                                  date: _dateController.text,
                                  mdp: _passwordController.text,
                                  pseudo: pseudoController.text,
                                  tel: telController.text,
                                  file: _image ?? Uint8List(0),
                                );
                              },
                            ));
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
