import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  int _currentIndex = 0;
  String? _userId;
  String? _userName;
  bool _onboardingCompleted = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  int get currentIndex => _currentIndex;
  String? get userId => _userId;
  String? get userName => _userName;
  bool get onboardingCompleted => _onboardingCompleted;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoggedIn(bool value, {String? userId, String? userName}) {
    _isLoggedIn = value;
    _userId = userId;
    _userName = userName;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    notifyListeners();
  }
}
