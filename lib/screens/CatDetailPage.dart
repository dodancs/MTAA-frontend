import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/AppTitleBack.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:CiliCat/components/Heading2.dart';
import 'package:CiliCat/components/InfoSection.dart';
import 'package:CiliCat/components/MainMenu.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatDetailPage extends StatefulWidget {
  final Cat _cat;

  CatDetailPage(this._cat);

  @override
  _CatDetailPageState createState() => _CatDetailPageState();
}

class _CatDetailPageState extends State<CatDetailPage> {
  int _imageIndex;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppTitleBack(),
      drawer: MainMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: widget._cat,
              child: Stack(
                children: <Widget>[
                  CarouselSlider(
                    items: widget._cat.pictures.map((picture) {
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
                  widget._cat.adoptive
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
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget._cat.pictures.map((url) {
                int index = widget._cat.pictures.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
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
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  child: Row(
                    children: <Widget>[
                      Icon(CatFont.cat),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('Adoptovať'),
                      ),
                    ],
                  ),
                  color: palette,
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                  onPressed: () {},
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Heading1(widget._cat.name),
                  RichText(
                    text: TextSpan(
                      text: widget._cat.description,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
            InfoSection(widget._cat),
            widget._cat.health_log != ""
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Heading2('LEKÁRSKY ZÁZNAM', Colors.black),
                        RichText(
                          text: TextSpan(
                            text: widget._cat.health_log,
                            style: Theme.of(context).textTheme.body1,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  )
                : Container(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Heading2('KOMENTÁRE', Colors.black),
                  RichText(
                    text: TextSpan(
                      text: widget._cat.description,
                      style: Theme.of(context).textTheme.body1,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: authProvider.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Icon(Icons.edit),
              backgroundColor: palette,
            )
          : null,
    );
  }
}
