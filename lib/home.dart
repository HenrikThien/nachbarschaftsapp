import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/detail_sliver.dart';
import 'package:nachbar/dialogs/new_service_dialog.dart';
import 'package:nachbar/models/app_state.dart';
import 'package:nachbar/all_items.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:nachbar/settings_page.dart';
import 'package:nachbar/util/my_wallet.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

enum PopUpActions { logout, settings }

class _HomePageState extends State<HomePage> {
  AppState state;
  int accountBalance = 0;

  void initWallet() async {
    var b = await MyWallet.getContractBalance(state.wallet.credentials);
    //print(state.wallet.credentials.address.toString());
    if (this.mounted) {
      setState(() {
        accountBalance = b;
      });
    }
  }

  List<Widget> _buildOfferItemCard(AppState state) {
    List<Widget> widgets = new List<Widget>();

    state.offerItems.forEach((item) {
      widgets.add(_buildItemCard(item));
      widgets.add(new SizedBox(
        width: 10.0,
      ));
    });

    return widgets;
  }

  Widget _noItemsFoundCard() {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.red,
            size: 50.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text("Sie haben bisher noch keine Angebote erstellt!"),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Klicken Sie auf \"Erstellen\".",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(OfferItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailSliverPage(
                    offerItem: item,
                  )),
        );
      },
      child: Hero(
        tag: 'hero_${item.itemId}',
        child: Container(
          width: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
              image: CachedNetworkImageProvider('${item.images[0]}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "${item.title}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    state = container.state;

    initWallet();

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('49767 Twist', style: TextStyle(color: Colors.white))),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          PopupMenuButton<PopUpActions>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (PopUpActions result) async {
              if (result == PopUpActions.logout) {
                try {
                  await container.signOut();
                } catch (e) {
                  // wtf?
                }
              }
              if (result == PopUpActions.settings) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<PopUpActions>>[
                  const PopupMenuItem<PopUpActions>(
                    value: PopUpActions.settings,
                    child: Text('Einstellungen'),
                  ),
                  const PopupMenuItem<PopUpActions>(
                    value: PopUpActions.logout,
                    child: Text('Abmelden'),
                  ),
                ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Erstellen'),
        icon: Icon(Icons.create),
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return CreateNewServiceDialog();
            },
            fullscreenDialog: true,
          ));
        },
      ),
      body: Container(
        color: Colors.orange,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: <Widget>[
                    Hero(
                      tag: 'pb_pic',
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/img/profile.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Wilkommen zurück ✌🏻,',
                          style: TextStyle(color: Colors.white),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: <Widget>[
                              Text(
                                (state.user != null)
                                    ? state.user?.displayName
                                    : '-',
                                style: Theme.of(context).textTheme.title,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                        Text('$accountBalance NCHBR',
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Meine Angebote',
                      style: Theme.of(context).textTheme.title,
                    ),
                    FlatButton(
                      child: Text(
                        'Alle ansehen (${state.offerItems.length})',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllItemsPage()),
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              (state.offerItems.length > 0)
                  ? (Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 200.0,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: _buildOfferItemCard(state)),
                    ))
                  : _noItemsFoundCard(),
              Divider(
                height: 50.0,
                color: Colors.white,
              ),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Angebote in meiner Nähe',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
