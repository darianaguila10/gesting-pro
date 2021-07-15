import 'dart:math';

getAleatorio(int cant) {
  String n = "";
  var rng = new Random();
  for (var i = 0; i < cant; i++) {
    n += rng.nextInt(10).toString();
  }
  return n;
}
