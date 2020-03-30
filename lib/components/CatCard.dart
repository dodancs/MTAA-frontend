import 'package:CiliCat/cat_font_icons.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/providers/CatsProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatCard extends StatelessWidget {
  final Cat _cat;
  final bool _liked;
  CatCard(this._cat, this._liked);

  void _onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            onTap: () => _onTap(context),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ShimmerImage(
                      picture: _cat.pictures[0],
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.9,
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
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _cat.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(_cat.age.toString() + ' mesiacov')
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: _cat.description,
                          style: DefaultTextStyle.of(context).style,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: _liked
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: palette[700],
                            onPressed: () {
                              Provider.of<CatsProvider>(context, listen: false)
                                  .like(_cat, _liked);
                            },
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: null,
                              ),
                              Text(_cat.commentsNum.toString())
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: null,
                          ),
                          Spacer(),
                          MaterialButton(
                            onPressed: null,
                            child: Text('Adoptovať'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        elevation: 6,
      ),
    );
  }
}
