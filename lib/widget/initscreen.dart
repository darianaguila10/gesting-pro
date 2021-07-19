import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';


class InitScreenW extends StatefulWidget {


  @override
  InitScreenState createState() => InitScreenState();
}

class InitScreenState extends State<InitScreenW> {
static const routeName = "/initscreen";
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).popAndPushNamed("/home");
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Bienvenido a Gesting Pro",
          body:
              "Gesting Pro es la aplicación ideal para gestionar sus finanzas personales de forma sencilla.",
          image: _buildImage('inits1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Reportes",
          body:
              "Obtenga reportes de sus ingresos y gastos por medio de gráficos.",
          image: _buildImage('inits2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Gestione sus datos",
          body:
              "Respalde sus datos de forma segura.",
          image: _buildImage('inits3'),
          decoration: pageDecoration,
        ),
       
        PageViewModel(
           title: "Comencemos",
         
          image: _buildImage('inits1'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Saltar'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('OK', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}


