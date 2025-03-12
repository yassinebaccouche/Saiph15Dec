import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mysaiph/resources/auth-methode.dart'; // Corrected import statement
import 'package:mysaiph/widgets/custom_text_field.dart';
import 'package:mysaiph/widgets/game_widgets/rounded_button.dart';

import '../Responsive/mobile_screen_layout.dart';
import '../Responsive/responsive_layout_screen.dart';
import '../Responsive/web_screen_layout.dart';
import '../widgets/profile_container.dart';

class UserFormulaireTwo extends StatefulWidget {
  final String pseudo;
  final String date;
  final String tel;
  final String mdp;
  final Uint8List? file;

  UserFormulaireTwo({
    Key? key,
    required this.pseudo,
    required this.date,
    required this.tel,
    required this.mdp,
    this.file,
  }) : super(key: key);

  @override
  State<UserFormulaireTwo> createState() => _UserFormulaireTwoState();
}

class _UserFormulaireTwoState extends State<UserFormulaireTwo> {

  bool _isLoading = false;
  List<String> professions = [
    'Profession',
    'Pharmacist',
    'Doctor',
    'Other',  // Add more professions as needed
  ];

  String selectedProfession = 'Profession';
  TextEditingController pharmacyController = TextEditingController();
  TextEditingController crmController = TextEditingController();

  void updateUserInfo() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethodes().updateUser(
      pseudo: widget.pseudo,
      CodeClient: crmController.text.isEmpty ? 'CRM' : crmController.text,
      phoneNumber: widget.tel,
      pharmacy: pharmacyController.text.isEmpty ? 'Pharmacy' : pharmacyController.text,
      Datedenaissance: widget.date,
      photoUrl: widget.file ?? Uint8List(0),
      Verified: '1',
      newPassword: widget.mdp,
      Profession: selectedProfession,
    );

    if (result == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      // Handle error
    }

    setState(() {
      _isLoading = false;
    });
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
            top: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
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
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: MemoryImage(widget.file ?? Uint8List(0)),
                            child: widget.file == null ? Icon(Icons.person, size: 100) : null,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.pseudo,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Informations pharmacie",
                        style: TextStyle(
                          color: const Color(0xff1331C4),
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xff273085),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: pharmacyController,
                              decoration: InputDecoration(
                                hintText: 'Enter Pharmacy',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xff273085),
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: crmController,
                              decoration: InputDecoration(
                                hintText: 'Enter CRM',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xff273085),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: Center(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                    ),
                                    child: Transform.rotate(
                                      angle: 90 * pi / 180,
                                      child: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Color(0xff273085),
                                      ),
                                    ),
                                  ),
                                  items: professions
                                      .map(
                                        (e) => DropdownMenuItem(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ).copyWith(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              "$e ",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color:
                                                const Color(0xff273085),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                  onChanged: (selection) {
                                    setState(() {
                                      selectedProfession = selection!;
                                    });
                                  },
                                  value: selectedProfession,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    RoundedButton(
                      text: "Enregistrer",
                      backgroundColor: const Color(0xff1331C4).withOpacity(0.5),
                      strokeColor: Colors.transparent,
                      txtColor: Colors.white,
                      onPressed: () async {
                        updateUserInfo();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
