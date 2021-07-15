import 'package:flutter/material.dart';
import 'package:gesting/database/models/ingreso_gasto_categ.dart';
import 'package:gesting/util/converter.dart';
import 'package:gesting/util/icons.dart';


class CatCardWidget extends StatelessWidget {
 
  final IngGastCategory inggastCategory;



final int icon;
  CatCardWidget(
      this.inggastCategory,this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4,
        margin: new EdgeInsets.symmetric(horizontal: 3, vertical: 4.0),
        child: InkWell(
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7))),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(left: BorderSide(color: inggastCategory.color??Colors.green, width: 4))),
              child: ListTile(dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                leading: getIcons( inggastCategory.icon,inggastCategory.color),
                title: Text(
                  inggastCategory.title[0].toUpperCase() + inggastCategory.title.substring(1),
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(
                  formatearMoneda(inggastCategory.cant) + " " + prefs.monedaPrincipal,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          onTap: () {
          
          },
          onLongPress: () {
           
          },
          borderRadius: BorderRadius.circular(10),
        ));
  }
}
