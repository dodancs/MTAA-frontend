import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';

class CatCard extends StatelessWidget {
  final Image coverImage;
  final String name, description;
  final int age;

  CatCard({this.coverImage, this.name, this.description, this.age});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              this.coverImage,
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          this.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                        Text(this.age.toString() + ' mesiacov')
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: Text(this.description),
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
          elevation: 6,
        ),
      ),
    );
  }
}
