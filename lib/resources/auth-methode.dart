import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mysaiph/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/user.dart' as model;

class AuthMethodes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> SignUPUser({
    required String email,
    required String password,
    required String pseudo,
    required String Profession,
    required String phoneNumber,
    required String pharmacy,
    required String Datedenaissance,
    required Uint8List file,
    required String Verified,
    required String FullScore,
    required String PuzzleScore,
    required String CodeClient,
  }) async {
    String res = "some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          pseudo.isNotEmpty ||
          Profession.isNotEmpty ||
          phoneNumber.isNotEmpty ||
          pharmacy.isNotEmpty ||
          Datedenaissance.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //add user to database
        model.User user = model.User(
          lastLogin: DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch,
          pseudo: pseudo,
          uid: cred.user!.uid,
          email: email,
          followers: [],
          following: [],
          photoUrl: photoUrl,
          pharmacy: pharmacy,
          phoneNumber: phoneNumber,
          Profession: Profession,
          Datedenaissance: Datedenaissance,
          Verified: Verified,
          FullScore: FullScore,
          PuzzleScore: PuzzleScore,
          CodeClient: CodeClient,
        );
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<String> updateUser({
    required String currentPassword,
    required String pseudo,
    required String newEmail,
    required String phoneNumber,
    required String pharmacy,
    required String Datedenaissance,
    Uint8List? photoUrl,
    required String newPassword,
    required String Profession,
    required String CodeClient,
    required String Verified,
  }) async {
    try {
      User? user = _auth.currentUser;

      // Reauthenticate user
      AuthCredential credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword
      );

      await user.reauthenticateWithCredential(credential);

      // Update email without verification check
      await user.updateEmail(newEmail);

      // Update password if needed
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      // Update Firestore data
      Map<String, dynamic> updateData = {
        'email': newEmail,
        'pseudo': pseudo,
        'phoneNumber': phoneNumber,
        'pharmacy': pharmacy,
        'Datedenaissance': Datedenaissance,
        'Profession': Profession,
        'CodeClient': CodeClient,
      };

      if (photoUrl != null) {
        String photoURL = await StorageMethods()
            .uploadImageToStorage('profilePics', photoUrl, false);
        updateData['photoUrl'] = photoURL;
      }

      await _firestore.collection('users').doc(user.uid).update(updateData);

      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> _uploadPhoto(Uint8List photo, String userId) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('users/$userId/profile_${DateTime.now().millisecondsSinceEpoch}.png');
      UploadTask uploadTask = storageRef.putData(photo);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Photo upload error: $e");
      throw Exception("Failed to upload photo");
    }
  }





  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please enter all the fields";
      }

      // Logging in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Retrieve user data from Firestore
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check if the account is deactivated
      if (userSnapshot.exists && userSnapshot['isDeactivated'] == true) {
        // If the account is deactivated, sign out the user and return an error message
        await _auth.signOut();
        return "Your account is deactivated. Please contact support for assistance.";
      } else {
        // If the account is not deactivated, return success
        return "success";
      }
    } catch (err) {
      print("Error during login: $err");
      return "An error occurred while logging in";
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent successfully";
    } catch (error) {
      print("Error sending reset password email: $error");
      return "Failed to send password reset email";
    }
  }

  Future<String> deactivateAccount() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Mark the user as deactivated in Firestore
        await _firestore.collection('users').doc(currentUser.uid).update({
          'isDeactivated': true,
        });

        // Sign out the user
        await _auth.signOut();

        return "Account deactivated successfully";
      } else {
        return "User not logged in";
      }
    } catch (err) {
      print("Error during account deactivation: $err");
      return "Failed to deactivate account";
    }
  }

  Future<String> updateLastLoginAndScore({
    required String score,
  }) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {

        // Create a map with updated user data (excluding email and password)
        Map<String, dynamic> updatedUserData = {
          'lastLogin': DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch,
          'FullScore': score,

        };

        // Update the user's data in Firestore
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(updatedUserData);

        return "success";
      } else {
        return "User not logged in";
      }
    } catch (err) {
      print("Error during user update: $err");
      return "Some error occurred";
    }
  }

}
