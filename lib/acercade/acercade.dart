import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcercaDe extends StatelessWidget {
  static const String routeName = "/acercade";
  AcercaDe({Key key}) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      body: profileView(s,context),

    );
  }

  Widget profileView(Size s,context) {
    final ThemeData theme = Theme.of(context);
    bool darkModeOn = theme.brightness == Brightness.dark;
    double fontS = s.height > 600 ? 16.0 : 15.0;
    return Container(
      decoration: BoxDecoration(color: (!darkModeOn) ? Color(0xFF66AD69) : Color(0xFF302D2D)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: (s.height > 600 ? 90 : 70)),
            child: Stack(
              children: <Widget>[
                BounceInDown(
                  duration: Duration(milliseconds: 1000),
                  child: CircleAvatar(
                    radius: 60,
                    child: Image.asset(
                   (!darkModeOn) ?  "assets/images/logo.png" : "assets/images/acercaded.png",  
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 10),
            child: Text(
              "versión: 1.0.0",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
              child: Column(children: <Widget>[
            Expanded(
              flex: s.height < 700 ? 2 : 1,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElasticInRight(
                      duration: Duration(milliseconds: 1000),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        leading: CircleAvatar(
                          backgroundColor: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
                          child: Image.asset(
                            "assets/images/wat.png",
                          ),
                        ),
                        title: new InkWell(
                            child: new Text('Grupo de WhatsApp'),
                            onTap: () => launch(
                                'https://chat.whatsapp.com/Eyy7HWIhUWx9WX5a4MO6kJ')),
                      ),
                    ),
                    ElasticInLeft(
                      duration: Duration(milliseconds: 1000),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        leading: CircleAvatar(
                          backgroundColor: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
                          child: Image.asset(
                            "assets/images/tele.png",
                          ),
                        ),
                        title: new InkWell(
                            child: Text("Grupo de Telegram"),
                            onTap: () => launch('https://t.me/gesting')),
                      ),
                    ),
                    ElasticInRight(
                      duration: Duration(milliseconds: 1000),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
                          child: Image.asset(
                            "assets/images/gmail.png",
                          ),
                        ),
                        title: new InkWell(
                            child: Text("darian.aguila.vega@gmail.com"),
                            onTap: () =>
                                launch('mailto:darian.aguila.vega@gmail.com')),
                      ),
                    ),
                    ElasticInLeft(
                      duration: Duration(milliseconds: 1000),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        leading: CircleAvatar(
                          backgroundColor: (!darkModeOn) ? Colors.white : Theme.of(context).cardColor,
                          child: Image.asset(
                            "assets/images/ph.png",
                          ),
                        ),
                        title: new InkWell(
                            child: Text("55373907"),
                            onTap: () => launch('tel: 55373907')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: TypewriterAnimatedTextKit(
                      speed: Duration(milliseconds: 180),
                      repeatForever: true,
                      onTap: () {},
                      text: [
                        "Desarrollador: ProgD10 (Darian Aguila Vega)",
                      ],
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: fontS,
                      ),
                      textAlign: TextAlign.start,
                      alignment:
                          AlignmentDirectional.topStart // or Alignment.topLeft
                      ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "©Copyright 2020",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontS,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Todos los derechos reservados",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontS,
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
              ],
            ))
          ]))
        ],
      ),
    );
  }
}
