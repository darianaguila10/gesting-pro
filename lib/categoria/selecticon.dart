import 'package:flutter/material.dart';
import 'package:gesting/categoria/selectcategory.dart';
import 'package:gesting/util/icons.dart';

class SelectIcon extends StatefulWidget {
  final category;

  SelectIcon(this.category);

  @override
  _SelectIconState createState() => _SelectIconState();
}

class _SelectIconState extends State<SelectIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Row(children: <Widget>[
          Text("Icono: "),
          Card(elevation: 5, 
            child: IconButton(
                icon: getIcons(widget.category.icon,),
                iconSize: 40,
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) => SelectCategory(widget.category.icon)))
                      .then((v) {
                 
                    if (v != null) widget.category.icon = v;
                  });
                }),
          ),
        ]));
  }
}
