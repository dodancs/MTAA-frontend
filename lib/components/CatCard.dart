import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/models/Cat.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatCard extends StatelessWidget {
  final Cat cat;
  CatCard(this.cat);

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
                ShimmerImage(
                  picture: cat.pictures[0],
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.9,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            cat.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                          Text(cat.age.toString() + ' mesiacov')
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                            text: cat.description,
                            style: DefaultTextStyle.of(context).style,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.favorite),
                                color: palette[700],
                                onPressed: () {},
                              ),
                              Text('120')
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: null,
                              ),
                              Text('69')
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
                      )
                    ],
                  ),
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
