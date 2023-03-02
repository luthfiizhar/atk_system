import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  bool _shadowActive = false;
  bool _isScrolling = false;
  bool _isScrollAtEdge = false;
  double _scrollPosition = 0;
  bool _upBottonVisible = false;

  bool get shadowActive => _shadowActive;
  bool get isScrolling => _isScrolling;
  bool get isScrollAtEdge => _isScrollAtEdge;
  double get scrollPosition => _scrollPosition;
  bool get upBottonVisible => _upBottonVisible;

  void setIsScrollAtEdge(bool value) {
    _isScrollAtEdge = value;
    notifyListeners();
  }

  void setScrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  void setIsScrolling(bool value) {
    _isScrolling = value;
    notifyListeners();
  }

  void setShadowActive(bool value) {
    _shadowActive = value;
    notifyListeners();
  }

  void setUpBotton(bool value) {
    _upBottonVisible = value;
    notifyListeners();
  }
}
