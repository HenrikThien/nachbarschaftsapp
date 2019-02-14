import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_images_slider/flutter_images_slider.dart';
import 'package:nachbar/app_state_container.dart';
import 'package:nachbar/models/app_state.dart';
import 'package:nachbar/models/offer_item.dart';
import 'package:nachbar/util/fab_animated.dart';
import 'package:nachbar/util/rating_bar.dart';
import 'package:nachbar/util/textwrapper.dart';

class DetailSliverPage extends StatefulWidget {
  final OfferItem offerItem;

  DetailSliverPage({@required this.offerItem});

  _DetailSliverPageState createState() => _DetailSliverPageState();
}

class _DetailSliverPageState extends State<DetailSliverPage> {
  double rating = 4.0;
  ScrollController _fabScrollController;
  AppState state;

  @override
  void initState() {
    super.initState();
    _fabScrollController = new ScrollController();
    _fabScrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _fabScrollController.dispose();
  }

  Widget _buildFab(BuildContext context) {
    double top = MediaQuery.of(context).size.height * 0.41 - 70.0;

    if (_fabScrollController.hasClients) {
      top -= _fabScrollController.offset;
      if (top <= 10) {
        top = -10;
      }
    }

    return new Positioned(
        top: top,
        right: -25.0,
        child: AnimatedFab(
          onIconClick: (String tag) {
            if (tag == 'edit') {}
          },
        ));
  }

  Widget _buildBody(BuildContext context, var container) {
    return Padding(
      padding: EdgeInsets.only(
        top: 5.0,
        right: 15.0,
        left: 15.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 3.0,
              child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Beschreibung',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DescriptionTextWidget(
                        text: '${widget.offerItem?.description.toString()}',
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 40.0, right: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15.0,
                        offset: Offset(0.0, 10.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 50.0, top: 10.0, right: 10.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(state.user.displayName,
                            style: TextStyle(
                                fontSize: 19.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.rate_review),
                            SizedBox(
                              width: 5.0,
                            ),
                            StarRating(
                              rating: this.rating,
                              onRatingChanged: (rating) =>
                                  setState(() => this.rating = rating),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('(32)'),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_city),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('49767 Twist'),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.score),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('281 Verkäufe / Tausche')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Hero(
                  tag: 'pb_pic',
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30.0),
                    alignment: FractionalOffset.centerLeft,
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/img/profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(50.0)),
                      border: new Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Card(
              elevation: 3.0,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Produktinformationen',
                      style: TextStyle(
                          fontSize: 19.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.monetization_on, color: Colors.black),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('${widget.offerItem.price} Nachbarschaftspunkte'),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('49767 Twist'),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.timer, color: Colors.black),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text('25 Dez 2018'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    state = container.state;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        NestedScrollView(
          controller: _fabScrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    '${widget.offerItem.title}',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  background: Hero(
                    tag: 'hero_${widget.offerItem.itemId}',
                    child: Carousel(
                      images: widget.offerItem.getNetworkImagesAsArray(),
                      showIndicator: false,
                      borderRadius: false,
                      animationDuration: Duration(milliseconds: 500),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            color: Colors.orange,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                _buildBody(context, container),
                //_buildFab(context),
              ],
            ),
          ),
        ),
        _buildFab(context)
      ],
    ));
  }
}
