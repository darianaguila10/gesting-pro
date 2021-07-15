import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaMoneda {
  static final PreferenciaMoneda _intancia = new PreferenciaMoneda._internal();

  factory PreferenciaMoneda() {
    return _intancia;
  }
  PreferenciaMoneda._internal();
  SharedPreferences _prefs;

  iniPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get monedaPrincipal {
    return _prefs.getString('monedaprincipal') ?? 'CUP';
  }

  set monedaPrincipal(String mp) {
    _prefs.setString('monedaprincipal', mp);
  }

  get cupToCuC {
    return _prefs.getDouble('cup-cuc') ?? 25.0;
  }

  set cupToCuC(double val) {
    _prefs.setDouble('cup-cuc', val);
  }

  get cucToCup {
    return _prefs.getDouble('cuc-cup') ?? 24.0;
  }

  set cucToCup(double val) {
    _prefs.setDouble('cuc-cup', val);
  }

  get usdToCuc {
    return _prefs.getDouble('usd-cuc') ?? 0.95;
  }

  set usdToCuc(double val) {
    _prefs.setDouble('usd-cuc', val);
  }
  get eurToCuc {
    return _prefs.getDouble('eur-cuc') ?? 0.95;
  }

  set eurToCuc(double val) {
    _prefs.setDouble('eur-cuc', val);
  }
}
