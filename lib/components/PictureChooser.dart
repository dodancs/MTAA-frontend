import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/providers/PicturesProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PictureChooser extends StatefulWidget {
  String picture;
  final Function onChange;

  PictureChooser(this.picture, this.onChange);

  @override
  _PictureChooserState createState() => _PictureChooserState();
}

class _PictureChooserState extends State<PictureChooser> {
  bool _loading = false;

  void _changePicture() async {
    setState(() {
      _loading = true;
    });

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var ret = await Provider.of<PicturesProvider>(context, listen: false)
          .remove(widget.picture);

      if (ret == null) {
        ret = await Provider.of<PicturesProvider>(context, listen: false)
            .add(image);
        if (!ret[0]) {
          showDialog(
            context: context,
            builder: (BuildContext context) => ErrorDialog(ret[1]),
          );
        } else {
          setState(() {
            widget.picture = ret[1];
            widget.onChange(widget.picture);
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(ret),
        );
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Obrázok',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 10),
        Material(
          elevation: 4,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              children: <Widget>[
                ShimmerImage(
                  picture: widget.picture,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white70,
                    ),
                    width: 75,
                    height: 75,
                    child: IconButton(
                      icon: Icon(
                        Icons.cloud_upload,
                        size: 32,
                      ),
                      onPressed: _changePicture,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
