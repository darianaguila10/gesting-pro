import 'package:flutter/services.dart';

validateForm() {
  return [
    WhitelistingTextInputFormatter(
        RegExp(r"^(\d?)+\.?\d{0,2}")), LengthLimitingTextInputFormatter(10)
  ];
}
validateLic() {
  return [
    WhitelistingTextInputFormatter(
        RegExp(r"^(\d?)+")), LengthLimitingTextInputFormatter(6)
  ];
}