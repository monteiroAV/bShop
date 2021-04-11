import 'package:flutter/cupertino.dart';

class LoginManager {
  LoginManager(this._pageController);
  final PageController _pageController;

  void setPage(int value) {
    _pageController.animateToPage(value,
    
        duration: const Duration(milliseconds: 550), curve: Curves.easeOutQuart);
  }
}
