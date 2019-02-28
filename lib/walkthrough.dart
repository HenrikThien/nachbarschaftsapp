import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalkthroughPage extends StatefulWidget {
  final VoidCallback onPageClose;

  WalkthroughPage({this.onPageClose});

  @override
  _WalkthroughPageState createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  List<Slide> slides = new List<Slide>();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: 'Standort',
        styleTitle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 25.0,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        styleDescription: TextStyle(
            fontFamily: 'Quicksand', fontSize: 18.0, color: Colors.white),
        description:
            'Unser Service benutzt Ihren aktuellen Standort um einen Radius festzulegen. In diesem Radius können sie Dienstleistungen anbieten/suchen oder Produkte kaufen/verkaufen.',
        pathImage: 'assets/img/tut/001-map.png',
        backgroundColor: Colors.orange[300],
      ),
    );

    slides.add(new Slide(
      title: 'Punkte verdienen',
      styleTitle: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 25.0,
          color: Colors.white,
          fontWeight: FontWeight.bold),
      styleDescription: TextStyle(
          fontFamily: 'Quicksand', fontSize: 18.0, color: Colors.white),
      description:
          'Sie können sich weitere Punkte hinzuverdienen indem Sie soziale Aufgaben für andere erledigen. Mit den gesammelten Punkten können Sie Produkte oder Dienstleistungen bezahlen.',
      pathImage: 'assets/img/tut/003-get-money.png',
      backgroundColor: Colors.orange[400],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return new IntroSlider(
      slides: this.slides,
      onDonePress: () async {
        // disable walkthrough page for this user
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('walkthrough', false);

        setState(() {
          container.state.showWalkthroughPage = false;
        });

        widget.onPageClose();
      },
      onSkipPress: () async {
        final prefs = await SharedPreferences.getInstance();
        // next time, show it again
        prefs.setBool('walkthrough', true);
        // skip it for now
        setState(() {
          container.state.showWalkthroughPage = false;
        });

        widget.onPageClose();
      },
    );
  }
}
