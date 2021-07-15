import 'package:flutter/material.dart';
class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 50.0,
                      /*width: MediaQuery.of(context).size.width / 2 - 40.0,*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            onPressed: null,
                            child: IconButton(
                                icon: Icon(Icons.home,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {}),
                          ),
                          FlatButton(
                            onPressed: null,
                            child: IconButton(
                                icon: Icon(Icons.usb,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {}),
                          ),
                        ],
                      )),
                  Container(
                      height: 50.0,
                      /* width: MediaQuery.of(context).size.width / 2 - 40.0,*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            onPressed: null,
                            child: IconButton(
                                icon: Icon(Icons.home,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {}),
                          ),
                          FlatButton(
                            onPressed: null,
                            child: IconButton(
                                icon: Icon(Icons.usb,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {}),
                          ),
                        ],
                      )),
                ])));
  }
}