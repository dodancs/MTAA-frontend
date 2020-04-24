import 'package:CiliCat/components/ConfirmDialog.dart';
import 'package:CiliCat/components/ErrorDialog.dart';
import 'package:CiliCat/components/ShimmerImage.dart';
import 'package:CiliCat/providers/PicturesProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PictureListInput extends StatefulWidget {
  List<String> pictures;

  final Function onChange;

  PictureListInput(this.pictures, this.onChange);

  @override
  _PictureListInputState createState() => _PictureListInputState();
}

class _PictureListInputState extends State<PictureListInput> {
  bool _loading = false;

  void _addPicture() async {
    setState(() {
      _loading = true;
    });

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var ret = await Provider.of<PicturesProvider>(context, listen: false)
          .add(image);
      if (!ret[0]) {
        showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(ret[1]),
        );
      } else {
        setState(() {
          if (widget.pictures == null) {
            widget.pictures = [];
          }
          widget.pictures.add(ret[1]);
          widget.onChange(widget.pictures);
        });
      }
    }

    setState(() {
      _loading = false;
    });
  }

  void _deletePicture(String uuid) async {
    bool r = await showDialog(
      context: context,
      builder: (BuildContext context) =>
          ConfirmDialog('Naozaj si prajete zmazať tento obrázok?'),
    );
    if (r) {
      var ret = await Provider.of<PicturesProvider>(context, listen: false)
          .remove(uuid);
      if (ret == null) {
        setState(() {
          widget.pictures.removeWhere((p) => p == uuid);
          widget.onChange(widget.pictures);
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(ret),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Obrázky',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        SizedBox(height: 10),
        Material(
          elevation: 8,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.5,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: _loading ? null : _addPicture,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: Center(
                        child: _loading
                            ? SpinKitThreeBounce(
                                color: palette[50],
                                size: 32,
                              )
                            : Icon(
                                Icons.add_circle,
                                size: 32,
                              ),
                      ),
                    ),
                  ),
                  ...(widget.pictures != null
                      ? widget.pictures.map((p) {
                          return Stack(
                            children: <Widget>[
                              ShimmerImage(
                                picture: p,
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                              ),
                              Positioned(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () => _deletePicture(p),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: Center(
                                        child: Icon(
                                          Icons.delete,
                                          color: palette[700],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                right: 10,
                                top: 10,
                              )
                            ],
                          );
                        }).toList()
                      : [])
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
