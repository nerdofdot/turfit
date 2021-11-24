import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:turfit/turfit_id_generator.dart';


class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();


  // called when onboarding is completed
  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>TurfitIdPage()),
            (Route<dynamic> route) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', height: 240,width: 240),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 21.0,color: Colors.black54),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Want a slot?",
          body:
          "Book a slot with ease in the turf you like. Restricted to Nashik city only.",
          image: _buildImage('openbook'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Deal with Turf",
          body:
          "Money dealing directly with the turfs! Show us your bargaining skills.",
          image: _buildImage('deal'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Unique Turfit ID",
          body:
          "While booking a slot on call, just tell them your permanent Turfit ID.",
          image: _buildImage('idperson'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Turf's feed",
          body:
          "Keep an eye on tournaments/events in turfs. Hope you win one of them!",
          image: _buildImage('wreath'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.lightBlueAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
