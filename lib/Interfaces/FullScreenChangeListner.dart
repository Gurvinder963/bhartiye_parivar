import 'package:flutter/widgets.dart';

class FullScreenChangeListner with ChangeNotifier {
  bool isFullScreen = false;
  void setFullScreen(bool misFullScreen) {
    isFullScreen=misFullScreen;
    notifyListeners();
  }
}