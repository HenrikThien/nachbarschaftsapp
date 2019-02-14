import 'package:flutter/material.dart';

import 'package:flutter_walkthrough/flutter_walkthrough.dart';
import 'package:flutter_walkthrough/walkthrough.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/home.dart';

class WalkthroughPage extends StatelessWidget {
  final List<Walkthrough> list = [
    Walkthrough(
      title: 'Region festlegen',
      content: 'Wir benötigen Zugriff auf Ihren aktuellen Standort. Damit können wir Ihre Region festlegen.',
      imageIcon: Icons.location_on,
    ),
    Walkthrough(
      title: 'Profilbild',
      content: 'Denken Sie daran ein Profilbild hochzuladen. Das lässt Ihr Profil seriöser für andere Nutzer wirken.',
      imageIcon: Icons.face,
    ),
    Walkthrough(
      title: 'Was gibt es hier zu tun?',
      content: 'Sie können Leistungen anbieten, erbringen oder Gegenstände verkaufen/tauschen. Gehandelt wird ausschießlich mit der Sozialpunkte Währung.',
      imageIcon: Icons.attach_money,
    ),
    Walkthrough(
      title: 'Wie verdiene ich weitere Punkte?',
      content: 'Zu der Registrierung gibt es 20 Punkte, pro geworbenen neuen Nutzer legen wir 5 weitere Punkte für Sie oben drauf. Weiter punkte können Sie erhalten, indem Sie tauschen/leistungen erbringen.',
      imageIcon: Icons.whatshot,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return IntroScreen(
      list,
      new MaterialPageRoute(
        builder: (context) {
          //container.state.setDBKeyValue('showHowTo', false);
          return HomePage();
        }
      )
    );
  }
}