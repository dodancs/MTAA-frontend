import 'package:CiliCat/providers/AuthProvider.dart';
import 'package:CiliCat/providers/StorageProvider.dart';
import 'package:CiliCat/settings.dart';
import 'package:flutter/material.dart';
import 'package:CiliCat/components/Heading1.dart';
import 'package:provider/provider.dart';

class SyncPage extends StatefulWidget {
  bool _doSync;
  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  String _error;
  double _progress;
  String _syncItem;

  Future<void> _doSync(BuildContext context) async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      widget._doSync = true;
    });

    await Provider.of<StorageProvider>(context, listen: false).doSync(auth,
        (status) {
      setState(() {
        _progress = status['progress'];
        _syncItem = status['action'];
        _error = status['error'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Heading1('Synchronizácia aplikácie'),
            ...widget._doSync == true
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Prosím čakajte, dokým sa aplikácia zosynchronizuje.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: LinearProgressIndicator(
                        backgroundColor: palette.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _error == null ? palette : palette[700]),
                        value: _progress,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(_syncItem == null
                        ? ''
                        : _error == null ? _syncItem : _error),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Počas režimu offline ste spravili niekoľko zmien. Chcete ich zosynchronizovať?',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 40),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () async =>
                              await Provider.of<StorageProvider>(context,
                                      listen: false)
                                  .removeSync((_) => true, notify: true),
                          child: Text('Nie'),
                          color: palette[600],
                        ),
                        MaterialButton(
                          onPressed: () => _doSync(context),
                          child: Text('Áno'),
                          color: palette,
                        ),
                      ],
                    )
                  ],
          ],
        ),
      ),
    );
  }
}
