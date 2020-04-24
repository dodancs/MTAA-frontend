import 'package:CiliCat/settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerImage extends StatelessWidget {
  final String picture;
  final double width, height;

  ShimmerImage({this.picture, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return CachedNetworkImage(
      imageUrl: Uri.http(API_URL, '/pictures/$picture').toString(),
      httpHeaders: {
        'Authorization':
            authProvider.getTokenType + ' ' + authProvider.getToken,
      },
      fit: BoxFit.cover,
      width: width,
      height: height,
      placeholder: (context, url) => SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
