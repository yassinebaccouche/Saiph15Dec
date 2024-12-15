import 'package:flutter/widgets.dart';
import '../Models/user.dart';
import '../resources/auth-methode.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethodes _authMethods = AuthMethodes();

  User get getUser => _user!;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
  Future<void> refreshUserData() async {
    try {
      // Call the method to fetch user details
      User user = await _authMethods.getUserDetails();
      // Set the fetched user details
      _user = user;
      // Notify listeners about the change
      notifyListeners();
    } catch (error) {
      // Handle any errors that might occur during data refresh
      print('Error refreshing user data: $error');
      // You can throw an exception or handle the error as per your requirement
      throw error;
    }
  }
  void updateUserFullScore(String newScore) {
    if (_user != null) {
      _user!.FullScore = newScore;
      notifyListeners(); // Notify listeners about the change
    }
  }
}
