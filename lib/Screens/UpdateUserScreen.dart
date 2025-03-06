import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysaiph/resources/auth-methode.dart';
import 'package:mysaiph/utils/utils.dart';
import 'package:mysaiph/Responsive/mobile_screen_layout.dart';
import 'package:mysaiph/Responsive/responsive_layout_screen.dart';
import 'package:mysaiph/Responsive/web_screen_layout.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key}) : super(key: key);

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController pharmacieController = TextEditingController();
  final TextEditingController codeClientController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  String selectedProfession = 'Profession';

  List<String> professions = [
    'Profession',
    'Pharmacist',
    'Doctor',
    'Other',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateNaissanceController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  void selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List? img = await pickImage(ImageSource.camera);
                  if (img != null) {
                    setState(() => _image = img);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  Uint8List? img = await pickImage(ImageSource.gallery);
                  if (img != null) {
                    setState(() => _image = img);
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
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Current password is required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String result = await AuthMethodes().updateUser(
        currentPassword: _currentPasswordController.text,
        pseudo: pseudoController.text,
        newEmail: _emailController.text,
        phoneNumber: telController.text,
        pharmacy: pharmacieController.text,
        Datedenaissance: dateNaissanceController.text,
        photoUrl: _image,
        Verified: '1',
        newPassword: _passwordController.text,
        Profession: selectedProfession,
        CodeClient: codeClientController.text,
      );

      if (result == "success") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResponsiveLayout(
              mobileScreenLayout: const MobileScreenLayout(),
              webScreenLayout: const WebScreenLayout(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    pseudoController.dispose();
    _emailController.dispose();
    dateNaissanceController.dispose();
    telController.dispose();
    _passwordController.dispose();
    pharmacieController.dispose();
    codeClientController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36 * fem, vertical: 37 * fem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Merci de remplir le formulaire',
                style: TextStyle(fontSize: 16 * ffem, color: const Color(0xff273085)),
              ),
              SizedBox(height: 12 * fem),

              // Profile Picture
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 60,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo, color: Color(0xff273085)),
                    ),
                  ),
                ],
              ),
              Text(
                'Ajouter une photo',
                style: TextStyle(fontSize: 16 * ffem, color: Colors.grey),
              ),
              SizedBox(height: 16 * fem),

              // Current Password Field
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Current Password (required for changes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              // Other Form Fields
              TextFormField(
                controller: pseudoController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Pseudo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: _emailController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: dateNaissanceController,
                readOnly: true,
                textAlign: TextAlign.center,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'Date de Naissance',
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: telController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: pharmacieController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Nom de la pharmacie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              TextFormField(
                controller: codeClientController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'Code Client CRM',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              DropdownButtonFormField<String>(
                value: selectedProfession,
                items: professions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() => selectedProfession = newValue!);
                },
                decoration: InputDecoration(
                  labelText: 'Profession',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
              ),
              SizedBox(height: 16 * fem),

              ElevatedButton(
                onPressed: _isLoading ? null : updateUserInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff273085),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50 * fem),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 16 * ffem, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}