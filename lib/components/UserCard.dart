import 'package:CiliCat/models/User.dart';
import 'package:CiliCat/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:shimmer/shimmer.dart';

class UserCard extends StatelessWidget {
  final User user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl:
                    Uri.http(API_URL, '/pictures/${user.picture}').toString(),
                httpHeaders: {
                  'Authorization':
                      authProvider.getTokenType + ' ' + authProvider.getToken,
                },
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            user == null
                ? 'Lololo broke my app'
                : '${user.firstname} ${user.lastname}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          user.admin ? Text('Administrator') : Text('Používateľ'),
          SizedBox(height: 20),
          Divider(
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
