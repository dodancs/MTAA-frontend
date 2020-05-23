import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Heading2.dart';
import 'package:CiliCat/components/InfoSection.dart';
import 'package:CiliCat/components/OkDialog.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/screens/CatEditPage.dart';
import 'package:CiliCat/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CatDetailPage extends StatefulWidget {
  final FlareControls _flareControls = FlareControls();
  final String _uuid;

  final bool refreshOnExit;

  CatDetailPage(this._uuid, {this.refreshOnExit});

  @override
  _CatDetailPageState createState() => _CatDetailPageState();
}

class _CatDetailPageState extends State<CatDetailPage> {
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final catsProvider = Provider.of<CatsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final Cat _cat = catsProvider.catDetails(widget._uuid);

    bool _liked = authProvider.getCurrentUser.favourites.contains(widget._uuid);

    Future<bool> _backPressed() async {
      if (widget.refreshOnExit != null) {
        await catsProvider.getCats();
      }
      Navigator.of(context).pop();
      return Future.value(false);
    }

    if (_cat == null) return Container();

    return WillPopScope(
      onWillPop: () async => await _backPressed(),
      child: Scaffold(
        appBar: AppTitleBack(callback: _backPressed),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                tag: _cat,
                child: Material(
                  child: InkWell(
                    onDoubleTap: () async {
                      await Provider.of<CatsProvider>(context, listen: false)
                          .like(_cat, _liked);
                      setState(() {});
                      widget._flareControls.play('like');
                    },
                    child: Stack(
                      children: <Widget>[
                        CarouselSlider(
                          items: _cat.pictures.map((picture) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: ShimmerImage(
                                  picture: picture,
                                ),
                              );
                            });
                          }).toList(),
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.width * 0.9,
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _imageIndex = index;
                              });
                            },
                          ),
                        ),
                        _cat.adoptive
                            ? Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black38,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    CatFont.try_out,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              )
                            : Container(),
                        Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: FlareActor(
                                'assets/like.flr',
                                controller: widget._flareControls,
                                animation: 'idle',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _cat.pictures.map((url) {
                  int index = _cat.pictures.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _imageIndex == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: palette[700],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('Páči sa mi'),
                        ),
                      ],
                    ),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    onPressed: () async {
                      await Provider.of<CatsProvider>(context, listen: false)
                          .like(_cat, _liked);
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          color: palette[600],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text('Zdielať'),
                        ),
                      ],
                    ),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                        text: 'Na ČiliCat som našiel mačičku ' +
                            _cat.name +
                            '. Choď si ju pozrieť!',
                      ));
                      Fluttertoast.showToast(
                        msg: 'Informácie boli skopírované!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: palette,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                  ),
                  _cat.adoptive
                      ? MaterialButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(CatFont.cat),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text('Adoptovať'),
                              ),
                            ],
                          ),
                          color: palette,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Ďakujeme za záujem!'),
                                content: RichText(
                                  text: TextSpan(
                                    text:
                                        'Ak si chcete túto mačku adoptovať, ozvite sa nám na telefónnom čísle:\n\n+421 920 123 456\n\nĎakujeme!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Ok'))
                                ],
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Heading1(_cat.name),
                    RichText(
                      text: TextSpan(
                        text: _cat.description,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              InfoSection(_cat),
              _cat.health_log != ""
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Heading2('ZDRAVOTNÝ ZÁZNAM', Colors.black),
                          RichText(
                            text: TextSpan(
                              text: _cat.health_log,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       Heading2('KOMENTÁRE', Colors.black),
              //       RichText(
              //         text: TextSpan(
              //           text: widget._cat.description,
              //           style: Theme.of(context).textTheme.body1,
              //         ),
              //         softWrap: true,
              //         overflow: TextOverflow.fade,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        floatingActionButton: authProvider.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatEditPage(cat: _cat),
                    ),
                  );
                },
                child: Icon(Icons.edit),
                backgroundColor: palette,
              )
            : null,
      ),
    );
  }
}
