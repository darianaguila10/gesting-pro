import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaInit {
  static final PreferenciaInit _intancia = new PreferenciaInit._internal();

  factory PreferenciaInit() {
    return _intancia;
  }
  PreferenciaInit._internal();
  SharedPreferences _prefs;

  iniPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isFirstTime() {
    var isFirstTime = _prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      _prefs.setBool('first_time', false);

      return false;
    } else {
      _prefs.setBool('first_time', false);
    
      return true;
    }
  }
}
