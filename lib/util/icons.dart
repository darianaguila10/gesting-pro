
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Map<int, IconData> icons = {
  0: Icons.category,
  1: Icons.fastfood,
  2: Icons.business_center,
  3: Icons.business,
  4: Icons.shopping_cart,
  5: Icons.flash_on,
  6: Icons.restaurant,
  7: Icons.child_care,
  8: Icons.airport_shuttle,
  9: Icons.airplanemode_active,
  10: Icons.local_gas_station,
  11: Icons.colorize,
  12: Icons.directions_bike,
  13: Icons.directions_car,
  14: Icons.motorcycle,
  15: Icons.person,
  16: Icons.tv,
  17: Icons.color_lens,
  18: Icons.attach_money,
  19: Icons.fitness_center,
  20: Icons.store_mall_directory,
  21: Icons.home,
  22: Icons.camera_alt,
  23: Icons.cake,
  24: Icons.weekend,
  25: Icons.beach_access,
  26: Icons.smoking_rooms,
  27: Icons.videogame_asset,
  28: Icons.call,
  29: Icons.build,
  30: Icons.theaters,
  31: Icons.speaker,
  32: Icons.smartphone,
  33: Icons.watch,
  34: Icons.ac_unit,
  35: CupertinoIcons.bus,
  36: CupertinoIcons.paw_solid,
  37: CupertinoIcons.lab_flask_solid,
  38: Icons.wifi,
  38: Icons.airline_seat_individual_suite,
  39: Icons.brush,
  40: Icons.assignment,
  41: Icons.account_balance,
  42: Icons.account_balance_wallet,
  43: Icons.school,
  44: Icons.redeem,
  45: Icons.local_laundry_service,
  46: CupertinoIcons.heart_solid,
  47: Icons.directions_boat,
  48: Icons.directions_transit,
  49: Icons.filter_hdr,
  50: Icons.phone_in_talk,
  51: Icons.opacity,
  52: Icons.perm_phone_msg,
















  


};

saveIcons(IconData i) {
  return i.codePoint.toString();
}
getIcons(int iconkey,[color=Colors.green]){
return Icon(icons[iconkey],color: color,);
}


